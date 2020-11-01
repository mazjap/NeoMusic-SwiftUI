//
//  Media.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/1/20.
//

import MediaPlayer
import SwiftUI

// MARK: - Media Protocol

protocol Media: Equatable {
    associatedtype IDType = Hashable
    
    var title: String? { get }
    var artist: String? { get }
    var albumTitle: String? { get }
    var albumArtwork: Image? { get }
    var playbackDuration: Double { get }
    var isExplicit: Bool { get }
    var id: IDType { get }
}

// MARK: - MPMediaItem Extension: Media

extension MPMediaItem: Media {
    var albumArtwork: Image? {
        if let image = self.artwork?.image(at: CGSize(width: 500, height: 500)) {
            return Image(uiImage: image)
        }
        
        return nil
    }
    
    var isExplicit: Bool {
        isExplicitItem
    }
    
    var id: UInt64 {
        persistentID
    }
}
