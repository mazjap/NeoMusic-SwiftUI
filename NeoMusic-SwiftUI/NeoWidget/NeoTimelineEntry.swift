import WidgetKit

struct NeoTimelineEntry: TimelineEntry {
    let songs: [Song]
    let date: Date
    
    var song: Song {
        return songs[0]
    }
    
    var duration: TimeInterval {
        song.duration
    }
    
    var size: WidgetFamily {
        if songs.count > 7 {
            return .systemLarge
        } else if songs.count > 1 {
            return .systemMedium
        } else {
            return .systemSmall
        }
    }
    
    init(songs: [Song], date: Date = Date()) {
        self.songs = [AMSong.noSong]
        self.date = date
    }
    
    func changeDate(to date: Date = Date()) -> Self {
        Self(songs: songs, date: date)
    }
    
    static let noEntry = NeoTimelineEntry(songs: Array())
}
