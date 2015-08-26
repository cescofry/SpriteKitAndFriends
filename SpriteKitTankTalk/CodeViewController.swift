//
//  CodeViewController.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit

class CodeViewController : UIViewController {

    var code : NSAttributedString? {
        didSet {
            if let code = code {
                let frame = CGRectInset(self.view.bounds, 10, 10)
                let label = UILabel(frame: frame)
                label.numberOfLines = 0
                label.attributedText = code
                self.view.addSubview(label)
            }
        }
    }
    
    var aboutToDismiss : (()->())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = UIColor.lightTextColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func inNavigationController(code: NSAttributedString, dismissBlock: (()->())?) -> UINavigationController {
        
        let vc = CodeViewController(nibName: nil, bundle: nil)
        vc.code = code
        vc.aboutToDismiss = dismissBlock
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: vc, action: Selector("dismiss"))
        vc.navigationItem.rightBarButtonItem = closeBtn
        return navVC
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let aboutToDismiss = self.aboutToDismiss {
                aboutToDismiss()
            }
        })
    }
}