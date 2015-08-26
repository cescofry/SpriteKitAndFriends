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
            let sceneConfig = Config.sharedConfig().scenes[realIndex]
            scene.title.text = sceneConfig.title
            scene.code = sceneConfig.code
            
            switch index {
            case 1: scene.setUp1()
            case 2: scene.setUp2()
            case 3: scene.setUp3()
            default:
                scene.title.text = "This scene has not been implemented yet"
            }
            
        }
        
        
        return scene
    }
}

typealias GenericDictionary = [String: AnyObject]

struct Config {
    let isDebug : Bool
    let scenes : [SceneDescription]
        
    static func sharedConfig() -> Config! {
        let configDict = plistDictionary()
        let isDebug = configDict["isDebug"]!.boolValue!
        let scenesR = configDict["scenes"] as! [[String : String]]
        let scenes = scenesR.map({ (dictionary) -> SceneDescription in
            let title = dictionary["title"]!
            let codeString = dictionary["code"]!
            let codeAttributed = NSAttributedString(htmlString: codeString)
            return SceneDescription(title: title, code: codeAttributed!)
        })
        
        return Config(isDebug: isDebug, scenes: scenes)
    }
    
    private static func plistDictionary() -> NSDictionary {
        var myDict: NSDictionary?
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }
}

extension NSAttributedString {
    convenience init?(htmlString: String) {
        let data = htmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var error : NSError?
        self.init(data: data!, options: nil, documentAttributes: nil, error: &error)
    }
}

struct SceneDescription {
    let title : String
    let code : NSAttributedString
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