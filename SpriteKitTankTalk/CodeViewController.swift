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
    
    var webView =  WKWebView(frame: CGRectZero, configuration: CodeViewController.webViewConfiguration())
    var speakBoxXontroller : SpeakBoxController!
    
    var aboutToDismiss : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: (39 / 255), green: (40 / 255), blue: (34 / 255), alpha: 1.0)
        
        let(_, webViewRect) = self.view.bounds.divide(120, fromEdge: CGRectEdge.MaxYEdge)
        
        // Webview
        self.webView.frame = webViewRect
        self.webView.backgroundColor = self.view.backgroundColor
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
    
    static func webViewConfiguration() -> WKWebViewConfiguration {
        
        let config = WKWebViewConfiguration()
        
        guard let path = NSBundle.mainBundle().pathForResource("InjectCSS", ofType: "js") else {
            return config
        }
        
        guard let scriptContent = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) else {
            return config
        }
        
        
        
        let script = WKUserScript(source: scriptContent, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)

        return config
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