		//
//  GameScene.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2014-11-15.
//  Copyright (c) 2014 Gur Kohli. All rights reserved.
//

import SpriteKit
import GameplayKit

@available(iOS 9.0, *)
class GameScene: SKScene {

    var bg: Background
    var fg: Foreground
    var player: Player
    var dice: Dice
    var tileArray = [SKSpriteNode]()
    
    override init(size: CGSize) {
        self.bg = Background(size: size);
        self.player = Player(size: size);
        self.fg = Foreground(size: size)
        self.dice = Dice(size: size)
        
        super.init(size: size)
        
        self.addChild(self.bg)
        self.addChild(self.fg)
        self.addChild(self.player)
        self.addChild(self.dice)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //dispatch_async(queue, loadBackground);
        //let backgroundThread = NSThread(target: self, selector: "loadBackground", object: nil);
        //backgroundThread.start();
        bg.loadBackground()
        tileArray = fg.loadGrid()
        player.loadPlayer();
        dice.loadDice();
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let dieRoll = dice.rollDice()
            player.movePlayer(dieRoll, tileArray: tileArray)
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
             ///   self.movePlayer();
            //})
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
