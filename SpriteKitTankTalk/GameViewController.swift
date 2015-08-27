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
    var scene : GameScene?
    
    var isDebug : Bool? {
        didSet {
            let skView = self.view as! SKView
            
            let debug = isDebug != nil ? isDebug! : false
            skView.showsFPS = debug
            skView.showsNodeCount = debug
            skView.showsPhysics = debug
        }
    }
    
    func nextScene(showCode: Bool) {
        self.index++
        if showCode {
            self.presentCode()
        }
        else {
            loadCurrentScene()
        }
    }
    
    func loadCurrentScene(){
    
        self.scene = GameSceneGenerator.fromIndex(index)
        
        if let scene = self.scene  {
            // Configure the view.
            
            self.isDebug = Config.sharedConfig().isDebug
 
            let skView = self.view as! SKView
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            scene.nextScene = nextScene
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextScene(false)
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
    
    func presentCode() {
        if let sceneDescription = self.scene?.sceneDescription {
            let vc = CodeViewController.inNavigationController(sceneDescription.code, dismissBlock: loadCurrentScene)
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                //
            })
        }
        else {
            loadCurrentScene()
        }
    }
    
    @IBAction func optionsAction(sender: AnyObject?) {
        if let btn = sender as? UIBarButtonItem {
            let navVC = OptionsViewController.fromNavigationBarButton(btn)
            if let optionsVC = navVC.optionsViewController() {
                optionsVC.currentIndex = self.index
                optionsVC.didSelectIndex = {(index: Int) in
                    self.index = index
                    self.loadCurrentScene()
                }
                
            }
            
            
            self.presentViewController(navVC, animated: true, completion: nil)
        }
    }
}
