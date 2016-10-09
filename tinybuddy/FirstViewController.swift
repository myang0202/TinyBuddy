//
//  FirstViewController.swift
//  tinybuddy
//
//  Created by Matthew Yang on 10/8/16.
//  Copyright © 2016 Matthew Yang. All rights reserved.
//

import UIKit
//import GoogleMaps

class FirstViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    func timeToMoveOn() {
        self.performSegueWithIdentifier("goToMainUI", sender: self)
    }
}