		//
//  MainGame.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2014-11-15.
//  Copyright (c) 2014 Gur Kohli. All rights reserved.
//

import SpriteKit
import GameplayKit

@available(iOS 9.0, *)
class MainGame: SKScene {

    var bg: Background
    var fg: Foreground
    
    var player1: Player
    var player2: Player
    var isPlayer2Turn: Bool
    var isPlayer2Computer = false
    
    var dice: Dice
    var sharks: [Shark]
    var turtles: [Turtle]
    var tileArray: [Foreground.Tile]
    
    var sharkHandlerNode: SKSpriteNode
    var turtleHandlerNode: SKSpriteNode
    var playerHandlerNode: SKSpriteNode
    
    struct sharkTurtleData {
        var count: Int
        var beginTiles: [Int]
        var endTiles: [Int]
    }
    let SHARK_DATA = sharkTurtleData(count: 7, beginTiles: [17,52,57,63,88,95,98],endTiles: [13,29,40,22,18,73,4])
    let TURTLE_DATA = sharkTurtleData(count: 7, beginTiles: [3,8,28,58,75,80,90], endTiles: [21,30,84,77,86,100,91])
    
    override init(size: CGSize) {
        let frameSize = size
        let tileSize = CGSizeMake(frameSize.width/10 - 2, frameSize.height/10 - 2);
        let playerSize = CGSizeMake(tileSize.width/2, tileSize.height/2)
        //TODO Add Dice Size when Adding Dice Textures
        let diceSize = CGSizeMake(0, 0)
        
        let player1Position = CGPointMake(playerSize.width, playerSize.height/2)
        let player2Position = CGPointMake(playerSize.width, playerSize.height*3/2)
        let dicePosition = CGPointMake(size.width - 25, size.height-40)
        
        bg = Background(nodeSize: frameSize);
        fg = Foreground(nodeSize: frameSize);
        player1 = Player(nodeSize: playerSize, nodeColor: nil, nodePosition: player1Position);
        player2 = Player(nodeSize: playerSize, nodeColor: UIColor.whiteColor(), nodePosition: player2Position);
        isPlayer2Turn = false;
        sharks = [Shark]();
        turtles = [Turtle]();
        dice = Dice(nodeSize: diceSize, nodePosition: dicePosition)
        tileArray = [Foreground.Tile(size: frameSize, position: CGPointMake(0,0))]

        sharkHandlerNode = SKSpriteNode();
        turtleHandlerNode = SKSpriteNode();
        playerHandlerNode = SKSpriteNode()
        
        super.init(size: size)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        tileArray = fg.loadGrid()
        playerHandlerNode.addChild(player1)
        playerHandlerNode.addChild(player2)
        
        for var i=0; i < SHARK_DATA.count; i++ {
            let tile = tileArray[SHARK_DATA.beginTiles[i]]
            
            let sharkSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let sharkPosition = CGPointMake(tile.position.x + sharkSize.width, tile.position.y + sharkSize.height)
            
            sharks.append(Shark(nodeSize: sharkSize, nodePosition: sharkPosition))
            sharkHandlerNode.addChild(sharks[i])
        }
        
        for var i=0; i < TURTLE_DATA.count; i++ {
            let tile = tileArray[TURTLE_DATA.beginTiles[i]]
            
            let turtleSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let turtlePosition = CGPointMake(tile.position.x + tile.size.width/2, tile.position.y + turtleSize.height)
            
            turtles.append(Turtle(nodeSize: turtleSize, nodePosition:turtlePosition))
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
    
    func performPlayerAction(currentPlayer: Player, computer: Player?) -> Bool{
        let dieRoll = self.dice.rollDice()
        func checkSharksAndTurtles() {
            let currentTile = currentPlayer.getCurrentTile()
            func callback() {
                var delayTime = Int64(100)
                if (computer != nil) {
                    delayTime = Int64(1500)
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * Int64(NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                    self.userInteractionEnabled = true
                    if (computer != nil) {
                        self.userInteractionEnabled = false
                        self.performPlayerAction(computer!,computer: nil)
                    }
                })
            }
            if (self.isSharkOnTile(currentTile)) {
                currentPlayer.movePlayerToTile(self.getSharkDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: callback)
            } else if (self.isTurtleOnTile(currentTile)) {
                currentPlayer.movePlayerToTile(self.getTurtleDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: callback)
            } else {
                callback();
            }
            //self.userInteractionEnabled = true;
        }
        
        return currentPlayer.movePlayer(dieRoll, tileArray: tileArray, runAfterActionCompletion:checkSharksAndTurtles)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            self.userInteractionEnabled = false;
            var gameEnd = false;
            if (isPlayer2Computer) {
                gameEnd = performPlayerAction(player1, computer: player2)
            } else {
                if (!isPlayer2Turn) {
                    gameEnd = performPlayerAction(player1, computer: nil)
                    isPlayer2Turn = true
                } else {
                    gameEnd = performPlayerAction(player2, computer: nil)
                    isPlayer2Turn = false
                }
            }
            if (gameEnd) {
                //Do Stuff
                self.removeAllChildren()
                //self.view?.presentScene(scene)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
