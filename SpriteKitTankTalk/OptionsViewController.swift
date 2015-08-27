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
    
    static func fromNavigationBarButton(button: UIBarButtonItem) -> UINavigationController {
        let optionsVC = OptionsViewController(style: UITableViewStyle.Grouped)
        let navController = UINavigationController(rootViewController: optionsVC)
        
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        navController.popoverPresentationController!.barButtonItem = button
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: optionsVC, action: "dismiss")
        optionsVC.navigationItem.rightBarButtonItem = closeBtn
        
        return navController
    }
    
    let titles = Config.sharedConfig().scenes.map({ (scene: SceneDescription) in
        return scene.title
    })
    
    override func loadView() {
        super.loadView()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Level"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = self.titles[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let didSelectIndex = didSelectIndex {
            didSelectIndex(index: (indexPath.row + 1))
        }
        dismiss()
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