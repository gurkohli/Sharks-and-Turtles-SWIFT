//
//  MainMenuViewController.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-11.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import UIKit
import SpriteKit

@available(iOS 9.0, *)
class MainMenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scene = MainMenu(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        //scene.viewController = self;
        
        skView.presentScene(scene)

    }
    
    override func viewDidDisappear(animated: Bool) {
        let skView = self.view as! SKView
        skView.presentScene(nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
