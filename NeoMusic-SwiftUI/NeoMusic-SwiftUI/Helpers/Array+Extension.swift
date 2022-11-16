import MediaPlayer

// MARK: - Extension Array: AMSong

extension Array where Element == AMSong {
    func toMedia() -> [MPMediaItem] {
        compactMap { $0.media }
    }
}

extension Array where Element == MPMediaItem {
    func toSongs() -> [AMSong] {
        return compactMap{ AMSong($0) }
    }
}

// MARK: - Extension Array: JCColorScheme

extension Array where Element == JCColorScheme {
    var arrs: [[JCColorScheme]] {
        var tempArr: [[JCColorScheme]] = [[]]
        for colorScheme in self {
            if tempArr[tempArr.count - 1].count == 3 {
                tempArr.append([colorScheme])
            } else {
                tempArr[tempArr.count - 1].append(colorScheme)
            }
        }
        return tempArr
    }
    
    func doesContain(_ element: Element) -> Bool {
        for el in self {
            if el == element {
                return true
            }
        }

        return false
    }
}
