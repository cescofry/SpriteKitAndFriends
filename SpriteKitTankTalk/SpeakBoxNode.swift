//
//  SpeakBoxNode.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 28/08/2015.
//  Copyright © 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit

class SpeakBoxNode: SKSpriteNode {
    var textLabel : SKLabelNode {
        if let label = self.childNodeWithName("label") as? SKLabelNode {
            return label
        }
        
        let label = SKLabelNode(fontNamed: "San Francisco")
        label.fontSize = 24
        label.name = "label"
        self.addChild(label)
        
        return label
    }
    
    var text : String? {
        didSet {
            if let text = text {
                self.textLabel.text = text
            }
        }
    }
}

class SpeakBoxController {
    var scene : GameScene
    var speechSynthesizer: SpeechSynthesizer
    var speakBox: SpeakBoxNode {
        if let speakBox = self.scene.childNodeWithName("speakBox") as? SpeakBoxNode {
            return speakBox
        }
        
        let size = CGSize(width: self.scene.size.width - 40, height: 40)
        let speakBox = SpeakBoxNode(color: UIColor.darkTextColor(), size: size)
        speakBox.position = CGPoint(x: (self.scene.size.width / 2.0), y: 60.0)
        speakBox.name = "speakBox"
        self.scene.addChild(speakBox)
        
        return speakBox
    }
    
    init(scene : GameScene) {
        self.scene = scene
        self.speechSynthesizer = SpeechSynthesizer()
    }
    
    var text : String?
    
    func speakText(text: String, willStart:((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        func willStart(text: String) {
            self.text = text
            self.speakBox.text = text
            if let willStart = willStart {
                willStart(text: text)
            }
        }
        
        func didFinish(cancelled: Bool, text: String) {
            self.didEndShowingText(text)
            if let completion = completion {
                completion(cancelled: cancelled, text: text)
            }
        }
        
        self.speechSynthesizer.speakText(text, willStart: willStart, completion: didFinish)
    }
    
    private func didEndShowingText(text: String) {
        Dispatch.after(1.0) { () -> () in
            guard let currentText = self.text else {
                return
            }
            
            if currentText == text {
                self.speakBox.removeFromParent()
            }
            
        }
    }
    
    func runDemo(completion: ((cancelled: Bool, text: String) -> ())?) {
        
        func willStart(text: String) {
            self.text = text
            self.speakBox.text = text
        }
        
        func didFinish(cancelled: Bool, text: String) {
            self.didEndShowingText(text)
            if let completion = completion {
                completion(cancelled: cancelled, text: text)
            }
        }
        
        self.speechSynthesizer.runDemo(willStart: willStart, completion: didFinish)
    }
    
}