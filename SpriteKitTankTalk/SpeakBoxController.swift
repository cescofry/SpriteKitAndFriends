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
    
    func toImage() -> UIImage {
        switch self {
        case .Character: return UIImage(named: "zelda")!
        case .Professor: return UIImage(named: "professor")!
        }
    }
    
    func toLanguage() -> String {
        switch self {
        case .Character: return "en-US"
        case .Professor: return "en-GB"
        }
    }
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
    
    var type: SpeakerType? {
        didSet {
            guard let type = self.type else {
                return
            }
            
            self.speakerImageView.image = type.toImage()
            
            let fontSize = (type == .Professor) ? CGFloat(20.0) : CGFloat(24.0)
            self.textLabel.font = UIFont(name: Config.sharedConfig().fontName, size: fontSize)
        }
    }
    
    var speakerType: SpeakerType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let resizingMask : UIViewAutoresizing = [.FlexibleHeight, .FlexibleWidth, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        
        self.autoresizingMask = autoresizingMask
        
        self.backgroundColor = UIColor.blueColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10.0
        
        let(speakerFrame, labelFrame) = self.bounds.divide(self.bounds.size.height, fromEdge: .MinXEdge)
        let insetLabelFrame = labelFrame.insetBy(dx: 20, dy: 20)
        
        self.speakerImageView = UIImageView(frame: speakerFrame)
        self.speakerImageView.contentMode = .ScaleAspectFill
        self.speakerImageView.autoresizingMask = resizingMask
        self.addSubview(self.speakerImageView)
        
        self.textLabel = UILabel(frame: insetLabelFrame)
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.font  = UIFont(name: Config.sharedConfig().fontName, size: 24)
        self.textLabel.numberOfLines = 0
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.autoresizingMask = resizingMask
        self.addSubview(self.textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let(speakerFrame, labelFrame) = self.bounds.divide(self.bounds.size.height, fromEdge: .MinXEdge)
        let insetLabelFrame = labelFrame.insetBy(dx: 20, dy: 20)
        self.speakerImageView.frame = speakerFrame
        self.textLabel.frame = insetLabelFrame
    }
}


class SpeakBoxController {
    private var presenterViewController: UIViewController?
    var speechSynthesizer: SpeechSynthesizer
    var speakBox: SpeakBoxView
    var text : String?
    var type : SpeakerType
    
    init(viewController: UIViewController, type: SpeakerType) {
        self.speechSynthesizer = SpeechSynthesizer()
        self.type = type
        
        self.presenterViewController = viewController
        
        self.speakBox = SpeakBoxView(frame: CGRectMake(0, 0, 600, 100))
        self.speakBox.type = type
    }
    
    func layoutSpeakBox() {
        
        let frame = self.presenterViewController!.view.bounds.divide(140.0, fromEdge: .MaxYEdge).slice.insetBy(dx: 20, dy: 20)
        self.speakBox.frame = frame
        
        if self.speakBox.superview == nil {
            self.presenterViewController!.view.addSubview(self.speakBox)
        }
        
    }
    
    
    func speakMultipleTextAndAdvance(texts: [String], willStart:((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        for text in texts {
            self.speakText(text, willStart: willStart, completion: completion)
        }
    }
    
    func speakText(text: String, willStart:((text: String)->())?, completion:((cancelled: Bool, text: String)->())?) {
        
        func willStart(text: String) {
            self.text = text
            if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                self.layoutSpeakBox()
            }
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
        
        self.speechSynthesizer.speakText(text, language: self.type.toLanguage(), willStart: willStart, completion: didFinish)
    }
    
    func stopSpeaking() {
        self.speechSynthesizer.stopSpeaking()
        self.speakBox.removeFromSuperview()
    }
    
    private func didEndShowingText(text: String) {
        Dispatch.after(0.5) { () -> () in
            guard let currentText = self.text else {
                return
            }
            
            if currentText == text {
                self.speakBox.removeFromSuperview()
            }
            
        }
    }
    
    func runDemo(completion: ((cancelled: Bool, text: String) -> ())?) {
        
        func willStart(text: String) {
            self.layoutSpeakBox()
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