//
//  TestViewController.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit
import SpriteKit

class TestViewController: UIViewController {
    
    // SKScene and SKNode
    
//    override func viewDidLoad() {
//        let speechSynthesizer = SpeechSynthesizer().runDemo { (cancelled) -> () in
//            //nil
//        }
//    }
    
//    override func loadView() {
//        self.view = SKView(frame: UIScreen.mainScreen().bounds)
//    }
    
    
    // SKScene and SKAction
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKScene(size: self.view.bounds.size)
        
        // Not Needed if from Storyboard
        self.view = SKView(frame: self.view.bounds)

        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        addNodeToScene(scene)
    }
    
    func addNodeToScene(scene : SKScene) {
        
        // Y Coordinate System inverted
        let size = CGSize(width: 50.0, height: 50.0)
        let node = SKSpriteNode(color: UIColor.redColor(), size: size)
        node.position = CGPoint(x: 100.0, y: 100.0)
        
        scene.addChild(node)
    }
    
    // SKAction
    
    func addActionToNode(node: SKSpriteNode) {
        let position = CGPoint(x: 50.0, y: 40.0)
        let move = SKAction.moveTo(position, duration: 1.0)
        
        node.runAction(move)
    }
    
    // Sprite textures
    
    func addSpritesToNode(node: SKSpriteNode) {
        var textures = [SKTexture]()
        for i in 1...10 {
            let name = NSString(format: "slice%.2d", i) as String
            let texture = SKTexture(imageNamed: name)
            textures.append(texture)
        }
        
        let spriteAction = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        node.runAction(SKAction.repeatActionForever(spriteAction))
    }
    
    // Physics
    
    func addPhysicsToNode(node: SKSpriteNode)  {
        let radius = node.size.width / 2.0
        let physics = SKPhysicsBody(circleOfRadius: radius)
        physics.dynamic = false
        physics.friction = 0.2
        
        node.physicsBody = physics
    }
    
    // Gravity
    
    func addGravity(scene: SKScene, node: SKSpriteNode)  {
        scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        
        let radius = node.size.width / 2.0
        let physics = SKPhysicsBody(circleOfRadius: radius)
        //...
        
        physics.affectedByGravity = true
        physics.dynamic = true
    }
    
    // Gravity and Collisions
    
    func shootNodeWithPhysics(node: SKSpriteNode)  {
        let radius = node.size.width / 2.0
        let physics = SKPhysicsBody(circleOfRadius: radius)
        physics.dynamic = false
        physics.friction = 0.2
        physics.mass = 1.2 // resistence to impulses
        physics.restitution = 0.9 // bouncing
        
        
        physics.applyForce(CGVector(dx: 20.0, dy: -30.0))
        // remember inverted coordinates
        
        node.physicsBody = physics
    }
    
    // Emitter
    
    func addEmitterToNode(node : SKNode) {
        // Create a new File of type Spritekit Partle File name Fire.
        let bundle = NSBundle.mainBundle()
        let emitterPath: String = bundle.pathForResource("Fire", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath)
        
        node.addChild(emitterNode as! SKEmitterNode)
    }
    
    // Path Finding
    
    func setupPathFinding(scene: SKScene, node: SKSpriteNode)  {
        
    }

    // MaxminStrategist
    
    func setupStrategist()  {
        
    }
    
}

