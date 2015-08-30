//
//  GameExtensions.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit


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
            
            self.speakBoxController.speakText("Ahhhhhh!", willStart: nil, completion: nil)
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
            
            for child in self.children {
                if (child.name == nil && child.physicsBody != nil) {
                    child.physicsBody!.affectedByGravity = true
                }
            }
            
            Dispatch.after(2.0, block: { () -> () in
                if let nextScene = self.nextScene {
                    nextScene(showCode: false)
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
        
        
        self.speakBoxController.speakText("Ahhhhhh!", willStart: nil, completion: nil)
    }
    
    func didContact6(nodes: [NodeType : SKNode]) {
        //
    }
}

extension GameScene {
    func setUp7() {
        self.didContact = didContact7
        self.character.position = CGPoint(x: 700.0, y: self.size.height - 150)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = true
        self.character.physicsBody = characterPhysic
    }
    
    func didContact7(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            for i in 0...5 {
                let delay = Double(i) * 0.6
                Dispatch.after(delay, block: { () -> () in
                    let cat = self.cat()
                    
                    self.addChild(cat)
                    let dx = (CGFloat(arc4random()%50) + 20) * -1.0
                    let dy = CGFloat(arc4random()%50) + 40
                    let vector = CGVector(dx: dx, dy: dy)
                    
                    cat.physicsBody!.applyImpulse(vector)
                })
                
            }
        }
    }
    
    func cat() -> SKNode {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = NodeType.Cat.toString()
        cat.position = CGPointApplyAffineTransform(self.character.position, CGAffineTransformMakeTranslation(-60, 60))
        cat.setScale(0.15)
        cat.zRotation = CGFloat(Double(arc4random())%M_PI)
        
        // Physic body
        let physicBody = PhysicBody.physicsForNode(cat)
        physicBody.friction = 0.1
        physicBody.affectedByGravity = true
        physicBody.restitution = 1.0
        physicBody.mass = 0.15
        physicBody.dynamic = true
        cat.physicsBody = physicBody
        
        return cat
    }
}

extension GameScene {
    func setUp8() {
        self.didContact = didContact8
        self.character.physicsBody!.affectedByGravity = false
    }
    
    func didContact8(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            let validSize = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(0.8, 0.8))
            
            for i in 0...8 {
                let delay = Double(i) * 0.3
                Dispatch.after(delay, block: { () -> () in
                    let fireEmitter = self.fireEmitter()
                    
                    let x = CGFloat(arc4random()%UInt32(validSize.width))
                    let y = CGFloat(arc4random()%UInt32(validSize.height))
                    fireEmitter.position = CGPoint(x: x, y: y)
                    
                    self.addChild(fireEmitter)
                    
                })
                
            }
        }
    }
    
    func fireEmitter() -> SKEmitterNode{
        let emitterPath: String = NSBundle.mainBundle().pathForResource("Fire", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as! SKEmitterNode
        emitterNode.setScale(0.8)
        
        return emitterNode
    }
}

extension GameScene : GKAgentDelegate {
    
    func setUp9() {
        self.didContact = didContact9
        

    }
    
    func didContact9(nodes: [NodeType : SKNode]) {
        
    }
    
}

extension GameScene {
    func setUp10() {
        self.didContact = didContact10
    }
    
    func didContact10(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            self.speakBoxController.runDemo({ (cancelled, text) -> () in
                //
            })
        }
    }
    
}
