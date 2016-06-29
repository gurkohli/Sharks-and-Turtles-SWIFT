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
class GameMenuController: UIViewController {
    
    override func viewDidLoad() {
        
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
        if segue.identifier == "onePlayerMainGame" {
            if let destinationVC = segue.destinationViewController as? MainGameController {
                destinationVC.isSinglePlayer = true
                destinationVC.gameMenuController = self
            }
        } else if segue.identifier == "twoPlayerMainGame" {
            if let destinationVC = segue.destinationViewController as? MainGameController {
                destinationVC.isSinglePlayer = false
                destinationVC.gameMenuController = self
            }
        }
        
    }
}
