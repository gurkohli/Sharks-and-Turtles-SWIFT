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

    var bg: SKSpriteNode
    var tileArray = [SKSpriteNode]()
    var player: SKSpriteNode
    var dice: SKLabelNode
    var dicelogic = GKRandomDistribution.d6()
    
    override init(size: CGSize) {
        self.bg = SKSpriteNode()
        self.player = SKSpriteNode()
        self.dice = SKLabelNode(fontNamed: "Chalkduster")
        super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //dispatch_async(queue, loadBackground);
        //let backgroundThread = NSThread(target: self, selector: "loadBackground", object: nil);
        //backgroundThread.start();
        //loadBackground()
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
        var backgroundTexture = [SKTexture]()
        
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
        var tempNode = SKSpriteNode()
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
                tileArray[nodeIndex].anchorPoint = CGPointMake(0.5,0.5)
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
                tileArray[nodeIndex].anchorPoint = CGPointMake(0.5,0.5)
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
        player.anchorPoint = CGPointMake(0.5,0.5)
        player.position.x = frame.width/20 - 0.5
        player.position.y = frame.height/20 - 0.5
        player.zPosition = 3.0
        player.userData = ["tilePosition": 0]
        
        player.color = UIColor.blackColor()
        self.addChild(player)
    }
    
    func movePlayer() {
        let dieRoll = dicelogic.nextInt();
        dice.text = String(dieRoll);
        
        let sourceTile = player.userData!.objectForKey("tilePosition") as! Int;
        let destinationTile = sourceTile + dieRoll;
        let sourceRow = sourceTile/10;
        let destinationRow = destinationTile/10;
        
        if destinationTile <= 99 {
            player.runAction(SKAction.sequence([
                // Wait for 0.5 seconds
                //SKAction.waitForDuration(0.5),
                SKAction.runBlock({
                    let ref = CGPathCreateMutable()
                    
                    for var i = sourceTile; i <= destinationTile; ++i {
                        let p = self.tileArray[i]
                        
                        if i == sourceTile {
                            CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                        } else {
                            CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                        }
                    }
                    
                    let shapeNode = SKShapeNode()
                    shapeNode.path = ref
                    shapeNode.name = "line"
                    shapeNode.strokeColor = UIColor.redColor()
                    shapeNode.lineWidth = 2
                    shapeNode.zPosition = 200
                    
                    self.addChild(shapeNode)
                    
                    let action = SKAction.followPath(ref, asOffset: false, orientToPath: false, speed: 200);
                    self.player.runAction(action);
                })
                ]));
            player.userData!["tilePosition"] = destinationTile;
            if (destinationTile == 99) {
                //Do Stuff
                //self.removeAllChildren()
                //self.view!.presentScene(scene)
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            self.movePlayer()
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
             ///   self.movePlayer();
            //})
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
