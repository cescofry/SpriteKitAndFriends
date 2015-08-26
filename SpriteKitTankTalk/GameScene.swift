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
    
    var previousPortal:  SKSpriteNode {
        return self.childNodeWithName("previousPortal") as! SKSpriteNode
    }
    
    override func didMoveToView(view: SKView) {
        self.character.position = CGPoint(x: -50.0, y: self.view!.center.y) // lazy loading
        let startPosition = CGPoint(x: 80.0, y: self.view!.center.y)
        self.character.runToPosition(startPosition, completion: { () -> () in
            // run action 1
        })
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
    }
    
    private func isCharacterOnNode(node: SKNode) -> Bool {
        let node = self.nodesAtPoint(self.character.position).filter({return $0.name == node.name!}).first as? SKNode
        return node != nil
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