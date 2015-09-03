//
//  SpeakBoxNode.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 28/08/2015.
//  Copyright © 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit


enum SpeakerType {
    case Character, Professor
}


class SpeakBoxView : UIView {
    private var textLabel: UILabel!
    private var speakerImageView: UIImageView!
    var text : String? {
        didSet {
            if let text = text {
                self.textLabel.text = text
            }
        }
    }
    
    var speakerType: SpeakerType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blueColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10.0
        
        let(speakerFrame, labelFrame) = self.bounds.divide(self.bounds.size.height, fromEdge: .MinXEdge)
        let insetLabelFrame = labelFrame.insetBy(dx: 20, dy: 20)
        
        self.speakerImageView = UIImageView(frame: speakerFrame)
        self.speakerImageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.speakerImageView.contentMode = .ScaleAspectFill
        self.speakerImageView.backgroundColor = UIColor.redColor()
        self.addSubview(self.speakerImageView)
        
        self.textLabel = UILabel(frame: insetLabelFrame)
        self.textLabel.font  = UIFont(name: Config.sharedConfig().fontName, size: 24)
        self.textLabel.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(self.textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SpeakBoxController {
    private var presenterViewController: UIViewController?
    var speechSynthesizer: SpeechSynthesizer
    var speakBox: SpeakBoxView!
    var text : String?
    
    init(viewController: UIViewController) {
        self.speechSynthesizer = SpeechSynthesizer()
        
        self.presenterViewController = viewController
        
        let frame = self.presenterViewController!.view.bounds.divide(140.0, fromEdge: .MaxYEdge).slice.insetBy(dx: 20, dy: 20)
        self.speakBox = SpeakBoxView(frame: frame)
        self.presenterViewController!.view.addSubview(self.speakBox)
    }

    
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
                //self.speakBox.removeFromSuperview()
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