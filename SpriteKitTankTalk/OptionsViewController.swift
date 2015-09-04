//
//  OptionsViewController.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit


class OptionsViewController : UITableViewController {
    
    var didSelectIndex : ((index: Int)->())?
    var currentIndex : Int? {
        didSet {
            if let currentIndex = currentIndex {
                if (currentIndex - 1) < self.titles.count {
                    self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: (currentIndex - 1), inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
                }
            }
        }
    }
    
    let titles = Config.sharedConfig().scenes.map({ (scene: SceneDescription) in
        return scene.title
    })
    
    var options : [(title: String, value: Bool)] {
        let config = Config.sharedConfig()
        var options = [(title: String, value: Bool)]()
        options.append(("Debug", config.isDebug))
        options.append(("Speak", config.speakText))
        
        return options
    }
    
    func switchOptionAtIndex(index: Int) {
        var config = Config.sharedConfig()
        
        switch index {
        case 0:
            config.isDebug = !config.isDebug
        default:
            config.speakText = !config.speakText
        }
    }
    
    static func fromNavigationBarButton(button: UIBarButtonItem) -> UINavigationController {
        let optionsVC = OptionsViewController(style: UITableViewStyle.Grouped)
        let navController = UINavigationController(rootViewController: optionsVC)
        
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        navController.popoverPresentationController!.barButtonItem = button
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: optionsVC, action: "dismiss")
        optionsVC.navigationItem.rightBarButtonItem = closeBtn
        
        return navController
    }
    

    
    override func loadView() {
        super.loadView()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "sceneCell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? titles.count : 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Select Level" : "Change Options"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sceneCell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = self.titles[indexPath.row]
        default:
            let option = self.options[indexPath.row]
            cell.textLabel!.text = "\(option.title): \(option.value)"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if let didSelectIndex = didSelectIndex {
                didSelectIndex(index: (indexPath.row + 1))
            }            
            dismiss()
        }
        else {
            switchOptionAtIndex(indexPath.row)
            self.tableView.reloadData()
            // change options
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension  UINavigationController {
    func optionsViewController() -> OptionsViewController? {
        return self.viewControllers.first as? OptionsViewController
    }
}