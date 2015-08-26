//
//  GameViewController.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var index = 0
    
    func nextSlide() {
        self.index++
        
        if let scene = GameSceneGenerator.fromIndex(index) {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            scene.nextSlide = nextSlide
        }

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextSlide()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func codeAction(sender: AnyObject?) {
        if let btn = sender as? UIBarButtonItem {
            let vc = CodeViewController.fromUIBArButtonItem(btn)
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                vc.code = NSAttributedString(string: "This is a test\nwith lines\n\n multipme lines")
            })
        }
    }
}
