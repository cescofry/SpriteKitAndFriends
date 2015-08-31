//
//  SpeakBoxNode.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 28/08/2015.
//  Copyright © 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit

class SpeakBoxNode: SKShapeNode {
    var textLabel : SKLabelNode!
    var text : String? {
        didSet {
            if let text = text {
                self.textLabel.text = text
            }
        }
    }
    
    convenience init(size: CGSize) {
        self.init()
        self.init(rectOfSize: size, cornerRadius: 10.0)
        self.fillColor = UIColor.blueColor()
        self.strokeColor = UIColor.whiteColor()
        self.lineWidth = 2.0
        self.lineJoin = CGLineJoin.Bevel
        
        self.textLabel = SKLabelNode(fontNamed: Config.sharedConfig().fontName)
        self.textLabel.fontSize = 24
        self.textLabel.name = "label"
        
        self.addChild(self.textLabel)
        self.textLabel.position = CGPointApplyAffineTransform(self.position, CGAffineTransformMakeTranslation(0.0, -10))
    }
}

class SpeakBoxController {
    var scene : GameScene
    var speechSynthesizer: SpeechSynthesizer
    var speakBox: SpeakBoxNode {
        if let speakBox = self.scene.childNodeWithName("speakBox") as? SpeakBoxNode {
            return speakBox
        }
        
        let size = CGSize(width: self.scene.size.width - 40, height: 60)
        let speakBox = SpeakBoxNode(size: size)
        speakBox.position = CGPoint(x: (self.scene.size.width / 2.0), y: size.height + 10)
        speakBox.name = "speakBox"
        self.scene.addChild(speakBox)
        
        return speakBox
    }
    
    init(scene : GameScene) {
        self.scene = scene
        self.speechSynthesizer = SpeechSynthesizer()
    }
    
    var text : String?
    
    
    
    func speakMultipleTextAndAdvance(texts: [String], willStart:((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        for text in texts {
            self.speakText(text, willStart: willStart, completion: completion)
        }
    }
    
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