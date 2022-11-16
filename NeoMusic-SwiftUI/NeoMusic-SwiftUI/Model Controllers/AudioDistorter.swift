import SwiftUI
import AVKit

class AudioDistorter: ObservableObject {
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
}
