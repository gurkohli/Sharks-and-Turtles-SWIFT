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
    weak var viewController = MainGameController()
    
    var bg: Background
    var fg: Foreground
    var gameMasterNode: SKSpriteNode
    var pauseMenu: PauseMenu
    var birdEyeCam: SKCameraNode!
    
    var player1: Player
    var player2: Player
    var isPlayer2Turn: Bool
    var isPlayer2Computer = false
    var curPlayer = Player()
    var isGamePaused = false
    
    var dice: Dice
    var pauseButton: SKSpriteNode
    var sharks: [Shark]
    var turtles: [Turtle]
    var tileArray: [Foreground.Tile]
    var labelArray: [SKLabelNode]
    
    var sharkHandlerNode: SKSpriteNode
    var turtleHandlerNode: SKSpriteNode
    var playerHandlerNode: SKSpriteNode
    
    struct sharkTurtleData {
        var count: Int
        var beginTiles: [Int]
        var endTiles: [Int]
    }
    let SHARK_DATA = sharkTurtleData(count: 7, beginTiles: [17,52,57,63,88,95,98],endTiles: [13,29,40,22,18,73,4])
    let TURTLE_DATA = sharkTurtleData(count: 7, beginTiles: [3,8,28,58,75,80,90], endTiles: [21,30,84,77,86,99,91])
    
    override init(size: CGSize) {
        let frameSize = size
        let fgSize = CGSizeMake(frameSize.width/2, frameSize.height/2)
        let tileSize = CGSizeMake(fgSize.width/10 - 2, fgSize.height/10 - 2);
        let playerSize = CGSizeMake(tileSize.width/2, tileSize.height/2)
        let pauseMenuSize = CGSizeMake(fgSize.width/1.5, fgSize.height/2)
        //TODO Add Dice Size when Adding Dice Textures
        let diceSize = CGSizeMake(0, 0)
        
        let player1Position = CGPointMake(playerSize.width, playerSize.height/2)
        let player2Position = CGPointMake(playerSize.width, playerSize.height*3/2)
        let dicePosition = CGPointMake(fgSize.width - 25, fgSize.height-40)
        
        gameMasterNode = SKSpriteNode(color: UIColor.clearColor(), size: fgSize)
        bg = Background(nodeSize: frameSize);
        fg = Foreground(nodeSize: fgSize);
        pauseMenu = PauseMenu(nodeSize: pauseMenuSize);
        
        birdEyeCam = SKCameraNode()
        player1 = Player(nodeSize: playerSize, nodeColor: nil, nodePosition: player1Position);
        player2 = Player(nodeSize: playerSize, nodeColor: UIColor.whiteColor(), nodePosition: player2Position);
        isPlayer2Turn = false;
        sharks = [Shark]();
        turtles = [Turtle]();
        dice = Dice(nodeSize: diceSize, nodePosition: dicePosition)
        
        pauseButton = SKSpriteNode(color: UIColor.brownColor(), size: CGSizeMake(30, 30))
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPointMake(dicePosition.x - 20, dicePosition.y)
        pauseButton.zPosition = 50
        tileArray = [Foreground.Tile(size: tileSize, position: CGPointMake(0,0))]
        labelArray = [SKLabelNode]()

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
        labelArray.append(SKLabelNode())
        /*for var i=1; i < tileArray.count; i++ {
            let label = SKLabelNode(fontNamed: "AmericanTypewriter")
            //label.text = "\(i)"
            label.position = CGPointMake(tileArray[i].position.x + tileArray[i].size.width - 4, tileArray[i].position.y)
            label.zPosition = 3.0
            label.fontSize = 5.0
            label.alpha = 0.4
            labelArray.append(label)
        }*/
        
        for var i=0; i < SHARK_DATA.count; i++ {
            let tile = tileArray[SHARK_DATA.beginTiles[i]]
            
            let sharkSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let sharkPosition = CGPointMake(tile.position.x + sharkSize.width, tile.position.y + sharkSize.height)
            
            sharks.append(Shark(nodeSize: sharkSize, nodePosition: sharkPosition))
            
            let path = CGPathCreateMutable()
            let endTile = tileArray[SHARK_DATA.endTiles[i]];
            
            let controlPoint1 = CGPointMake(tile.position.x + 5 , tile.position.y - 5)
            let controlPoint2 = CGPointMake(endTile.position.x + 5, endTile.position.y + 5)
            
            CGPathMoveToPoint(path, nil, tile.position.x + tile.size.width/2, tile.position.y + tile.size.height/2)
            //CGPathAddLineToPoint(path, nil,endTile.position.x + tile.size.width/2, endTile.position.y + tile.size.height/2)
            CGPathAddCurveToPoint(path, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endTile.position.x + tile.size.width/2, endTile.position.y + tile.size.height/2)
            let dashedPath = CGPathCreateCopyByDashingPath(path, nil, 0, [5.0,10.0], 2)
            let shape = SKShapeNode(path: dashedPath!)
            shape.strokeColor = UIColor.redColor()
            //shape.alpha = 0.4
            
            let shapeWrapper = SKEffectNode()
            shapeWrapper.addChild(shape)
            shapeWrapper.zPosition = 3.0
            shapeWrapper.shouldRasterize = true;
            shapeWrapper.alpha = 0.4
            
            sharkHandlerNode.addChild(shapeWrapper)
            sharkHandlerNode.addChild(sharks[i])
        }
        
        for var i=0; i < TURTLE_DATA.count; i++ {
            let tile = tileArray[TURTLE_DATA.beginTiles[i]]
            
            let turtleSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let turtlePosition = CGPointMake(tile.position.x + tile.size.width/2, tile.position.y + turtleSize.height)
            
            turtles.append(Turtle(nodeSize: turtleSize, nodePosition:turtlePosition))
            
            let path = CGPathCreateMutable()
            let endTile = tileArray[TURTLE_DATA.endTiles[i]];
            
            let controlPoint1 = CGPointMake(tile.position.x + 20, tile.position.y + 20)
            let controlPoint2 = CGPointMake(endTile.position.x - 10, endTile.position.y - 20)
            
            CGPathMoveToPoint(path, nil, tile.position.x + tile.size.width/2, tile.position.y + tile.size.height/2)
            //CGPathAddLineToPoint(path, nil,endTile.position.x + tile.size.width/2, endTile.position.y + tile.size.height/2)
            CGPathAddCurveToPoint(path, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endTile.position.x + tile.size.width/2, endTile.position.y + tile.size.height/2)
            
            let dashedPath = CGPathCreateCopyByDashingPath(path, nil, 0, [5.0,10.0], 2)
            let shape = SKShapeNode(path: dashedPath!)
            shape.strokeColor = UIColor.greenColor()
            //shape.alpha = 0.4
            let shapeWrapper = SKEffectNode()
            shapeWrapper.addChild(shape)
            shapeWrapper.zPosition = 3.0
            shapeWrapper.shouldRasterize = true;
            shapeWrapper.alpha = 0.4
            
            turtleHandlerNode.addChild(shapeWrapper)
            turtleHandlerNode.addChild(turtles[i])
        }
        //anchorPoint = CGPointMake(0.5,0.5)

        
        birdEyeCam.position = CGPointMake(size.width/2, size.height/2)

        birdEyeCam.setScale(0.5)
        birdEyeCam.name = "camera"

        self.camera = birdEyeCam
        
        //fg.position = CGPointMake(size.width/4, size.height/4)
        
        pauseMenu.position = CGPointMake(size.width/2, size.height/2)
        
        camera?.addChild(dice)
        camera?.addChild(pauseButton)
        
        gameMasterNode.name = "gameMasterNode"
        gameMasterNode.position = CGPointMake(size.width/4, size.height/4)
        gameMasterNode.anchorPoint = CGPointMake(0, 0)
        
        gameMasterNode.addChild(fg)
        gameMasterNode.addChild(playerHandlerNode)
        gameMasterNode.addChild(sharkHandlerNode)
        gameMasterNode.addChild(turtleHandlerNode)
        
        addChild(birdEyeCam)
        addChild(bg)
        addChild(gameMasterNode)
    }
    
    func loadSharkTurtlePath() {
        
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
            curPlayer = currentPlayer;
            let currentTile = currentPlayer.getCurrentTile()
            func callback() {
                let delayTime = Int64(100)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * Int64(NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                    self.userInteractionEnabled = true
                    if (computer != nil) {
                        self.userInteractionEnabled = false
                        self.performPlayerAction(computer!,computer: nil)
                    }
                    self.isPlayer2Turn = !self.isPlayer2Turn
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
    
    func restartGame() {
        let mainGame:MainGame = MainGame(size: self.view!.bounds.size)
        let transition = SKTransition.crossFadeWithDuration(0.5)
        mainGame.scaleMode = SKSceneScaleMode.Fill
        mainGame.isPlayer2Computer = self.isPlayer2Computer
        mainGame.viewController = self.viewController
        self.removeAllChildren()
        self.removeAllActions()
        self.scene?.removeFromParent()
        self.view!.presentScene(mainGame, transition: transition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
    
            let viewTouchLocation = touch.locationInView(self.view)
            let sceneTouchPoint = self.convertPointFromView(viewTouchLocation)
            let touchedNode = self.nodeAtPoint(sceneTouchPoint)
            print(touchedNode.name)
            if (!isGamePaused && touchedNode.name == pauseButton.name) {
                gameMasterNode.paused = true;
                gameMasterNode.alpha = 0.4
                pauseMenu.setScale(0)
                addChild(pauseMenu)
                let expand = SKAction.scaleTo(1.2, duration: 0.2)
                let bringBack = SKAction.scaleTo(1, duration: 0.1)
                pauseMenu.runAction(SKAction.sequence([expand, bringBack]), completion: {self.isGamePaused = true});
            } else if (isGamePaused) {
                if (CGRectContainsPoint(gameMasterNode.frame, sceneTouchPoint) && !CGRectContainsPoint(pauseMenu.frame, sceneTouchPoint) || touchedNode.name == pauseMenu.RESUME_BUTTON_NODE_NAME) {
                    let expand = SKAction.scaleTo(1.2, duration: 0.1)
                    let bringBack = SKAction.scaleTo(0, duration: 0.2)
                    pauseMenu.runAction(SKAction.sequence([expand, bringBack]), completion: {
                        self.pauseMenu.removeFromParent()
                        self.gameMasterNode.alpha = 1
                        self.gameMasterNode.paused = false
                        self.isGamePaused = false;
                    });
                }
                
                else if (touchedNode.name == pauseMenu.RESTART_BUTTON_NODE_NAME) {
                    restartGame()
                }
                
                else if (touchedNode.name == pauseMenu.END_GAME_BUTTON_NODE_NAME) {
                    //self.viewController!.performSegueWithIdentifier("endGame", sender: nil)
                    self.viewController?.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } else {
                self.userInteractionEnabled = false;
                var gameEnd = false;
                if (isPlayer2Computer) {
                    gameEnd = performPlayerAction(player1, computer: player2)
                } else {
                    if (!isPlayer2Turn) {
                        gameEnd = performPlayerAction(player1, computer: nil)
                    } else {
                        gameEnd = performPlayerAction(player2, computer: nil)
                    }
                }
                if (gameEnd) {
                    //Do Stuff
                    restartGame()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    deinit {
        self.scene?.removeFromParent()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
}
