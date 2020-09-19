//
//  NeoWidget.swift
//  NeoWidget
//
//  Created by Jordan Christensen on 9/2/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Controller {
        Controller(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Controller) -> ()) {
        let entry = Controller(date: Date().addingTimeInterval(1))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [Controller()], policy: .never)
        completion(timeline)
    }
}

struct NeoWidgetEntryView : View {
    var controller: Provider.Entry

    var body: some View {
        let song = controller.song
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: controller.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                // Title
                HStack {
                    Text(song.title)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(controller.colorScheme.textColor.color)
                    
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                    }
                }
                
                // Artwork
                WidgetArtwork(colorScheme: controller.colorScheme, image: controller.song.artwork)
                
                Spacer()
            }
        }
    }
}

@main
struct NeoWidget: Widget {
    static let kind: String = "NeoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: Provider()) { entry in
            NeoWidgetEntryView(controller: entry)
        }
        .configurationDisplayName("NeoWidget")
        .description("Music.")
    }
}

struct NeoWidget_Previews: PreviewProvider {
    static var previews: some View {
        NeoWidgetEntryView(controller: Controller())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
