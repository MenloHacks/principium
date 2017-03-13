//
//  MEHProfileDisplayPageViewController.swift
//  Principium
//
//  Created by Jason Scharff on 3/12/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

import Foundation
import UIKit
import PageMenu



@objc class MEHProfileDisplaPageViewController : UIViewController {
    
    var user : MEHUser? {
        didSet {
            liabilityVC.url = user?.liabilityURL
            photoVC.url = user?.photoFormURL
            infoVC.user = user
        }
    }
    
    private let liabilityVC = MEHFormViewController()
    private let photoVC = MEHFormViewController()
    private let infoVC = MEHUserViewController()

    
    override func viewDidLoad(){
        
        liabilityVC.title = "Liability"
        photoVC.title = "Photo"
        infoVC.title = "Profile"
        
        let controllers = [infoVC, liabilityVC, photoVC]
        
        // Initialize page menu with controller array, frame, and optional parameters
        
        let pageMenuParameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
            .bottomMenuHairlineColor(UIColor.menloHacksPurple()),
            .selectionIndicatorColor(UIColor.menloHacksPurple()),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.menloHacksPurple()),
            .unselectedMenuItemLabelColor(UIColor.menloHacksGray()),
            .menuItemFont(UIFont(name: "Avenir", size: 16.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        let pageMenu = CAPSPageMenu(viewControllers: controllers,
                                    frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),
                                    pageMenuOptions: pageMenuParameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu.view)
        self.addChildViewController(pageMenu)
        
        self.navigationItem.hidesBackButton = true
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(MEHProfileDisplaPageViewController.returnToRoot(sender:)))
        self.navigationItem.rightBarButtonItem = nextButton
        
        
    }
    
    func returnToRoot(sender: AnyObject) {
        let transition = CATransition.flip()
        self.navigationController?.view.layer.add(transition!, forKey: kCATransition)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
