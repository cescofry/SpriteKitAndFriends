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
        
        self.character.removeAllActions()
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = false
        self.character.physicsBody = characterPhysic
    }
    
    func didContact5(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
            
            if let allChildren = self.children as? [SKNode] {
                for child in allChildren {
                    if (child.name == nil && child.physicsBody != nil) {
                        child.physicsBody!.affectedByGravity = true
                    }
                }
            }
            
        }
    }
}


extension GameScene {
    func setUp6() {
        
        self.didContact = didContact6
        
        self.character.removeAllActions()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        self.character.physicsBody = characterPhysic
        self.character.position = CGPoint(x: self.view!.center.x, y: self.view!.bounds.size.height + 50)
    }
    
    func didContact6(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            
            Dispatch.after(4.0, block: { () -> () in
                if let nextScene = self.nextScene {
                    nextScene()
                }
            })
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        }
    }
}

