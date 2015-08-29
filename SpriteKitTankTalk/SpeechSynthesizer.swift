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
    private var completion: ((cancelled: Bool, text: String)->())?
    private var willStart:((text: String)->())?
    private let speakText = Config.sharedConfig().speakText
    
    func speakText(text: String, willStart: ((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        if !speakText {
            if let completion = completion {
                completion(cancelled: true, text: text)
            }
            return
        }
        
        synth.delegate = self
        self.completion = completion
        self.willStart = willStart
        let utterance = AVSpeechUtterance(string: text)
        synth.speakUtterance(utterance)
    }
    
    func stopSpeaking() {
        self.synth.stopSpeakingAtBoundary(.Word)
    }
    
    
    //MARK: - speechSynthesizer delegate -
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if let completion = completion {
            completion(cancelled: false, text: utterance.speechString)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        if let completion = completion {
            completion(cancelled: true, text: utterance.speechString)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        if let willStart = willStart {
            willStart(text: utterance.speechString)
        }
    }
    
}

extension SpeechSynthesizer {
    
    func entryFromString(string: String, pitch: Float?, rate: Float?, language: String?) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: string)
        if let pitch = pitch {
            utterance.pitchMultiplier = pitch
        }
        
        if let rate = rate {
            utterance.rate = rate
        }
        
        if let lang = language {
            let voice = AVSpeechSynthesisVoice(language: lang)
            utterance.voice = voice
        }
        
        return utterance
    }
    
    func demoScript() -> [AVSpeechUtterance] {
        var entries = [AVSpeechUtterance]()
        
        entries.append(entryFromString("By the way, I speaking using an A V Speech Synthesizer. This think is crazy.", pitch: nil, rate: nil, language: nil))
        entries.append(entryFromString("Of course I speak English.", pitch: nil, rate: nil, language: nil))
        entries.append(entryFromString("Je peux parler français", pitch: nil, rate: nil, language: "fr-FR"))
        entries.append(entryFromString("y españoles también", pitch: nil, rate: nil, language: "es-ES"))
        entries.append(entryFromString("Ordinare una pizza in italiano", pitch: nil, rate: nil, language: "it-IT"))
        entries.append(entryFromString("要求一个中国翻译", pitch: nil, rate: nil, language: "zh-CN"))
        entries.append(entryFromString("go down", pitch: 0.5, rate: nil, language: nil))
        entries.append(entryFromString("and then up again", pitch: 2.0, rate: nil, language: nil))
        entries.append(entryFromString("slowing", pitch: nil, rate: 0.2, language: nil))
        entries.append(entryFromString("and fast, so fast that you gonna barely understand what I am saying", pitch: nil, rate: 0.7, language: nil))
        entries.append(entryFromString("Wow, that was something. Right!?", pitch: nil, rate: nil, language: nil))
        
        return entries
    }
    
    
    
    func runDemo(willStart willStart: ((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        if !speakText {
            if let completion = completion {
                completion(cancelled: true, text: "")
            }
            return
        }
        
        synth.pauseSpeakingAtBoundary(.Word)
        synth.delegate = self
        self.completion = completion
        self.willStart = willStart
        
        let entries = demoScript()
        
        for utterance in entries {
            synth.speakUtterance(utterance)
        }
        
    }
}