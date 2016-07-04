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
    
    let events = EventManager()
    let GAME_OVER_EVENT = "gameOver"
    
    var bg: Background
    var fg: Foreground
    var pauseMenu: PauseMenu
    var gameOverMenu: GameOverMenu
    var dice: Dice
    
    var player1: Player
    var player2: Player
    var curPlayer = Player()
    
    var isPlayer2Turn = false
    var isPlayer2Computer = false
    var isGamePaused = false
    var isGameOver = false

    var hudNode: SKSpriteNode
    var pauseButton: SKSpriteNode
    var curPlayerLabel: SKLabelNode
    
    var sharks = [Shark]()
    var turtles = [Turtle]()
    var tileArray: [Foreground.Tile]
    
    var gameMasterNode = SKNode()
    var sharkContainerNode = SKNode()
    var turtleContainerNode = SKNode()
    var playerContainerNode = SKNode()
    
    struct sharkTurtleData {
        var count: Int
        var beginTiles: [Int]
        var endTiles: [Int]
    }
    let SHARK_DATA = sharkTurtleData(count: 7, beginTiles: [17,52,57,63,88,95,98],endTiles: [13,29,40,22,18,73,4])
    let TURTLE_DATA = sharkTurtleData(count: 7, beginTiles: [3,8,28,58,75,80,90], endTiles: [21,30,84,77,86,99,91])
    
    override init(size: CGSize) {
        // Declaring size  and position constants
        
        let frameSize = size
        let hudSize = CGSizeMake(frameSize.width, frameSize.height/12)
        let fgSize = CGSizeMake(frameSize.width, frameSize.height - hudSize.height)
        let tileSize = CGSizeMake(fgSize.width/10 - 2, fgSize.height/10 - 2);
        let playerSize = CGSizeMake(tileSize.width/2, tileSize.height/2)
        let popupMenuSize = CGSizeMake(fgSize.width/1.5, fgSize.height/2)
        let diceSize = CGSizeMake(0, 0) //TODO Add Dice Size when Adding Dice Textures
        
        let dicePosition = CGPointMake(fgSize.width - 25, fgSize.height-40)
        let player1Position = CGPointMake(playerSize.width, playerSize.height/2)
        let player2Position = CGPointMake(playerSize.width, playerSize.height*3/2)

        // Initializing global variables
        isPlayer2Turn = false;

        fg = Foreground(nodeSize: fgSize);
        bg = Background(nodeSize: frameSize);
        pauseMenu = PauseMenu(nodeSize: popupMenuSize);
        gameOverMenu = GameOverMenu(nodeSize: popupMenuSize)
        dice = Dice(nodeSize: diceSize, nodePosition: dicePosition)

        player1 = Player(nodeSize: playerSize, nodeColor: nil, nodePosition: player1Position);
        player1.name = "player1"
        player2 = Player(nodeSize: playerSize, nodeColor: UIColor.whiteColor(), nodePosition: player2Position);
        player2.name = "player2"

        tileArray = [Foreground.Tile(size: tileSize, position: CGPointMake(0,0))]

        hudNode = SKSpriteNode(color: UIColor.clearColor(), size: hudSize)
        curPlayerLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        pauseButton = SKSpriteNode(color: UIColor.brownColor(), size: CGSizeMake(50, 50))

        // Init superclass
        super.init(size: size)

        // Configure and add sprites
        tileArray = fg.loadGrid()

        pauseMenu.position = CGPointMake(size.width/2, size.height/2)
        gameOverMenu.position = pauseMenu.position

        initHUD()
        initGameMasterNode()
        initSharksAndTurtles()
        setZPositions()

        playerContainerNode.name = "playerContainerNode"
        playerContainerNode.addChild(player1)
        playerContainerNode.addChild(player2)

        gameMasterNode.addChild(dice)
        gameMasterNode.addChild(fg)
        gameMasterNode.addChild(sharkContainerNode)
        gameMasterNode.addChild(turtleContainerNode)
        gameMasterNode.addChild(playerContainerNode)

        self.name = "frame"
        self.addChild(bg)
        self.addChild(hudNode)
        self.addChild(gameMasterNode)

        events.listenTo(GAME_OVER_EVENT, action: self.gameOver)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

    }
    
    func setZPositions() {
        bg.zPosition = -10
        
        fg.zPosition = -5
        
        sharkContainerNode.zPosition = -2
        turtleContainerNode.zPosition = -2
        playerContainerNode.zPosition = -2
        
        dice.zPosition = -1
        curPlayerLabel.zPosition = -1
        
        hudNode.zPosition = 0
        gameMasterNode.zPosition = 0
        
        pauseButton.zPosition = 10
        
        pauseMenu.zPosition = 100
        gameOverMenu.zPosition = 100
    }
    
    func initGameMasterNode() {
        gameMasterNode.name = "gameMasterNode"
    }
    
    func initHUD() {
        hudNode.name = "hudNode"
        hudNode.position = CGPointMake(0, fg.size.height)
        hudNode.anchorPoint = CGPointZero
        //hudNode.alpha = 0.4
        
        curPlayerLabel.name = "curPlayerLabel"
        curPlayerLabel.verticalAlignmentMode = .Center
        curPlayerLabel.horizontalAlignmentMode = .Left
        curPlayerLabel.position = CGPointMake(10, hudNode.size.height/2)
        curPlayerLabel.fontSize = 30
        curPlayerLabel.text = "Player 1"
        
        pauseButton.name = "pauseButton"
        pauseButton.anchorPoint = CGPointMake(1, 0.5)
        pauseButton.position = CGPointMake(hudNode.size.width - 5, hudNode.size.height/2)
        
        hudNode.addChild(pauseButton)
        hudNode.addChild(curPlayerLabel)
    }
    
    func initSharksAndTurtles() {
        
        sharkContainerNode.name = "sharkContainerNode"
        turtleContainerNode.name = "turtleContainerNode"
        
        func addRasterizedPath(tile: Foreground.Tile, endTile: Foreground.Tile) -> SKEffectNode {

            let path = CGPathCreateMutable()
            let controlPoint1 = CGPointMake(tile.position.x + 20, tile.position.y + 20)
            let controlPoint2 = CGPointMake(endTile.position.x - 10, endTile.position.y - 20)

            CGPathMoveToPoint(path, nil, tile.position.x + tile.size.width/2, tile.position.y + tile.size.height/2)
            CGPathAddCurveToPoint(path, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endTile.position.x + tile.size.width/2, endTile.position.y + tile.size.height/2)

            let dashedPath = CGPathCreateCopyByDashingPath(path, nil, 0, [5.0,10.0], 2)
            let shape = SKShapeNode(path: dashedPath!)
            shape.strokeColor = UIColor.greenColor()

            let shapeWrapper = SKEffectNode()
            shapeWrapper.userInteractionEnabled = false
            shapeWrapper.name = "sharkTurtleDashedLine"
            shapeWrapper.addChild(shape)
            shapeWrapper.zPosition = -2
            shapeWrapper.shouldRasterize = true;
            shapeWrapper.alpha = 0.4

            return shapeWrapper
        }
        
        for var i=0; i < SHARK_DATA.count; i++ {
            let tile = tileArray[SHARK_DATA.beginTiles[i]]

            let sharkSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let sharkPosition = CGPointMake(tile.position.x + sharkSize.width, tile.position.y + sharkSize.height)

            let shark = Shark(nodeSize: sharkSize, nodePosition: sharkPosition)
            shark.name = "Shark \(i+1)"
            sharks.append(shark)

            sharkContainerNode.addChild(addRasterizedPath(tile, endTile: tileArray[SHARK_DATA.endTiles[i]]))
            sharkContainerNode.addChild(sharks[i])
        }

        for var i=0; i < TURTLE_DATA.count; i++ {
            let tile = tileArray[TURTLE_DATA.beginTiles[i]]
            
            let turtleSize = CGSizeMake(tile.size.width/4, tile.size.height/4)
            let turtlePosition = CGPointMake(tile.position.x + tile.size.width/2, tile.position.y + turtleSize.height)
            
            let turtle = Turtle(nodeSize: turtleSize, nodePosition:turtlePosition)
            turtle.name = "Turtle \(i+1)"
            turtles.append(turtle)
            
            turtleContainerNode.addChild(addRasterizedPath(tile, endTile: tileArray[TURTLE_DATA.endTiles[i]]))
            turtleContainerNode.addChild(turtles[i])
        }
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
    
    func performPlayerAction(currentPlayer: Player, computer: Player?) {
        let dieRoll = 1//self.dice.rollDice()
        func checkSharksAndTurtles() {
            curPlayer = currentPlayer;
            let currentTile = currentPlayer.getCurrentTile()
            func callback(){
                let delayTime = Int64(50)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * Int64(NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                    self.gameMasterNode.userInteractionEnabled = false // It says false but acts the opposite. Bug?
                    if (currentTile >= 100) {
                        self.events.trigger(self.GAME_OVER_EVENT)
                        return
                    }
                    if (computer != nil) {
                        self.gameMasterNode.userInteractionEnabled = true // It says false but acts the opposite. Bug?
                        self.performPlayerAction(computer!,computer: nil)
                    }
                    self.isPlayer2Turn = !self.isPlayer2Turn
                    self.curPlayerLabel.text = self.curPlayer == self.player1 ? "Player 2" : "Player 1"
                })
            }
            if (self.isSharkOnTile(currentTile)) {
                currentPlayer.movePlayerToTile(self.getSharkDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: callback)
                
            } else if (self.isTurtleOnTile(currentTile)) {
                currentPlayer.movePlayerToTile(self.getTurtleDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: callback)
            } else {
                callback();
            }
        }
        currentPlayer.movePlayer(dieRoll, tileArray: tileArray, runAfterActionCompletion:checkSharksAndTurtles)
    }
    
    func restartGame() {
        events.removeListeners(nil)
        
        let mainGame:MainGame = MainGame(size: self.view!.bounds.size)
        let transition = SKTransition.crossFadeWithDuration(0.5)
        mainGame.scaleMode = SKSceneScaleMode.Fill
        mainGame.isPlayer2Computer = self.isPlayer2Computer

        scene?.removeFromParent()
        view?.presentScene(mainGame, transition: transition)
    }
    
    func gameOver() {
        self.gameMasterNode.userInteractionEnabled = false; // It says false but acts the opposite. Bug?
        gameOverMenu.winningPlayerNode.text = (curPlayer == self.player1 ? "Player 1" : "Player 2") + " wins!";
        gameMasterNode.paused = true;
        gameMasterNode.alpha = 0.4
        gameOverMenu.setScale(0)
        self.addChild(gameOverMenu)
        let expand = SKAction.scaleTo(1.2, duration: 0.2)
        let bringBack = SKAction.scaleTo(1, duration: 0.1)
        gameOverMenu.runAction(SKAction.sequence([expand, bringBack]), completion: {self.isGameOver = true});
    }
    
    func pauseGame() {
        self.gameMasterNode.userInteractionEnabled = false  // It says false but acts the opposite. Bug?
        gameMasterNode.paused = true;
        gameMasterNode.alpha = 0.4
        pauseMenu.setScale(0)
        self.addChild(pauseMenu)
        let expand = SKAction.scaleTo(1.2, duration: 0.2)
        let bringBack = SKAction.scaleTo(1, duration: 0.1)
        pauseMenu.runAction(SKAction.sequence([expand, bringBack]), completion: {self.isGamePaused = true});
    }
    
    func pauseMenuHandler(touchedNode: SKNode, touchedPoint: CGPoint) {
        if (CGRectContainsPoint(self.frame, touchedPoint) && !CGRectContainsPoint(pauseMenu.frame, touchedPoint) || touchedNode.name == pauseMenu.RESUME_BUTTON_NODE_NAME) {
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
            endGame()
        }
    }
    
    func endGame() {
        events.removeListeners(nil)

        let scene = MainMenu(size: self.view!.bounds.size)
        let transition = SKTransition.moveInWithDirection(.Right, duration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    func gameOverMenuHandler(touchedNode: SKNode) {
        if (touchedNode.name == gameOverMenu.PLAY_AGAIN_BUTTON_NODE) {
            restartGame()
        } else if (touchedNode.name == gameOverMenu.EXIT_GAME_BUTTON_NODE) {
            endGame()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
    
            let viewTouchLocation = touch.locationInView(self.view)
            let sceneTouchPoint = self.convertPointFromView(viewTouchLocation)
            let touchedNode = self.nodeAtPoint(sceneTouchPoint)
            print(touchedNode.name)
            
            if (!isGamePaused && touchedNode.name == pauseButton.name) {
                pauseGame()
                
            } else if (isGamePaused) {
                pauseMenuHandler(touchedNode, touchedPoint: sceneTouchPoint)
                
            } else if (isGameOver) {
                gameOverMenuHandler(touchedNode)
                
            } else if (touchedNode.name == gameMasterNode.name) {
                gameMasterNode.userInteractionEnabled = true;
                if (isPlayer2Computer) {
                     performPlayerAction(player1, computer: player2)
                } else {
                    if (!isPlayer2Turn) {
                        performPlayerAction(player1, computer: nil)
                    } else {
                        performPlayerAction(player2, computer: nil)
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    deinit {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
}
