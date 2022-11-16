import SwiftUI

struct CSPresets: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(entity: CDColorScheme.entity(), sortDescriptors: [NSSortDescriptor(key: "dateAdded", ascending: true)]) var colorSchemes: FetchedResults<CDColorScheme>
    
    @State private var isEditing = false
    @State private var selectedScheme: JCColorScheme = .default
    
    // MARK: - Body
    
    var body: some View {
        let schemes = (Constants.defaults + colorSchemes.compactMap { $0.jc })
        VStack {
            HStack {
                Spacer()
                if !schemes.contains(settingsController.colorScheme) {
                    Button("Save") {
                        _ = CDColorScheme(settingsController.colorScheme, context: context)
                        CoreDataStack.shared.save(context: context)
                    }
                    .spacing(.trailing)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                }
            }
            
            ScrollView {
                VStack {
                    let arrs = schemes.arrs
                    
                    ForEach(0..<arrs.count, id: \.self) { i in
                        let arr = arrs[i]
                        HStack {
                            ForEach(arr, id: \.id) { cs in
                                CSButton(colorScheme: cs, title: cs.name ?? "Saved", selectedScheme: $selectedScheme, isEditing: $isEditing)
                                    .onChange(of: selectedScheme, perform: { newVal in
                                        feedbackGenerator.impactOccurred()
                                        settingsController.setCurrentColorScheme(newVal)
                                    })
                            }
                        }
                        .frame(height: 100)
                        .spacing(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: tabBarHeight + MusicPlayer.musicPlayerHeightOffset)
                }
            }
        }
    }
}

// MARK: - Preview

struct CSPresets_Previews: PreviewProvider {
    static var previews: some View {
        CSPresets()
            .environmentObject(SettingsController.shared)
            .environmentObject(FeedbackGenerator(feedbackEnabled: false))
    }
}
