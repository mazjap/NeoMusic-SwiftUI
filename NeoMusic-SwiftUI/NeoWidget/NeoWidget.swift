//
//  NeoWidget.swift
//  NeoWidget
//
//  Created by Jordan Christensen on 9/2/20.
//

import WidgetKit
import SwiftUI

let controller = Controller()
var refreshDate = Date()

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetSong {
        .noSong(date: refreshDate)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetSong) -> ()) {
        let entry = controller.getSong()
        completion(entry ?? .noSong(date: refreshDate))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetSong>) -> ()) {
        let now = Date()
        let refresh = now.addingTimeInterval(10)
        
        if now >= refreshDate {
            refreshDate = refresh
        }
        
        let timeline = Timeline(entries: [controller.getSong(with: refresh) ?? WidgetSong.noSong(date: refresh)], policy: .atEnd)
        completion(timeline)
    }
}

struct NeoWidgetEntryView : View {
    let spacing: CGFloat = 7.5
    let font: Font = .footnote
    
    var body: some View {
        let song = controller.getSong() ?? .noSong()
        
        ZStack {
            LinearGradient(gradient: controller.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
            
            VStack {
                // Title
                HStack {
                    Text(song.title)
                        .font(font)
                        .lineLimit(1)
                        .foregroundColor(controller.colorScheme.textColor.color)
                    
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                            .resizable()
                            .foregroundColor(controller.colorScheme.textColor.color)
                            .frame(width: font.size, height: font.size)
                            
                    }
                }
                .padding([.leading, .top, .trailing], spacing)
                
                // Artwork
                WidgetArtwork(colorScheme: controller.colorScheme, image: Image(uiImage: song.artwork))
                    .padding(.bottom, spacing)
            }
        }
    }
}

@main
struct NeoWidget: Widget {
    static let kind: String = "NeoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: Provider()) { entry in
            NeoWidgetEntryView()
        }
        .configurationDisplayName(Self.kind)
        .description("Music.")
    }
}

struct NeoWidget_Previews: PreviewProvider {
    static var previews: some View {
        NeoWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
