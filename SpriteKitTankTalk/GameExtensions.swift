//
//  GameExtensions.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit
import SpriteKit


extension GameScene {
    func setUp1() {
        runToPosition = { (position: CGPoint, completion: (()->())?) in
            self.character.position = position
            
            if let completion = completion {
                Dispatch.after(0.5, block: completion)
            }
        }
    }
    func action1() {
        
    }
}

extension GameScene {
    func setUp2() {
        self.didContact = didContact2
        
        runToPosition = { (position: CGPoint, completion: (()->())?) in
            self.character.position = position
            
            if let completion = completion {
                Dispatch.after(0.5, block: completion)
            }
        }
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    func didContact2(nodes: [NodeType : SKNode]) {
        
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)

            runToPosition = { (position: CGPoint, completion: (()->())?) in
                let duration = NSTimeInterval(self.character.position.distanceToPoint(position) / 200)
                
                // move
                let move = SKAction.moveTo(position, duration: duration)
                self.character.runAction(move, completion: { () -> Void in
                    if let completion = completion {
                        completion()
                    }
                })
            }
            
        }
        
        
    }
}

extension GameScene {
    func setUp3() {
        self.didContact = didContact3
        
        runToPosition = { (position: CGPoint, completion: (()->())?) in
            
            let duration = NSTimeInterval(self.character.position.distanceToPoint(position) / 200)
            
            // move
            let move = SKAction.moveTo(position, duration: duration)
            self.character.runAction(move, completion: { () -> Void in
                if let completion = completion {
                    completion()
                }
            })
        }

    }
    
    func didContact3(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            runToPosition = { (position: CGPoint, completion: (()->())?) in
                self.character.runToPosition(position, completion: { () -> () in
                    if let completion = completion {
                        completion()
                    }
                })
            }
        }
    }
}

extension GameScene {
    func setUp4() {
        
        self.didContact = didContact4
        
        self.character.removeAllActions()
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = false
        self.character.physicsBody = characterPhysic
    }
    
    func didContact4(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
        }
    }
}

extension GameScene {
    func setUp5() {
        self.didContact = didContact5
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = false
        self.character.physicsBody = characterPhysic
    }
    
    func didContact5(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
            
            if let allChildren = self.children as? [SKNode] {
                for child in allChildren {
                    if (child.name == nil && child.physicsBody != nil) {
                        child.physicsBody!.affectedByGravity = true
                    }
                }
            }
            
            Dispatch.after(2.0, block: { () -> () in
                if let nextScene = self.nextScene {
                    self.nextScene!(showCode: false)
                }
            })
        }
    }
}


extension GameScene {
    func setUp6() {
        self.didContact = didContact6
        self.shouldRunEntranceAnimation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        self.character.removeAllActions()
        self.character.position = CGPoint(x: 700.0, y: self.size.height + 50)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = true
        self.character.physicsBody = characterPhysic
    }
    
    func didContact6(nodes: [NodeType : SKNode]) {
        //
    }
}

extension GameScene {
    func setUp7() {
        self.didContact = didContact7
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = true
        self.character.physicsBody = characterPhysic
    }
    
    func didContact7(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            
            let cat = SKSpriteNode(imageNamed: "action_enemy")
            cat.position = self.character.position
            cat.physicsBody = PhysicBody.physicsForNode(actionBox)
            self.addChild(cat)
            
            let emitter = SKEmitterNode()
            cat.addChild(emitter)
            
            
            
            self.popActionNode(actionBox)
        }

    }
}

