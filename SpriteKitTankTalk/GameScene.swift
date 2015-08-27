//
//  GameScene.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var nextScene: (()->())?
    var setup: (()->())?
    
    var action: (()->())?
    
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
        if let character = self.childNodeWithName("character") as? Character {
            return character
        }
        
        let character = Character(imageNamed: "slice01.png")
        character.name = "character"
        character.setScale(0.5)
        character.position = self.view!.center
        self.addChild(character)
        
        return character
    }
    
    var title:  SKLabelNode {
        return self.childNodeWithName("title") as! SKLabelNode
    }
    
    var nextPortal: SKSpriteNode {
        return self.childNodeWithName("nextPortal") as! SKSpriteNode
    }
    
    var actionBox:  SKSpriteNode? {
        return self.childNodeWithName("actionBox") as? SKSpriteNode
    }
    
    override func didMoveToView(view: SKView) {
        
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            self.character.removeAllActions()
        
            self.character.runToPosition(location, completion: { () -> () in
                self.checkForPortals()
            })
        }
    }
    
    func checkForPortals() {
        if isCharacterOnNode(self.nextPortal) {
            if let nextScene = self.nextScene {
                nextScene()
            }
        }
        else if let actionBox = self.actionBox {
            if isCharacterOnNode(actionBox) {
                if let action = action {
                    action()
                }
            }
        }
    }
    
    private func isCharacterOnNode(node: SKNode) -> Bool {
        if let name = node.name {
            let allNodes = self.nodesAtPoint(self.character.position)
            let nodes = allNodes.filter({ (aNode: AnyObject) in
                if let anSKNode = aNode as? SKNode  {
                    if let skName = anSKNode.name {
                        return skName == name
                    }
                }
                
                return false
            })
            return (nodes.count > 0 && nodes.first as? SKNode != nil)
        }
        
        return false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


extension GameScene {
    func setUp1() {
        
    }
    func action1() {
        
    }
}

extension GameScene {
    func setUp2() {
        self.action = action2
    }
    
    func action2() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let characterPhysic = SKPhysicsBody(rectangleOfSize: self.character.size)
        self.character.physicsBody = characterPhysic
        
        
        Dispatch.after(4.0, block: { () -> () in
            if let nextScene = self.nextScene {
                nextScene()
            }
        })
        
    }
}

extension GameScene {
    func setUp3() {
        self.character.removeAllActions()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let characterPhysic = SKPhysicsBody(rectangleOfSize: self.character.size)
        characterPhysic.friction = 0.01
        self.character.physicsBody = characterPhysic
        self.character.position = CGPoint(x: self.view!.center.x, y: self.view!.bounds.size.height + 50)
    }
    
    func action3() {
        
    }
}