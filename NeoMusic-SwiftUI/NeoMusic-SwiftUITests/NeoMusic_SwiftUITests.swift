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
    var settingsController = SettingsController()
    var musicController = MusicPlayerController()
    var queue = Queue([1, 2, 3, 4, 5])
    
    var originalColorScheme: JCColorScheme!
    
    override func setUpWithError() throws {
        // Save colorScheme
        originalColorScheme = settingsController.colorScheme
    }

    override func tearDownWithError() throws {
        // Restore original colorScheme
        settingsController.setColorScheme(originalColorScheme)
    }

    // Test if gradient is saved to userdefaults
    func testSetColorScheme() throws {
        
        XCTAssertEqual(originalColorScheme, settingsController.colorScheme)
        
        for _ in 1...10 {
            let tempColorScheme = JCColorScheme(backgroundGradient: EasyGradient([randomColor(), randomColor()]), textColor: randomColor(), mainButtonColor: randomColor(), secondaryButtonColor: randomColor())
            
            XCTAssertNotEqual(originalColorScheme, tempColorScheme)
            XCTAssertNotEqual(settingsController.colorScheme, tempColorScheme)
            
            settingsController.setColorScheme(tempColorScheme)
            XCTAssertEqual(settingsController.colorScheme, tempColorScheme)
        }
    }
    
    // Create a color from random red, green, and blue values between 0 and 1
    func randomColor() -> Color {
        let range = 0.0...1.0
        
        return Color(red: Double.random(in: range), green: Double.random(in: range), blue: Double.random(in: range))
    }
    
    func randomInt() -> Int {
        Int.random(in: Int.min...Int.max)
    }
    
    func randomInts(count: Int = 10) -> [Int] {
        var ints = [Int]()
        
        for _ in 0..<count {
            ints.append(randomInt())
        }
        
        return ints
    }
    
    func testRandomColor() throws {
        for _ in 1...5 {
            XCTAssertNotEqual(randomColor(), randomColor())
        }
    }
    
    func testQueueRead() {
        XCTAssertEqual(queue.arr.first, queue.read())
        XCTAssertEqual(queue.arr.last, queue.readLast())
    }
    
    func testSingleQueuePush() {
        for _ in 1...10 {
            let randInt = randomInt()
            
            XCTAssertNotEqual(queue.readLast(), randInt)
            queue.push(randInt)
            XCTAssertEqual(queue.readLast(), randInt)
        }
    }
    
    func testMultiQueuePush() {
        for _ in 1...10 {
            let randInts = randomInts()
            
            XCTAssertFalse(queue.arr.contains(randInts))
            queue.push(randInts)
            XCTAssertTrue(queue.arr.contains(randInts))
            
        }
    }
    
    func testSingleQueuePushToFront() {
        for _ in 1...10 {
            let randInt = randomInt()
            
            XCTAssertNotEqual(queue.read(), randInt)
            queue.pushToFront(randInt)
            XCTAssertEqual(queue.read(), randInt)
        }
    }
    
    func testMultiQueuePushToFront() {
        for _ in 1...10 {
            let randInts = randomInts()
            if randInts.count < queue.arr.count {
                XCTAssertNotEqual(randInts, Array(queue.arr[0..<randInts.count]))
            }
            
            queue.pushToFront(randInts)
            XCTAssertEqual(randInts, Array(queue.arr[0..<randInts.count]))
        }
    }
    
    func testSingleQueuePop() {
        let last = queue.read()
        
        XCTAssertEqual(last, queue.pop())
        XCTAssertNotEqual(last, queue.read())
    }
    
    func testMultiQueuePop() {
        XCTAssertEqual(Array(queue.arr[0..<3]), queue.pop(3))
    }
}

// Credit to Daniel on Stack Overflow: https://stackoverflow.com/questions/37410649/array-contains-a-complete-subarray
extension Array where Element: Equatable {
    func contains(_ subarray: [Element]) -> Bool {
        var found = 0
        for element in self where found < subarray.count {
            if element == subarray[found] {
                found += 1
            } else {
                found = element == subarray[0] ? 1 : 0
            }
        }

        return found == subarray.count
    }
}
