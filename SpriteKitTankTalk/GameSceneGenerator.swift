//
//  GameSceneGenerator.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

struct GameSceneGenerator {
    static func fromIndex(index: Int) -> GameScene? {
        let config = Config.sharedConfig()
        let scene = GameScene.unarchiveFromFile("GameScene\(index)") as? GameScene
        if let scene = scene {
            
            let realIndex = index - 1
            scene.sceneDescription = Config.sharedConfig().scenes[realIndex]
            
            switch index {
            case 1: scene.setup = scene.setUp1
            case 2: scene.setup = scene.setUp2
            case 3: scene.setup = scene.setUp3
            case 4: scene.setup = scene.setUp4
            case 5: scene.setup = scene.setUp5
            case 6: scene.setup = scene.setUp6
            default:
                scene.title.text = "This scene has not been implemented yet"
            }
            
        }
        
        
        return scene
    }
}



struct LocationGenerator {
    let sceneSize : CGSize
    let outSpan: CGFloat
    
    enum Position : Int {
        case Top = 0
        case Right = 1
        case Bottom = 2
        case Left = 3
        
        static func random() -> Position {
            return Position(rawValue: Int(arc4random()%4))!
        }
        
        func opssiteToPosition(position: Position) -> Bool {
            return (abs(self.rawValue - position.rawValue) == 2)
        }
    }
    
    func randomLocation() -> CGPoint {
        
        let position = Position.random()
        return randomLocation(size: sceneSize, span: outSpan, position: position)
    }
    
    private func randomLocation(#size: CGSize, span: CGFloat, position: Position) -> CGPoint {
        
        var location = CGPoint(
            x: CGFloat(arc4random()) % size.width,
            y: CGFloat(arc4random()) % size.height)
        
        switch position {
        case .Top:
            location.y = size.height + span
        case .Right:
            location.x = size.width + span
        case .Bottom:
            location.y = -span
        default:
            location.x = -span
        }
        
        return location
    }
}