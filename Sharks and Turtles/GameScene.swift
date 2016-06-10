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
    var player1: Player
    var dice: Dice
    var sharks: [Shark]
    var turtles: [Turtle]
    var tileArray: [Foreground.Tile]
    
    var sharkHandlerNode: SKSpriteNode
    var turtleHandlerNode: SKSpriteNode
    var backgroundForegroundHandlerNode: SKSpriteNode
    var playerHandlerNode: SKSpriteNode
    
    struct sharkTurtleData {
        var count: Int
        var beginTiles: [Int]
        var endTiles: [Int]
    }
    let SHARK_DATA = sharkTurtleData(count: 7, beginTiles: [17,52,57,63,88,95,98],endTiles: [13,29,40,22,18,73,3])
    let TURTLE_DATA = sharkTurtleData(count: 7, beginTiles: [3,8,28,58,75,80,90], endTiles: [21,30,84,77,86,100,91])
    
    override init(size: CGSize) {
        bg = Background(size: size);
        fg = Foreground(size: size)
        player1 = Player(framesize: size);
        sharks = [Shark]();
        turtles = [Turtle]();
        dice = Dice(size: size)
        tileArray = [Foreground.Tile(size: size, position: CGPointMake(0,0))]
        sharkHandlerNode = SKSpriteNode();
        turtleHandlerNode = SKSpriteNode();
        backgroundForegroundHandlerNode = SKSpriteNode()
        playerHandlerNode = SKSpriteNode()
        
        super.init(size: size)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        tileArray = fg.loadGrid()
        //backgroundForegroundHandlerNode.addChild(bg)
        //backgroundForegroundHandlerNode.addChild(fg)
        playerHandlerNode.addChild(player1)
        
        for var i=0; i < SHARK_DATA.count; i++ {
            let tile = tileArray[SHARK_DATA.beginTiles[i]]
            sharks.append(Shark(size: size, point: CGPointMake(tile.position.x + tile.size.width/4, tile.position.y + tile.size.height/4)))
            sharkHandlerNode.addChild(sharks[i])
        }
        
        for var i=0; i < TURTLE_DATA.count; i++ {
            let tile = tileArray[TURTLE_DATA.beginTiles[i]]
            turtles.append(Turtle(size: size, point: CGPointMake(tile.position.x + tile.size.width/4, tile.position.y + tile.size.height/4)))
            turtleHandlerNode.addChild(turtles[i])
        }
        
        addChild(bg)
        addChild(playerHandlerNode)
        addChild(dice)
        addChild(sharkHandlerNode)
        addChild(turtleHandlerNode)
    }
    
    func isSharkOnTile(currentTile: Int) -> Bool{
        if SHARK_DATA.beginTiles.contains(currentTile) {
            return true;
        }
        return false;
    }
    
    func isTurtleOnTile(currentTile: Int) -> Bool{
        if TURTLE_DATA.beginTiles.contains(currentTile) {
            return true;
        }
        return false;
    }
    
    func getSharkDestinationTile(sourceTile: Int) -> Int {
        if (isSharkOnTile(sourceTile)) {
            let index = SHARK_DATA.beginTiles.indexOf(sourceTile);
            return SHARK_DATA.endTiles[index!]
        }
        return -1
    }
    
    func getTurtleDestinationTile(sourceTile: Int) -> Int {
        if (isTurtleOnTile(sourceTile)) {
            let index = TURTLE_DATA.beginTiles.indexOf(sourceTile);
            return TURTLE_DATA.endTiles[index!]
        }
        return -1
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            self.userInteractionEnabled = false;
            let dieRoll = self.dice.rollDice()
            func checkShark() {
                let currentTile = self.player1.getCurrentTile()
                func enableTouch() {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * Int64(NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                        self.userInteractionEnabled = true
                    })
                }
                if (self.isSharkOnTile(currentTile)) {
                    self.player1.movePlayerToTile(self.getSharkDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: enableTouch)
                } else if (self.isTurtleOnTile(currentTile)) {
                    self.player1.movePlayerToTile(self.getTurtleDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: enableTouch)
                } else {
                    enableTouch();
                }
                //self.userInteractionEnabled = true;
            }
        
            player1.movePlayer(dieRoll, tileArray: tileArray, runAfterActionCompletion:checkShark)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
