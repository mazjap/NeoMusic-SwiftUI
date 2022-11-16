import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let controller: MusicController
    
    func placeholder(in context: Context) -> NeoTimelineEntry {
        .noEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (NeoTimelineEntry) -> ()) {
        let entry = controller.getEntry()
        completion(entry.entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NeoTimelineEntry>) -> ()) {
        let firstEntry: Entry
        let isPlaying: Bool
        
        (firstEntry, isPlaying) = controller.getEntry(size: context.family)
        
        var entries: [NeoTimelineEntry] = [firstEntry.changeDate(to: Date())]
        
        if isPlaying {
            entries.append(controller.getEntry(at: 1, with: entries[0].date.addingTimeInterval(entries[0].duration - controller.currentPlaybackTime), size: context.family).entry)
            entries.append(controller.getEntry(at: 2, with: entries[1].date.addingTimeInterval(entries[1].duration), size: context.family).entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct NeoWidgetEntryView: View {
    let font: Font = .footnote
    private let entry: NeoTimelineEntry
    private let controller: MusicController
    private let colorScheme: JCColorScheme
    
    init(entry: NeoTimelineEntry = .noEntry, controller: MusicController = .init(), colorScheme: JCColorScheme = .default) {
        self.entry = entry
        self.controller = controller
        self.colorScheme = colorScheme
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
            
            HStack {
                if entry.songs.count > 1 {
                    VStack {
                        Spacer()
                        
                        ForEach(0..<entry.songs.count) { i in
                            let song = entry.songs[i]
                            
                            HStack {
                                VStack {
                                    Text(song.title)
                                    Text(song.artist)
                                }
                                
                                Spacer()
                                
                                Image(uiImage: song.albumArtwork)
                            }
                            
                            if i != entry.songs.count - 1 {
                                Spacer()
                                
                                divider
                            }
                            
                            Spacer()
                        }
                    }
                }
            
                VStack {
                    // Title
                    HStack {
                        Text(entry.song.title)
                            .font(font)
                            .lineLimit(1)
                            .foregroundColor(colorScheme.textColor.color)
                        
                        if entry.song.isExplicit {
                            Image(systemName: "e.square.fill")
                                .resizable()
                                .foregroundColor(colorScheme.textColor.color)
                                .frame(width: font.size, height: font.size)
                                
                        }
                    }
                    
                    // Artwork
                    WidgetArtwork(colorScheme: colorScheme, image: Image(uiImage: entry.song.albumArtwork))
                }
            }
            .padding(Constants.spacing / 2)
        }
    }
    
    private var divider: some View {
        colorScheme.textColor.color
            .frame(height: 1)
    }
}

@main
struct NeoWidget: Widget {
    private let kind: String = "NeoWidget"
    private let controller = MusicController()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(controller: controller)) { entry in
            NeoWidgetEntryView(entry: entry, controller: controller)
        }
        .configurationDisplayName(kind)
        .description("Music.")
    }
}

struct NeoWidget_Previews: PreviewProvider {
    private static let controller = MusicController()
    
    static var previews: some View {
        NeoWidgetEntryView(colorScheme: .default)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        NeoWidgetEntryView(colorScheme: .default)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        NeoWidgetEntryView(colorScheme: .default)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
