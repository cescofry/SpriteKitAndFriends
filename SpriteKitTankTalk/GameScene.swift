//
//  GameScene.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import SpriteKit

enum NodeType {
    case Character, ActionBox, Portal, Other
    
    static func fromString(string : String) -> NodeType {
        switch string {
        case "character": return .Character
        case "actionBox": return .ActionBox
        case "portal": return .Portal
        default: return .Other
        }
    }
    
    func toString() -> String {
        switch self {
        case .Character: return "character"
        case .ActionBox: return "actionBox"
        case .Portal: return "portal"
        default: return "other"
        }
    }
}

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
        if let _ = self.actionBox {
            self.actionBox!.physicsBody = PhysicBody.physicsForNode(self.actionBox!)
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
        node.removeFromParent()
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
                    nextScene()
                }
            }
        }
    }
}

