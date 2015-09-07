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
            if let character = self.character {
                character.position = position
            }
            
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
                guard let character = self.character else {
                    return
                }
                
                let duration = NSTimeInterval(character.position.distanceToPoint(position) / 200)
                
                // move
                let move = SKAction.moveTo(position, duration: duration)
                character.runAction(move, completion: { () -> Void in
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
                
                guard let character = self.character else {
                    return
                }
                character.runToPosition(position, completion: { () -> () in
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
        
        guard let actionBox = nodes[.ActionBox] as? SKSpriteNode,
            let _ = nodes[.Character] as? SKSpriteNode else {
                return
        }
        
        self.popActionNode(actionBox)
        
        if let speakBoxController = self.speakBoxController {
            speakBoxController.speakText("Ahhhhhh!", willStart: nil, completion: nil)
        }
        
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


extension GameScene {
    func setUp6() {
        self.didContact = didContact6
        self.shouldRunEntranceAnimation = false
        
        if let audioController = self.audioController {
            audioController.stopBackgroundMusic()
            audioController.playMarioBackgroundMusic()
        }
        hidewalls()
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        self.character.removeAllActions()
        self.character.position = CGPoint(x: 700.0, y: self.size.height + 50)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        characterPhysic.affectedByGravity = true
        self.character.physicsBody = characterPhysic
        
        if let speakBoxController = self.speakBoxController {
            speakBoxController.speakText("Ahhhhhh!", willStart: nil, completion: nil)
        }
    }
    
    func didContact6(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            if let character = nodes[.Character] as? SKSpriteNode {
                actionBox.physicsBody = nil
                let deltaY = character.position.y - character.size.height
                
                let move = SKAction.moveToY(deltaY, duration: 1.5)
                self.character.runAction(move, completion: { () -> Void in
                    if let nextScene = self.nextScene {
                        nextScene(showCode: false)
                    }
                })
            }
        }
    }
    
    func hidewalls() {
        let walls = self.childrenFromType(.Wall)
        for wall in walls {
            wall.alpha = 0.0
        }
    }
}

extension GameScene {
    func setUp7() {
        self.didContact = didContact7
        self.shouldRunEntranceAnimation = false
        
        hidewalls()
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)

        let pipe = self.childNodeWithName("pipe") as! SKSpriteNode
        self.character.position = CGPoint(x: pipe.position.x, y: pipe.position.y)
        self.character.physicsBody!.affectedByGravity = false

        let deltaY = pipe.position.y + self.character.size.height + 40
        let move = SKAction.moveToY(deltaY, duration: 1.5)
        
        let originalPipePhysics = pipe.physicsBody
        pipe.physicsBody = nil
        
        self.character.runAction(move) { () -> Void in
            pipe.physicsBody = originalPipePhysics
            self.character.physicsBody!.affectedByGravity = true
        }

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
        var characterPosition = CGPointZero
        if let character = self.character {
            characterPosition = character.position
        }
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = NodeType.Cat.toString()
        cat.position = CGPointApplyAffineTransform(characterPosition, CGAffineTransformMakeTranslation(-60, 60))
        cat.setScale(0.15)
        cat.zRotation = CGFloat(Double(arc4random())%M_PI)
        
        // Physic body
        let physicBody = PhysicBody.physicsForNode(cat)
        physicBody.friction = 0.1
        physicBody.affectedByGravity = true
        physicBody.restitution = 0.9
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
        
        if let audioController = self.audioController {
            audioController.stopBackgroundMusic()
            audioController.playBackgroundMusic()
        }
    }
    
    func didContact8(nodes: [NodeType : SKNode]) {
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            self.setPiros()
            
            Dispatch.after(2.0, block: { () -> () in
                self.setFires()
            })
            
            Dispatch.after(6.0, block: { () -> () in
                if let speakBoxController = self.speakBoxController {
                    speakBoxController.speakText("Oh crap. let's get out of here", willStart: nil, completion: nil)
                }
            })
            
        }
    }
    
    func setPiros() {
        let validSize = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(0.8, 0.8))
        
        var delay = 0.0
        for _ in 0...4  {
            Dispatch.after(delay, block: { () -> () in
                let piroEmitter = self.piroEmitter()
                
                let x = CGFloat(arc4random()%UInt32(validSize.width))
                let y = CGFloat(arc4random()%UInt32(validSize.height))

                piroEmitter.position = CGPoint(x: x, y: y)
                self.addChild(piroEmitter)
                Dispatch.after(1.0, block: { () -> () in
                    piroEmitter.removeFromParent()
                })
            })
            delay += 0.5
            
        }
        
    }
    
    func setFires() {
        let fireLocations = [
            CGPoint(x: 816.0, y: 102.0),
            CGPoint(x: 122.0, y: 598.0),
            CGPoint(x: 24.0, y: 245.0)
        ]
        
        var delay = 0.0
        for location in fireLocations {
            Dispatch.after(delay, block: { () -> () in
                let delay = (delay + 0.1)
                let fireEmitter = self.fireEmitter()
                fireEmitter.position = location
                
                self.addChild(fireEmitter)
                
                Dispatch.after(1.0 * delay, block: { () -> () in
                    fireEmitter.setScale(1.2)
                })
                
                Dispatch.after(2.0 * delay, block: { () -> () in
                    fireEmitter.setScale(1.8)
                })
            })
            delay += 0.4    
            
        }
    }

    
    func fireEmitter() -> SKEmitterNode{
        let emitterPath: String = NSBundle.mainBundle().pathForResource("Fire", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as! SKEmitterNode
        emitterNode.setScale(0.8)
        
        return emitterNode
    }
    
    func piroEmitter() -> SKEmitterNode{
        let emitterPath: String = NSBundle.mainBundle().pathForResource("Piro", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath) as! SKEmitterNode
        emitterNode.setScale(0.8)
        
        return emitterNode
    }
}


extension GameScene {
    func setUp9() {
        self.didContact = didContact9
    }
    
    func didContact9(nodes: [NodeType : SKNode]) {
        
        guard let actionBox = nodes[.ActionBox] as? SKSpriteNode,
            let speakBoxController = self.speakBoxController else {
                return
        }

        self.popActionNode(actionBox)
        speakBoxController.runDemo({ (cancelled, text) -> () in
            //
            
        })
    }
    
}


extension GameScene {
    func setUp10() {
        self.didContact = didContact10
        self.shouldRunEntranceAnimation = false
        self.nextPortal.alpha = 0.0
        self.title.color = UIColor.whiteColor()
        
        self.character.removeAllActions()
        let lines = ["@cescofry - francesco.co", "github.com/cescofry/SpriteKitAndFriends", "developer.apple.com/spritekit"]
        
        
        var position = CGPoint(x: 100, y: self.size.height + 100)
        self.character.position = position
        
        position.y = self.title.position.y - 100
        self.character.runToPosition(position) { () -> () in
            
            self.moveToLines(lines) { () -> () in
                if let speakBoxController = self.speakBoxController {
                    speakBoxController.speakText("Thank You", willStart: nil, completion: nil)
                }
                
                Dispatch.after(2.0, block: { () -> () in
                    // Do Something to close
                })
            }
        }
        
        
    }
    
    func didContact10(nodes: [NodeType : SKNode]) {
       
    }
    
    func moveToLines(var lines : [String], completedAll: (()->())) {
        
        guard let line = lines.first else {
            completedAll()
            return
        }
        
        lines.removeFirst()
    
        let lineGap : CGFloat = 100.0
        var position = self.character.position
        position.y -= lineGap
        self.character.runToPosition(position) { () -> () in
            let label = self.labelForString(line)
            var labelPosition = self.character.position
            labelPosition.x += 100
            label.position = labelPosition
            
            self.addChild(label)
            
            let fireWall = self.fireNodeForSize(label.frame.size)
            fireWall.position = label.position
            
            self.addChild(fireWall)
         
            Dispatch.after(1.6, block: { () -> () in
                self.moveToLines(lines, completedAll: completedAll)
            })
        }
        
    }
    
    func labelForString(string: String) -> SKLabelNode {
        let label = SKLabelNode(text: string)
        var labelPosition = self.character.position
        labelPosition.x += 100
        label.position = labelPosition
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label.color = UIColor.whiteColor()
        label.fontSize = 38.0
        label.alpha = 0.0

        
        let fadeIn = SKAction.fadeInWithDuration(0.6)
        label.runAction(fadeIn)
        
        return label
    }
    
    func fireNodeForSize(size: CGSize) -> SKNode {
        var x : CGFloat = 0.0
        
        let node = SKNode()
        while (x < size.width) {
            let fire = fireEmitter()
            fire.position = CGPoint(x: x, y: 0.0)
            node.addChild(fire)
            x += 50.0
        }
        
        let remove = SKAction.fadeOutWithDuration(1.5)
        node.runAction(remove) { () -> Void in
            node.removeFromParent()
        }
        
        return node
    }
    
}
