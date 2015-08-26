//
//  GameSceneGenerator.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 26/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation
import SpriteKit


struct GameSceneGenerator {
    static func fromIndex(index: Int) -> GameScene? {
        let config = Config.sharedConfig()
        
        if config.levels.count < index {
            return nil
        }
        let level = config.levels[index]
        
        let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        
        scene!.prepareScene = {(view: SKView) in
            
            for node in level.nodes {
                
                var sceneNode : SKNode
                
                if node.type == NodeType.String {
                    let labelNode = SKLabelNode(fontNamed:"Sanfrancisco")
                    labelNode.text = node.value;
                    labelNode.fontSize = 40;
                    sceneNode = labelNode
                }
                else {
                    let imageNode = SKSpriteNode(imageNamed: node.value)
                    sceneNode = imageNode
                }
                
                if let startPosition = node.startPosition {
                    sceneNode.position = startPosition;
                }
                else {
                    sceneNode.position = scene!.view!.center
                }
                
                
                if let endPosition = node.endPosition {
                    let moveAction = SKAction.moveTo(endPosition, duration: 5.0)
                    sceneNode.runAction(moveAction)
                }
                
                scene!.addChild(sceneNode)
                
            }
            
        }

        return scene
    }
}


typealias GenericDictionary = [String: AnyObject]

struct Config {
    let isDebug : Bool
    let levels : [Level]
    
    static func sharedConfig() -> Config! {
        let configDict = plistDictionary()
        let isDebug = configDict["isDebug"]!.boolValue!
        
        let levelsRaw = configDict["levels"] as! [GenericDictionary]
        let levels = levelsRaw.map({Level.fromDictionary($0)})
        
        return Config(isDebug: isDebug, levels: levels)
    }
    
    private static func plistDictionary() -> NSDictionary {
        var myDict: NSDictionary?
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }
}

struct Level {
    let nodes : [Node]
    
    static func fromDictionary(dictionary: GenericDictionary) -> Level {
        let nodesRaw = dictionary["nodes"] as! [GenericDictionary]
        let nodes = nodesRaw.map({Node.fromDictionary($0)})
        return Level(nodes: nodes)
    }
}

struct Node {
    let startPosition : CGPoint?
    let endPosition : CGPoint?
    let type: NodeType
    let value: String
    
    static func fromDictionary(dictionary: GenericDictionary) -> Node {
        let startPosition = positionFromString(dictionary["startPosition"] as? String)
        let endPosition = positionFromString(dictionary["endPosition"] as? String)
        
        let typeRaw = dictionary["type"] as! String
        let type = (typeRaw == "string") ? NodeType.String : NodeType.Image
        
        let value = dictionary["value"] as! String
        
        return Node(startPosition: startPosition, endPosition: endPosition, type: type, value: value)
    }
    
    static func positionFromString(stringPosition: String?) -> CGPoint? {
        
        
        let windowSize = UIScreen.mainScreen().bounds.size
        
        if let stringPosition = stringPosition {
            var position : CGPoint
            switch stringPosition {
            case "random_out" :
                position = LocationGenerator(sceneSize: windowSize, outSpan: 40).randomLocation()
            case "center" :
                position = CGPoint(x: windowSize.width / 2.0, y: windowSize.height / 2.0)
            default:
                let componentsStrings = split(stringPosition, maxSplit: Int.max, allowEmptySlices: false, isSeparator: { $0 == "|" } )
                let components = componentsStrings.map({ Int(($0 as NSString).intValue) })
                
                position = CGPoint(x: components[0], y: components[1])
            }
            
            return position
        }
        
        
        return nil
    }
}

enum NodeType {
    case String, Image
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