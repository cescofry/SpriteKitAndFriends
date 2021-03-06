//
//  Character.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    
    private var restAtlasses : [Direction: [SKTexture]]
    private var runAtlasses : [Direction: [SKTexture]]
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.restAtlasses = Textures.forRest()
        self.runAtlasses = Textures.forRun()
        super.init(texture: texture, color: color, size: size)
        self.rest(.Front)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func runToPosition(position: CGPoint, completion: (()->())?) {
        let radiants = self.position.radiantsToPoint(position)
        let direction = Direction.fromRadiants(radiants)
        let duration = NSTimeInterval(self.position.distanceToPoint(position) / 200)
        
        // run textures
        let runAction = SKAction.animateWithTextures(self.runAtlasses[direction]!, timePerFrame: 0.05)
        self.runAction(SKAction.repeatActionForever(runAction), withKey: "runTexture")

        // move
        let move = SKAction.moveTo(position, duration: duration)
        self.runAction(move, completion: { () -> Void in
            self.removeActionForKey("runTexture")
            self.rest(.Front)
            if let completion = completion {
                completion()
            }
        })

        /*
        // This may work with a bit more twigging!
        self.physicsBody!.mass = 1.0
        self.physicsBody!.linearDamping = 0.80
        let vector = CGVectorMake(position.x - self.position.x, position.y - self.position.y)
        self.physicsBody!.velocity = vector
        */
        
        
    }
    
    func rest(direction: Direction) {
        let restAction = SKAction.animateWithTextures(self.restAtlasses[direction]!, timePerFrame: 0.05)
        self.runAction(restAction)
    }
}

enum Direction {
    case Front, Left, Back, Right
}

extension Direction {
    func restAtlasRange() -> Range<Int>{
        switch self {
        case .Front:
            return restFront
        case .Left:
            return restLeft
        case .Back:
            return restBack
        case .Right:
            return restRight
        }
    }
    
    func runAtlasRange() -> Range<Int>{
        switch self {
        case .Front:
            return runFront
        case .Left:
            return runLeft
        case .Back:
            return runBack
        case .Right:
            return runRight
        }
    }
    
    static func fromRadiants(radiants : CGFloat) -> Direction {
        
        if radiants < -0.8 && radiants > -2.4 {
            return .Right
        }
        else if radiants > 0.8 && radiants < 2.4 {
            return .Left
        }
        else if abs(radiants) > 1.5 {
            return .Front
        }
        else {
            return .Back
        }
    }

}


enum NodeType {
    case Character, ActionBox, Portal, Cat, Wall, Pipe, Other
    
    static func fromString(string : String) -> NodeType {
        switch string {
        case "character": return .Character
        case "actionBox": return .ActionBox
        case "portal": return .Portal
        case "cat": return .Cat
        case "wall": return .Wall
        case "pipe": return .Pipe
        default: return .Other
        }
    }
    
    func toString() -> String {
        switch self {
        case .Character: return "character"
        case .ActionBox: return "actionBox"
        case .Portal: return "portal"
        case .Cat: return "cat"
        case .Wall: return "wall"
        case .Pipe: return "pipe"
        default: return "other"
        }
    }
}


struct PhysicBody {
    
    static func physicsForNode(node: SKSpriteNode) -> SKPhysicsBody {
        
        let name = (node.name != nil) ? node.name! : "other"
        let type = NodeType.fromString(name)
        var physic : SKPhysicsBody
        
        if type == .Cat {
            physic = SKPhysicsBody(circleOfRadius: node.size.width / 2.2)
        }
        else if let texture = node.texture {
            physic = SKPhysicsBody(texture: texture, size: node.size)
        }
        else {
            physic = SKPhysicsBody(rectangleOfSize: node.size)
        }
        
        physic.usesPreciseCollisionDetection = false
        physic.dynamic = true
        physic.allowsRotation = false
        physic.affectedByGravity = false
        
        switch type {
        case .Character:
            physic.categoryBitMask = 0x1 << 0
            physic.contactTestBitMask = 0x1 << 1
            physic.collisionBitMask = 0x1 << 1
        case .ActionBox:
            physic.categoryBitMask = 0x1 << 1
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
        case .Portal:
            physic.categoryBitMask = 0x1 << 2
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
        case .Cat:
            physic.categoryBitMask = 0x1 << 3
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
            physic.allowsRotation = true
        case .Wall:
            physic.categoryBitMask = 0x1 << 4
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
        case .Pipe:
            physic.categoryBitMask = 0x1 << 5
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
            physic.pinned = true
        default:
            physic.categoryBitMask = 0x1 << 8
            physic.contactTestBitMask = 0x1 << 0
            physic.collisionBitMask = 0x1 << 0
            physic.allowsRotation = true
        }
        
        return physic
    }
}

struct Textures {
    
    static func forRest() -> [Direction: [SKTexture]] {
        return forRest(true)
    }
    
    static func forRun() -> [Direction: [SKTexture]] {
        return forRest(false)
    }
    
    private static func forRest(isRest: Bool) -> [Direction: [SKTexture]] {
        
        let directions = [Direction.Front, Direction.Left, Direction.Back, Direction.Right]
        
        var textureDictionary = [Direction: [SKTexture]]()
        for direction in directions {
            // load all textures form direction.restAtlasRange()
            var textures = [SKTexture]()
            let range = isRest ? direction.restAtlasRange() : direction.runAtlasRange()
            for i in range {
                let name = NSString(format: "slice%.2d", i) as String
                let texture = SKTexture(imageNamed: name)
                textures.append(texture)
            }
            textureDictionary[direction] = textures
        }
        
        return textureDictionary
    }
}

private let restFront   = 1...3
private let restLeft    = 4...6
private let restBack    = 7...7
private let restRight   = 8...10

private let runFront    = 11...20
private let runLeft     = 21...30
private let runBack     = 31...40
private let runRight    = 41...50

