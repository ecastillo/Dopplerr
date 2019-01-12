//
//  WantedViewController.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/31/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import SwiftSonarr
import Tabman
import Pageboy

class WantedViewController: TabmanViewController {
    
    private var viewControllers = [UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "missing"),
                                   UIViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.ButtonBar()
        //bar.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}

extension WantedViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let barItems = [TMBarItem(title: "Missing"),
                        TMBarItem(title: "Cutoff Unmet")]
        return barItems[index]
    }
}
