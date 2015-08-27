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
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.restAtlasses = Textures.forRest()
        self.runAtlasses = Textures.forRun()
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func runToPosition(position: CGPoint, completion: (()->())?) {

        let radiants = self.position.radiantsToPoint(position)
        let direction = Direction.fromRadiants(radiants)
        let duration = NSTimeInterval(self.position.distanceToPoint(position) / 200)
        
        println("rad : \(radiansToDegrees(radiants))")
        
        // run textures
        let runAction = SKAction.animateWithTextures(self.runAtlasses[direction]!, timePerFrame: 0.05)
        self.runAction(SKAction.repeatActionForever(runAction), withKey: "runTexture")

        // move
        let move = SKAction.moveTo(position, duration: duration)
        self.runAction(move, completion: { () -> Void in
            self.removeActionForKey("runTexture")
            self.rest(direction)
            if let completion = completion {
                completion()
            }
        })
        
        
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
        
        return .Front
//        
//        switch radiants {
//        case -0.8...0.8: return .Front
//            case 0.81...
//            
//        }
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

