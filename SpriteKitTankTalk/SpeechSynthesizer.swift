//
//  SpeechSynthesizer.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSynthesizer : NSObject, AVSpeechSynthesizerDelegate {
    private let synth = AVSpeechSynthesizer()
    private var completion: ((cancelled: Bool)->())?
    private let speakText = Config.sharedConfig().speakText
    
    func speakText(text: String, completion:((cancelled: Bool)->())?) {
        
        if !speakText {
            if let completion = completion {
                completion(cancelled: true)
            }
            return
        }
        
        synth.delegate = self
        self.completion = completion
        let utterance = AVSpeechUtterance(string: text)
        utterance.pitchMultiplier = 0.9
        utterance.rate = 0.2
        synth.speakUtterance(utterance)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if let completion = completion {
            completion(cancelled: false)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        if let completion = completion {
            completion(cancelled: true)
        }
    }
    
}