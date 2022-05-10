//
//  SoundPlayer.swift
//  Devotion
//
//  Created by adam janusewski on 5/10/22.
//

import Foundation
import AVFoundation


//  NEEDED TO PLAY SOUND FILES

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find and play the sound file.")
        }
    }
}
