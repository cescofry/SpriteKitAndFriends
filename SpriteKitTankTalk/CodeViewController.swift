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
        
//        let webViewRect : UnsafeMutablePointer<CGRect>
//        let speakLabelRect : UnsafeMutablePointer<CGRect>
//        CGRectDivide(self.view.bounds, webViewRect, speakLabelRect, 80, CGRectEdge.MinYEdge)
        
        let(speakLabelRect, webViewRect) = self.view.bounds.divide(120, fromEdge: CGRectEdge.MaxYEdge)
        self.webView.frame = webViewRect
        self.webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(self.webView)
        
        self.speakBox.frame = speakLabelRect
        self.speakBox.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.speakBox.numberOfLines = 0
        self.speakBox.backgroundColor = UIColor.blackColor()
        self.speakBox.textColor = UIColor.whiteColor()
        self.speakBox.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(self.speakBox)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let text = speakTextOutOfHTML() {
            self.speakBox.text = text
            self.speechSynthesizer.speakText(text, language: "en-GB", willStart: nil, completion: nil)
        }
    }
    
    private func speakTextOutOfHTML() -> String? {
        if let html = self.html {
            let regEx = try? NSRegularExpression(pattern: "<!--SPEAK:(.+)-->", options: NSRegularExpressionOptions.CaseInsensitive)
            let range = NSMakeRange(0, html.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let findings = regEx!.matchesInString(html, options: NSMatchingOptions.ReportCompletion, range: range)
            
            if let first = findings.first {
                let range = first.rangeAtIndex(1)
                return (html as NSString).substringWithRange(range)
            }
        }
        
        return nil
    }
    
    static func inNavigationController(html: String, speechSynthesizer: SpeechSynthesizer, dismissBlock: (()->())?) -> UINavigationController {
        
        let vc = CodeViewController(nibName: nil, bundle: nil)
        vc.speechSynthesizer = speechSynthesizer
        vc.html = html
        vc.aboutToDismiss = dismissBlock
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: vc, action: Selector("dismiss"))
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