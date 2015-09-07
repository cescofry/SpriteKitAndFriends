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
    let audioController = AudioController()
    var speakBoxController: SpeakBoxController!
    
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
        
        self.speakBoxController.stopSpeaking()
        
        self.cleanUpScene()
        self.scene = GameSceneGenerator.fromIndex(index)
        
        guard let scene = scene else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        scene.audioController = self.audioController
        scene.speakBoxController = self.speakBoxController
        
        self.isDebug = Config.sharedConfig().isDebug
        
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        scene.nextScene = nextScene
   
    }
    
    func cleanUpScene() {
        if let scene = self.scene {
            scene.removeAllChildren()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.speakBoxController = SpeakBoxController(viewController: self, type: .Character)

        nextScene(false)
        self.audioController.playBackgroundMusic()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
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
            self.speakBoxController.stopSpeaking()
            CodeViewController.presentInNavigationController(self, sceneDescription: sceneDescription, dismissBlock: loadCurrentScene)
        }
        else {
            loadCurrentScene()
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier where
        identifier == "OptionsViewController",
            let navVC = segue.destinationViewController as? UINavigationController else {
                return
        }
        
        guard let optionsVC = navVC.viewControllers.first as? OptionsViewController else {
                return
        }
        
        optionsVC.currentIndex = self.index
        optionsVC.didSelectIndex = {(index: Int) in
            self.index = index
            self.loadCurrentScene()
        }
    }
}
