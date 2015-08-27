//
//  GameScene.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import SpriteKit

extension SKScene {
    func childNodeFromType(type: NodeType) -> SKNode? {
        if (type == .Other) {
            return nil
        }
        
        return self.childNodeWithName(type.toString())
    }
}

typealias DidContactBlock = (nodes: [NodeType : SKNode])->()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var nextScene: (()->())?
    var setup: (()->())?
    
    var didContact: DidContactBlock?
    
    var currentActionIndex = 0
    var speechSynthesizer = SpeechSynthesizer()
    
    var sceneDescription: SceneDescription? {
        didSet {
            if let sceneD = sceneDescription {
                self.title.text = sceneD.title
            }
        }
    }
    
    var character: Character {
        if let character = self.childNodeFromType(.Character) as? Character {
            return character
        }
        
        let character = Character(imageNamed: "slice01.png")
        character.name = "character"
        character.setScale(0.5)
        character.zPosition = 99.0
        character.position = self.view!.center
        self.addChild(character)
        
        return character
    }
    
    var runToPosition : ((position: CGPoint, completion: (()->())?) -> ())?
    
    var title:  SKLabelNode {
        return self.childNodeWithName("title") as! SKLabelNode
    }
    
    var nextPortal: SKSpriteNode {
        return self.childNodeFromType(.Portal) as! SKSpriteNode
    }
    
    var actionBox:  SKSpriteNode? {
        return self.childNodeFromType(.ActionBox) as? SKSpriteNode
    }
    
    override func didMoveToView(view: SKView) {
        
        setDefaultPhysicBodies()
        
        setDefaultActions()
        
        self.character.position = CGPoint(x: -50.0, y: self.view!.center.y) // lazy loading
        let startPosition = CGPoint(x: 80.0, y: self.view!.center.y)
        self.character.runToPosition(startPosition, completion: { () -> () in
            // run action 1
            self.speakActionAndAdvance()
        })
        
        if let setup = self.setup {
            setup()
        }
    }
    
    private func setDefaultActions() {
        runToPosition = { (position: CGPoint, completion: (()->())?) in
            self.character.runToPosition(position, completion: { () -> () in
                if let completion = completion {
                    completion()
                }
            })
        }
        
        didContact = { (nodes: [NodeType : SKNode]) in
            
        }
    }
    
    private func setDefaultPhysicBodies() {
        self.physicsWorld.contactDelegate = self
        
        self.character.physicsBody = PhysicBody.physicsForNode(self.character)
        self.nextPortal.physicsBody = PhysicBody.physicsForNode(self.nextPortal)
        self.nextPortal.physicsBody!.dynamic = false
        if let actionBox = self.actionBox {
            actionBox.physicsBody = PhysicBody.physicsForNode(self.actionBox!)
            actionBox.physicsBody!.dynamic = false
            
        }
    }
    
    func speakActionAndAdvance() {
        let actions = self.sceneDescription?.actions
        if let actions = actions {
            if actions.count > self.currentActionIndex {
                let action = actions[self.currentActionIndex]
                speechSynthesizer.speakText(action, completion: { (cancelled) -> () in
                    self.currentActionIndex++
                    self.speakActionAndAdvance()
                })
            }
        }
    }
    
    func popActionNode(node : SKSpriteNode) {
        
        let shrink = SKAction.scaleBy(0.2, duration: 0.3)
        node.runAction(shrink)
        
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        node.runAction(fade, completion: { () -> Void in
            node.removeFromParent()
        })
        
    }
    
    func portalAnimation(completion:(()->())?) {
        
        let center = self.nextPortal.position
        self.character.removeAllActions()
        
        let move = SKAction.moveTo(center, duration: 0.7)
        self.character.runAction(move)
        let spin = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        self.character.runAction(spin)
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        self.character.runAction(fade, completion: completion)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            self.character.removeAllActions()
        
            if let runToPosition = self.runToPosition {
                runToPosition(position: location, completion: { () -> () in
                    //
                })
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    private func nodesOutOfContact(contact: SKPhysicsContact) -> [NodeType : SKNode] {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        var others = [NodeType : SKNode]()
        if let nodeA = nodeA {
            if let name = nodeA.name {
                let type = NodeType.fromString(name)
                if type != .Other {
                    others[type] = nodeA
                }
            }
        }
        
        if let nodeB = nodeB {
            if let name = nodeB.name {
                let type = NodeType.fromString(name)
                if type != .Other {
                    others[type] = nodeB
                }
            }
        }
        return others
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let nodes = nodesOutOfContact(contact)
        
        if let contactFunc = self.didContact {
            contactFunc(nodes: nodes)
        }
        
        if let _ = nodes[.Character] {
            if let portal = nodes[.Portal] {
                if let nextScene = nextScene {
                    portalAnimation({ () -> () in
                        self.character.removeFromParent()
                        Dispatch.after(0.5, block: { () -> () in
                            nextScene()
                        })
                    })
                }
            }
        }
    }
}

