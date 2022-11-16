import XCTest
import SwiftUI
import MediaPlayer
@testable import NeoMusic_SwiftUI

class NeoMusic_SwiftUITests: XCTestCase {
    var settingsController = SettingsController.shared
    var musicController = MusicController()
        
    var queue = Queue([1, 2, 3, 4, 5])
    
    var originalColorScheme: JCColorScheme!
    
    override func setUpWithError() throws {
        // Save colorScheme
        originalColorScheme = settingsController.colorScheme
    }

    override func tearDownWithError() throws {
        // Restore original colorScheme
        settingsController.setCurrentColorScheme(originalColorScheme)
    }

    // Test if gradient is saved to userdefaults
    func testSetColorScheme() throws {
        XCTAssertEqual(originalColorScheme, settingsController.colorScheme)
        
        for _ in 1...10 {
            let tempColorScheme = JCColorScheme(backgroundGradient: EasyGradient([randomColor(), randomColor()]), sliderGradient: EasyGradient([randomColor(), randomColor()]), textColor: randomColor(), mainButtonColor: randomColor(), secondaryButtonColor: randomColor())
            
            XCTAssertNotEqual(originalColorScheme, tempColorScheme)
            XCTAssertNotEqual(settingsController.colorScheme, tempColorScheme)
            
            settingsController.setCurrentColorScheme(tempColorScheme)
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
            
            if queue.arr.count > randInts.count {
                XCTAssertNotEqual(Array(queue.arr[queue.arr.count - randInts.count..<queue.arr.count]), randInts)
            } else {
                XCTAssertNotEqual(Array(randInts[(randInts.count - queue.arr.count)..<randInts.count]), randInts)
            }
            queue.push(randInts)
            XCTAssertEqual(Array(queue.arr[queue.arr.count - randInts.count..<queue.arr.count]), randInts)
            
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
    
    #if !targetEnvironment(simulator)
    func testLibrarySongSearch() {
        guard UIDevice.isConnectedToNetwork(), musicController.songCount > 1, let title = musicController.item(at: 0)?.title else { return }
        musicController.searchTerm = title
        
        let expectation = XCTestExpectation()
        wait(for: [expectation], timeout: 10)
        
        var count = 0
        while musicController.searchResults.songs.isEmpty {
            if count > 10000 {
                XCTAssert(false)
                return
            }
            count += 1
        }
        expectation.fulfill()
    }
    
    func testAppleMusicSongSearch() {
        
    }
    
    #endif
    
    func testMultiQueuePop() {
        XCTAssertEqual(Array(queue.arr[0..<3]), queue.pop(3))
    }
}
