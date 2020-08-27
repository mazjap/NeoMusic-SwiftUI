//
//  NeoMusic_SwiftUITests.swift
//  NeoMusic-SwiftUITests
//
//  Created by Jordan Christensen on 8/24/20.
//

import XCTest
import SwiftUI
import MediaPlayer
@testable import NeoMusic_SwiftUI

class NeoMusic_SwiftUITests: XCTestCase {
    var settingsController: SettingsController!
    var musicController: MusicController!
    
    override func setUpWithError() throws {
        settingsController = SettingsController()
        musicController = MusicController()
    }

    override func tearDownWithError() throws {
        settingsController = nil
        musicController = nil
    }

    func testSetGradient() throws { // Test if gradient is saved to userdefaults
        let originalColorScheme = settingsController.colorScheme
        
        let newColorScheme = ColorScheme(backgroundGradient: EasyGradient(color1: EasyColor(Color(red: 0.1, green: 0.1, blue: 0.1)), color2: EasyColor(Color(red: 0.5, green: 0.5, blue: 0.5))), playGradient: EasyGradient(color1: EasyColor(Color(red: 0.1, green: 0.2, blue: 0.3)), color2: EasyColor(Color(red: 1, green: 0.9, blue: 0.8))), pauseGradient: EasyGradient(color1: EasyColor(Color(red: 0, green: 0, blue: 1)), color2: EasyColor(Color(red: 1, green: 0, blue: 0))), textColor: EasyColor(.black), mainButtonColor: EasyColor(.red), secondaryButtonColor: EasyColor(.blue))
        
        XCTAssertNotEqual(settingsController.colorScheme, newColorScheme)
        
        settingsController.setColorScheme(newColorScheme)
        
        XCTAssertEqual(settingsController.colorScheme, newColorScheme)
        
        // Reset colors
        settingsController.setColorScheme(originalColorScheme)
    }
    
    func testSetSingleGradient() throws { // Test if individual gradients can be set and saved to userdefaults
        let oldGradient = settingsController.colorScheme.backgroundGradient
        let newGradient = EasyGradient(color1: EasyColor(.orange), color2: EasyColor(.purple))
        
        XCTAssertNotEqual(oldGradient, newGradient)
        
        settingsController.setGradient(newGradient, for: .background)
        
        XCTAssertEqual(settingsController.colorScheme.backgroundGradient, newGradient)
        
        // Reset background gradient
        settingsController.setGradient(oldGradient, for: .background)
    }
    
    
}
