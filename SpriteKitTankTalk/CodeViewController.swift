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
            self.navigationItem.title = self.sceneDescription!.title
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
    var speakBoxXontroller : SpeakBoxController!
    
    var aboutToDismiss : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let(_, webViewRect) = self.view.bounds.divide(120, fromEdge: CGRectEdge.MaxYEdge)
        
        // Webview
        self.webView.frame = webViewRect
        self.webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(self.webView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let texts = self.sceneDescription?.code else {
            return
        }
        
        for text in texts {
            self.speakBoxXontroller.speakText(text, willStart: nil, completion: nil)
        }
    }
        
    static func presentInNavigationController(presenterViewController: UIViewController, sceneDescription: SceneDescription, dismissBlock: (()->())?) {
        
        let vc = CodeViewController(nibName: nil, bundle: nil)
        vc.sceneDescription = sceneDescription
        vc.aboutToDismiss = dismissBlock
        vc.speakBoxXontroller = SpeakBoxController(viewController: vc, type: .Professor)
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: vc, action: Selector("dismiss"))
        vc.navigationItem.rightBarButtonItem = closeBtn
        
        presenterViewController.presentViewController(navVC, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.speakBoxXontroller.stopSpeaking()
            if let aboutToDismiss = self.aboutToDismiss {
                aboutToDismiss()
            }
        })
    }
}