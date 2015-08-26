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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.backgroundColor = UIColor.lightTextColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func fromUIBArButtonItem(barButtonItem : UIBarButtonItem) -> CodeViewController {
        let vc = CodeViewController(nibName: nil, bundle: nil)
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.popoverPresentationController!.barButtonItem = barButtonItem
        
        return vc
    }
}