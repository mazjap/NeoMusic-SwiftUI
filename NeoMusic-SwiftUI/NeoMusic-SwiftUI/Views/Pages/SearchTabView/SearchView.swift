import SwiftUI

struct SearchView: View {
    // MARK: - State
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @State private var text: String = ""
    @State private var segmentedIndex: Int = 0
    
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
                        musicController.searchType = (newVal == 0 ? .library : .applemusic)
                    }
                    .spacing()
                
                let binding = Binding<String>(get: { return musicController.searchTerm }) { str in
                    musicController.searchTerm = str
                }
                
                SearchBar(searchText: binding, font: nil, colorScheme: settingsController.colorScheme,
                onEditingChanged: { isEditing in }, onCommit: {})
                    .resignsFirstResponderOnDrag()
                    .onChange(of: text) { newVal in
                        musicController.searchTerm = newVal
                    }
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
                                    NeoSongRow(backgroundColor: backgroundColor, textColor: textColor, song: song)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: true)
                                }
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
                                    NeoAlbumRow(backgroundColor: backgroundColor, textColor: textColor, album: album)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: true)
                                }
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
                                    NeoArtistRow(backgroundColor: backgroundColor, textColor: textColor, artist: artist)
                                        .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .button, cornerRadius: 20, isConcave: true)
                                }
                            }
                        } header: {
                            Text("Artists")
                        }
                    }
                }
                .foregroundColor(settingsController.colorScheme.textColor.color)
                .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .list, cornerRadius: 20, isConcave: false)
                .opacity(musicController.searchTerm.isEmpty || musicController.isEmpty ? 0 : 1)
                .spacing()
                .offset(y: offsetHeight / 2)
            }
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
