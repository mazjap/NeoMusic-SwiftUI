import SwiftUI

class DelayedTask {
    typealias T = Task<Void, Never>
    
    @MainActor
    private var t: (parent: T, child: T?, id: UInt16)?
    
    @MainActor
    private var parent: T? {
        get {
            t?.parent
        }
        set {
            if let newValue {
                self.t?.child?.cancel()
                self.t?.parent.cancel()
                
                if t != nil {
                    print("Cancelled task with id: \(id!)")
                    self.t = nil
                }
                
                self.t = (newValue, nil, .random(in: 0...UInt16.max))
                print("Starting task with id: \(id!)")
            } else {
                self.t = nil
            }
        }
    }
    
    @MainActor
    private var child: T? {
        t?.child
    }
    
    @MainActor
    private var id: UInt16? {
        t?.id
    }
    
    @MainActor
    var isCancelled: Bool {
        t?.parent.isCancelled ?? true
    }
    
    @MainActor
    func setTask(_ task: @escaping @Sendable () async -> Void, priority: TaskPriority? = nil, after seconds: TimeInterval = 0.01) {
        self.parent = Task(priority: priority) {
            guard let startId = self.id else {
                self.cancel()
                return
            }
            
            do {
                try await withTaskCancellationHandler(operation: {
                    try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                }) { @MainActor in
                    self.cancel()
                }
            } catch {
                // TODO: - use nserror
                NSLog("\(error as NSError)")
            }
            
            guard self.id == startId, !self.isCancelled else { return }
            
            self.t!.child = Task(priority: priority, operation: task)
        }
    }
    
    @MainActor
    func cancel() {
        parent = nil
    }
}

struct SearchView: View {
    // MARK: - State
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @State private var searchTerm: String = ""
    @State private var segmentedIndex: Int = 0
    @State private var searchType: SearchType = .library
    
    private var task = DelayedTask()
    
    
    // MARK: - Variables
    
    private let offsetHeight: CGFloat = 20
    
    // MARK: - Initializers
    
    init() {
        let backgroundColor = SettingsController.shared.colorScheme.backgroundGradient.first.uiColor
        let tableAppearance = UITableView.appearance()
        let cellAppearance = UITableViewCell.appearance()
        
        tableAppearance.showsVerticalScrollIndicator = false
        tableAppearance.backgroundColor = backgroundColor
        cellAppearance.backgroundColor = backgroundColor
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                SegmentedControl(index: $segmentedIndex, textColor: settingsController.colorScheme.textColor.color, background: settingsController.colorScheme.backgroundGradient.first)
                    .options(["Library", "Apple Music"])
                    .onChange(of: segmentedIndex) { newVal in
                        searchType = (newVal == 0 ? .library : .applemusic)
                    }
                    .spacing()
                
                SearchBar(
                    searchText: $searchTerm,
                    font: nil,
                    colorScheme: settingsController.colorScheme,
                    onEditingChanged: { isEditing in },
                    onCommit: {}
                )
                .resignsFirstResponderOnDrag()
                .frame(height: 50)
                .spacing(.horizontal)
                
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(musicController.searchResults.songs) { song in
                                let backgroundColor = settingsController.colorScheme.backgroundGradient.first
                                let textColor = settingsController.colorScheme.textColor.color
                                
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultRow(backgroundColor: backgroundColor, textColor: textColor, result: song)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: false)
                                }
                                .padding([.horizontal, .bottom])
                            }
                        } header: {
                            Text("Songs")
                        }
                        
                        Section {
                            ForEach(musicController.searchResults.albums) { album in
                                let backgroundColor = settingsController.colorScheme.backgroundGradient.first
                                let textColor = settingsController.colorScheme.textColor.color
                                
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultRow(backgroundColor: backgroundColor, textColor: textColor, result: album)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: false)
                                }
                                .padding([.horizontal, .bottom])
                            }
                        } header: {
                            Text("Albums")
                        }
                        
                        Section {
                            ForEach(musicController.searchResults.artists) { artist in
                                let backgroundColor = settingsController.colorScheme.backgroundGradient.first
                                let textColor = settingsController.colorScheme.textColor.color
                                
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultRow(backgroundColor: backgroundColor, textColor: textColor, result: artist)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: false)
                                }
                                .padding([.horizontal, .bottom])
                            }
                        } header: {
                            Text("Artists")
                        }
                    }
                }
                .foregroundColor(settingsController.colorScheme.textColor.color)
                .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .list, cornerRadius: 20, isConcave: false)
                .opacity(searchTerm.isEmpty || musicController.isEmpty ? 0 : 1)
                .spacing()
                .offset(y: offsetHeight / 2)
            }
        }
        .onChange(of: searchTerm) { newValue in
            guard !searchTerm.isEmpty else {
                task.cancel()
                return
            }
            
            task.setTask({
                    do {
                        try await musicController.search(searchTerm, type: searchType)
                    } catch {
                        // TODO: - use nserror
                        NSLog("\(error as NSError)")
                    }
                },
                after: 1
            )
        }
        .onChange(of: searchType) { newValue in
            guard !searchTerm.isEmpty else {
                task.cancel()
                return
            }
            
            task.setTask({
                    do {
                        try await musicController.search(searchTerm, type: searchType)
                    } catch {
                        // TODO: - use nserror
                        NSLog("\(error as NSError)")
                    }
                }
            )
        }
    }
    
    // MARK: - Static Variables
    
    static let cellHeight = UIScreen.main.bounds.height / 10
    
}

// MARK: - SearchView Extension: SectionType

extension SearchView {
    enum SectionType {
        case title
        case album
        case artist
        
        var text: String {
            switch self {
            case .title:
                return "Songs"
            case .album:
                return "Albums"
            case .artist:
                return "Artists"
            }
        }
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicController())
            .environmentObject(FeedbackGenerator(feedbackEnabled: false))
    }
}
