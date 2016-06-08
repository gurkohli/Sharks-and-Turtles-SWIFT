//
//  Player.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    var player: SKSpriteNode
    
    init(size: CGSize) {
        self.player = SKSpriteNode()
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
    }
    
    init(texture: SKTexture!) {
        self.player = SKSpriteNode()
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        self.player = SKSpriteNode()
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPlayer() {
        player.name = "Player"
        player.size.width = frame.width / 20
        player.size.height = frame.height / 20
        player.anchorPoint = CGPointMake(0.5,0.5)
        player.position.x = frame.width/20 - 0.5
        player.position.y = frame.height/20 - 0.5
        player.zPosition = 3.0
        player.userData = ["tilePosition": 0]
        player.zRotation = 1.5708 //90 Degrees
        
        player.color = UIColor.blackColor()
        self.addChild(player)
    }
    
    func movePlayer(dieRoll: Int, tileArray: [SKSpriteNode]) {
        
        let sourceTile = player.userData!.objectForKey("tilePosition") as! Int;
        let destinationTile = sourceTile + dieRoll;
        
        if destinationTile <= 99 {
            player.runAction(SKAction.sequence([
                // Wait for 0.5 seconds
                SKAction.waitForDuration(0.2),
                SKAction.runBlock({
                    let ref = CGPathCreateMutable()
                    
                    for var i = sourceTile; i <= destinationTile; ++i {
                        let p = tileArray[i]
                        
                        if i == sourceTile {
                            CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                        } else {
                            CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                        }
                    }
                    
                    /*let shapeNode = SKShapeNode()
                    shapeNode.path = ref
                    shapeNode.name = "line"
                    shapeNode.strokeColor = UIColor.redColor()
                    shapeNode.lineWidth = 2
                    shapeNode.zPosition = 200
                    
                    self.addChild(shapeNode)*/
                    
                    let action = SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 200);
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

}