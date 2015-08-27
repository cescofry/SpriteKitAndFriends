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
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    func didContact2(nodes: [NodeType : SKNode]) {
        
        if let actionBox = nodes[.ActionBox] as? SKSpriteNode {
            self.popActionNode(actionBox)
            
            self.character.physicsBody!.affectedByGravity = true
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            
            Dispatch.after(4.0, block: { () -> () in
                if let nextScene = self.nextScene {
                    nextScene()
                }
            })
        }
        
        
    }
}

extension GameScene {
    func setUp3() {
        
        self.didContact = didContact3
        
        self.character.removeAllActions()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        let characterPhysic = self.character.physicsBody!
        characterPhysic.friction = 0.01
        self.character.physicsBody = characterPhysic
        self.character.position = CGPoint(x: self.view!.center.x, y: self.view!.bounds.size.height + 50)
    }
    
    func didContact3(nodes: [NodeType : SKNode]) {
        
    }
}