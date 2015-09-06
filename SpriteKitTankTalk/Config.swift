//
//  Config.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation

typealias GenericDictionary = [String: AnyObject]

struct Config {
    var isDebug : Bool
    var speakText : Bool
    let fontName: String
    let scenes : [SceneDescription]
    
    private static var cachedSharedConfig : Config?
    static func sharedConfig() -> Config! {
        
        if let cachedSC = cachedSharedConfig {
            return cachedSC
        }
        
        let configDict = plistDictionary()
        let isDebug = configDict["isDebug"]!.boolValue!
        let speakText = configDict["speakText"]!.boolValue!
        let fontName = configDict["fontName"]! as! String
        
        var index = 0
        var stop = false
        var scenes = [SceneDescription]()
        
        while (!stop) {
            index++
            
            guard let path = NSBundle.mainBundle().pathForResource("source_\(index)", ofType: "html"),
                let scene = SceneDescription.fromCodePath(path) else {
                stop = true
                continue
            }
            
            scenes.append(scene)
        }
        
        self.cachedSharedConfig = Config(isDebug: isDebug, speakText: speakText, fontName: fontName, scenes: scenes)
        return self.cachedSharedConfig
    }
    
    private static func plistPath() -> String {
        return NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
    }
    
    private static func plistDictionary() -> NSDictionary {
        return NSDictionary(contentsOfFile: plistPath())!
    }
    
    private static func codeForIndex(index: Int) -> String {
        let path = NSBundle.mainBundle().pathForResource("source_\(index)", ofType: "html")!
        return try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    }
}

extension Config {
    func save() {
        let dictionary = Config.plistDictionary().mutableCopy() as! NSMutableDictionary
        dictionary.setValue(NSNumber(bool: self.isDebug), forKey: "isDebug")
        dictionary.setValue(NSNumber(bool: self.speakText), forKey: "speakText")
        
        let path = Config.plistPath()
        if dictionary.writeToFile(path, atomically: true) {
            Config.cachedSharedConfig = nil
        }
    }
}

struct SceneDescription {
    let title : String
    let codePath : String
    let code : [String]
    let actions : [String]
    
    var html : String? {
        return SceneDescription.fullHtmlFromPath(self.codePath)
    }
    
    static func fromCodePath(codePath: String) -> SceneDescription? {
        guard let html = htmlFromPath(codePath),
            let jsonDict = jsonConfigFromHTML(html)
            else {
            return nil
        }
        
        guard let codeS  = jsonDict["code"],
            let actionsS  = jsonDict["action"],
            let title = jsonDict["title"]
            else {
                return nil
        }
        let code = codeS.componentsSeparatedByString(".")
        let actions = actionsS.componentsSeparatedByString(".")
        
        return SceneDescription(title: title, codePath: codePath, code: code, actions: actions)

    }
    
    
    //MARK: JSON
    private static func jsonConfigFromHTML(html : String) -> [String: String]? {
        
        let regEx = try? NSRegularExpression(pattern: "<script type=\"json\">(.+)</script>", options: [.CaseInsensitive, .DotMatchesLineSeparators])
        let range = NSMakeRange(0, html.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let findings = regEx!.matchesInString(html, options: NSMatchingOptions.ReportCompletion, range: range)
        
        if let first = findings.first {
            let range = first.rangeAtIndex(1)
            let json = (html as NSString).substringWithRange(range)
            
            if let data = json.dataUsingEncoding(NSUTF8StringEncoding) {
                let jsonAnyObj = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                return  jsonAnyObj as? [String : String]
            }
        
        }

        
        return nil
    }
    

    //MARK: HTML
    
    private static func htmlFromPath(path : String) -> String? {
        return try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    }
    
    static func fullHtmlFromPath(path : String) -> String? {
        guard let codeHtml = htmlFromPath(path),
            let templates = htmlTemplates else {
                return nil
        }
        
        return "\(templates.pre)\n\(codeHtml)\n\(templates)"
    }

    
    static var htmlTemplates : (pre: String, post: String)? {
        guard let path = NSBundle.mainBundle().pathForResource("source_template", ofType: "html"),
        let template = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String else {
            return nil
        }
        
        let components = template.componentsSeparatedByString("{{SOURCE_CODE}}")
        return (components[0], components[1])
    }
}
