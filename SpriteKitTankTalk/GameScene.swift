//
//  GameScene.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var character: SKSpriteNode {
        return self.childNodeWithName("character") as! SKSpriteNode
    }
    
    var title:  SKLabelNode {
        return self.childNodeWithName("title") as! SKLabelNode
    }
    
    override func didMoveToView(view: SKView) {
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            //let test = self.children.first!
            //let sprite = self.childNodeWithName("test")
            
            
            self.character
            self.character.removeAllActions()
            
            self.character.position = location
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            self.character.runAction(SKAction.repeatActionForever(action))            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
