//
//  GameScene.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var nextSlide: (()->())?
    var code : NSAttributedString?
    
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
            
            let move = SKAction.moveTo(location, duration: 2.0)
            self.character.runAction(move, completion: { () -> Void in
                if let nextSlide = self.nextSlide {
                    nextSlide()
                }
            })

            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            self.character.runAction(SKAction.repeatActionForever(action))            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


extension GameScene {
    func setUp1() {
    }
}

extension GameScene {
    func setUp2() {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)

        let characterPhysic = SKPhysicsBody(rectangleOfSize: self.character.size)
        self.character.physicsBody = characterPhysic
    }
}

extension GameScene {
    func setUp3() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let characterPhysic = SKPhysicsBody(rectangleOfSize: self.character.size)
        characterPhysic.friction = 0.01
        self.character.physicsBody = characterPhysic
    }
}