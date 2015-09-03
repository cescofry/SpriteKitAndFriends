//
//  CodeViewController.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit
import WebKit

class CodeViewController : UIViewController {

    var sceneDescription : SceneDescription? {
        didSet {
            self.html = sceneDescription!.html
        }
    }
    
    var html : String? {
        didSet {
            if let html = html {
                self.webView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    var webView =  WKWebView(frame: CGRectZero)
    var speakBox = UILabel(frame: CGRectZero)
    var speechSynthesizer : SpeechSynthesizer!
    
    var aboutToDismiss : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightTextColor()
        
        self.navigationItem.title = self.sceneDescription!.title
        self.view.backgroundColor = UIColor.whiteColor()
        
        let(speakLabelRect, webViewRect) = self.view.bounds.divide(120, fromEdge: CGRectEdge.MaxYEdge)
        
        // Webview
        self.webView.frame = webViewRect
        self.webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(self.webView)
        
        // Speak Box
        
        let backgorund = UIView(frame: speakLabelRect)
        backgorund.backgroundColor = UIColor.blueColor()
        backgorund.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(backgorund)
        
        let insettedFrame = backgorund.bounds.insetBy(dx: 10, dy: 10)
        
        self.speakBox.frame = insettedFrame
        self.speakBox.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.speakBox.numberOfLines = 0
        self.speakBox.backgroundColor = backgorund.backgroundColor
        self.speakBox.textColor = UIColor.whiteColor()
        self.speakBox.font = UIFont(name: Config.sharedConfig().fontName, size: 20)
        self.speakBox.textAlignment = .Center
        
        backgorund.addSubview(self.speakBox)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let texts = self.sceneDescription?.code else {
            return
        }
        
        for text in texts {
            
            func willStart(text: String) {
                self.speakBox.text = text
            }
            
            self.speechSynthesizer.speakText(text, language: "en-GB", willStart: willStart, completion: nil)
        }
    }
        
    static func inNavigationController(sceneDescription: SceneDescription, speechSynthesizer: SpeechSynthesizer, dismissBlock: (()->())?) -> UINavigationController {
        
        let vc = CodeViewController(nibName: nil, bundle: nil)
        vc.speechSynthesizer = speechSynthesizer
        vc.sceneDescription = sceneDescription
        vc.aboutToDismiss = dismissBlock
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: vc, action: Selector("dismiss"))
        vc.navigationItem.rightBarButtonItem = closeBtn
        return navVC
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.speechSynthesizer.stopSpeaking()
            if let aboutToDismiss = self.aboutToDismiss {
                aboutToDismiss()
            }
        })
    }
}