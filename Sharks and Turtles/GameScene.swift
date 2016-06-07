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
    
    var backgroundTexture = [SKTexture]()
    var bg: SKSpriteNode
    var tempNode: SKSpriteNode
    var tileArray = [SKSpriteNode]()
    var player: SKSpriteNode
    
    var dice: SKLabelNode
    var dicelogic = GKRandomDistribution.d6()
    
    override init(size: CGSize) {
        self.bg = SKSpriteNode()
        self.tempNode = SKSpriteNode()
        self.player = SKSpriteNode()
        self.dice = SKLabelNode(fontNamed: "Chalkduster")
        super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        loadBackground()
        loadGrid()
        loadPlayer()
        dice.text = "0"
        dice.position = CGPoint(x: frame.width - 25, y: frame.height-40)
        dice.color = UIColor.blackColor()
        dice.zPosition = 10.0
        addChild(dice)
    }
    
    func loadBackground() {
        bg = SKSpriteNode(imageNamed: "BG1")
        
        bg.name = "Background"
        bg.size = frame.size
        bg.anchorPoint = CGPointMake(0.0,0.0)
        bg.zPosition = 1.0
        
        
        let backgroundAtlas = SKTextureAtlas(named: "Background")
        for i in 7...11 {
            let textureName = "BG\(i)"
            let temp = backgroundAtlas.textureNamed(textureName)
            backgroundTexture.append(temp)
        }
        for i in 0...4 {
            let textureName = "BG\(11-i)"
            let temp = backgroundAtlas.textureNamed(textureName)
            backgroundTexture.append(temp)
        }
        bg.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(backgroundTexture, timePerFrame: 0.20)))
        
        bg.color = UIColor.blueColor()
        bg.colorBlendFactor = 0.3
        self.addChild(bg)
    }
    func loadGrid() {
        var nodeIndex = 0
        var columns = 0
        var rows = 0
        for var y=CGFloat(0) ; rows <= 9 ; y += frame.height/10  {
            for var x=CGFloat(0) ; columns <= 9 ; x += frame.width/10 {
                
                tempNode = SKSpriteNode()
                tileArray.append(tempNode)
                tileArray[nodeIndex].name = "Tile\(nodeIndex)"
                tileArray[nodeIndex].size.height = frame.height/10 - 1.0
                tileArray[nodeIndex].size.width = frame.width/10 - 1.0
                tileArray[nodeIndex].zPosition = 2.0
                tileArray[nodeIndex].anchorPoint = CGPointMake(0.0,0.0)
                tileArray[nodeIndex].position = CGPointMake(x , y)
                tileArray[nodeIndex].hidden = true
                
                self.addChild(tileArray[nodeIndex])
                nodeIndex++
                columns++;
            
            }
            y += frame.height/10
            rows++;
            for var x=CGFloat(frame.width - frame.width/10) ; columns >= 0 && x >= 0; x -= frame.width/10 {
                
                tempNode = SKSpriteNode()
                tileArray.append(tempNode)
                tileArray[nodeIndex].name = "Tile\(nodeIndex)"
                tileArray[nodeIndex].size.height = frame.height/10 - 1.0
                tileArray[nodeIndex].size.width = frame.width/10 - 1.0
                tileArray[nodeIndex].zPosition = 2.0
                tileArray[nodeIndex].anchorPoint = CGPointMake(0.0,0.0)
                tileArray[nodeIndex].position = CGPointMake(x , y)
                tileArray[nodeIndex].hidden = true
                
                self.addChild(tileArray[nodeIndex])
                nodeIndex++
                columns--;
                
            }
            //columns = 0;
            rows++;
            
        }
        print(tileArray.count, terminator: "")
        tileArray[20].color = UIColor.redColor()
        tileArray[20].hidden = false
        
        tileArray[99].color = UIColor.blueColor()
        tileArray[99].hidden = false
        
        tileArray[99].color = UIColor.greenColor()
        tileArray[99].hidden = false
        
        tileArray[79].color = UIColor.whiteColor()
        tileArray[79].hidden = false
        
        tileArray[1].color = UIColor.purpleColor()
        tileArray[1].hidden = false
        
    }
    func loadPlayer() {
        player.name = "Player"
        player.size.width = frame.height / 20
        player.size.height = frame.width / 20
        player.anchorPoint = CGPointMake(0,0)
        player.position.x = tileArray[0].size.width/20
        player.position.y = tileArray[0].size.height/3
        player.zPosition = 3.0
        player.userData = ["tilePosition": 0]
        
        player.color = UIColor.blackColor()
        self.addChild(player)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let dieRoll = dicelogic.nextInt();
            dice.text = String(dieRoll);
            
            let destinationTile = player.userData!.objectForKey("tilePosition") as! Int + dieRoll;
            
            if destinationTile <= 99 {
                player.userData!["tilePosition"] = destinationTile;
                let posX = tileArray[destinationTile].position.x + tileArray[destinationTile].size.width/20
                let posY = tileArray[destinationTile].position.y + tileArray[destinationTile].size.height/3
                let currentLocation = CGPointMake(posX, posY)
                let action = SKAction.moveTo(currentLocation, duration: 0.5)
                player.runAction(SKAction.sequence([action]))
                if (destinationTile == 99) {
                    //Do Stuff
                    self.removeAllChildren()
                    self.view!.presentScene(scene)                    
                }
            }
            

            /*let location = touch.locationInNode(self)
                var currentLocation = CGPointMake(location.x, location.y)
                for var tileIndex = Int(1) ; tileIndex < tileArray.count ; tileIndex++ {
                if ((location.x > tileArray[tileIndex - 1].position.x && location.x < tileArray[tileIndex].position.x) && (location.y > tileArray[tileIndex].position.y)) {
                    destinationTile = tileIndex
                    currentLocation.x = tileArray[tileIndex-1].position.x + tileArray[tileIndex-1].size.width/20
                    currentLocation.y = tileArray[tileIndex-1].position.y + tileArray[tileIndex-1].size.height/3

                } else if ((location.x > tileArray[tileIndex].position.x && location.x < frame.width) && (location.y > tileArray[tileIndex].position.y)) {
                    currentLocation.x = tileArray[tileIndex].position.x + tileArray[tileIndex].size.width/20
                    currentLocation.y = tileArray[tileIndex].position.y + tileArray[tileIndex].size.height/3

                }
            }*/
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
