//
//  ViewController.swift
//  tinybuddy
//
//  Created by Matthew Yang on 10/8/16.
//  Copyright © 2016 Matthew Yang. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.center = view.center
        print("asdasd")

    }
    override func viewDidAppear(animated: Bool) {
        if let loggedin = FBSDKAccessToken.currentAccessToken(){
            performSegueWithIdentifier("toMap", sender: loginButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("logged in!")
        performSegueWithIdentifier("toMap", sender: loginButton)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    
//    func viewDidLoad() {
//        let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
//    }

}

