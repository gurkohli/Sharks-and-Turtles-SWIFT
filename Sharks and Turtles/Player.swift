//
//  Player.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    init(framesize: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: framesize)
        
        name = "Player"
        size.width = framesize.width/20
        size.height = framesize.height/20
        anchorPoint = CGPointMake(0.5,0.5)
        position.x = framesize.width/20 - 0.5
        position.y = framesize.height/20 - 0.5
        zPosition = 3.0
        userData = ["tilePosition": 1]
        zRotation = 1.5708 //90 Degrees
        
        color = UIColor.blackColor()
    }

    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getCurrentTile() -> Int {
        return userData!.objectForKey("tilePosition") as! Int;
    }
    
    func setCurrentTile(currentTile: Int) {
        userData!["tilePosition"] = currentTile
    }
    
    func createPathBetweenTiles(sourceTile: Int, destinationTile: Int, tileArray:[Foreground.Tile]) -> CGPath {
        let ref = CGPathCreateMutable()
        if (sourceTile < destinationTile) {
            for var i = sourceTile; i <= destinationTile; ++i {
                let p = tileArray[i]
                
                if i == sourceTile {
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                }
            }
        } else if (sourceTile > destinationTile) {
            for var i = sourceTile; i >= destinationTile; --i {
                let p = tileArray[i]
                
                if i == sourceTile {
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + p.size.height/2)
                }
            }
        }
        return ref
    }
    func movePlayer(dieRoll: Int, tileArray: [Foreground.Tile], runAfterActionCompletion: () -> Void) {
        
        let sourceTile = getCurrentTile()
        let destinationTile = sourceTile + dieRoll;
        
        if destinationTile <= 100 {
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.2),
                SKAction.runBlock({
                    let ref = self.createPathBetweenTiles(sourceTile, destinationTile: destinationTile, tileArray: tileArray)
                    
                    let action = SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 200);
                    self.runAction(action);
                })
                ]), completion: runAfterActionCompletion);
            setCurrentTile(destinationTile)
            if (destinationTile == 100) {
                //Do Stuff
                //self.removeAllChildren()
                //self.view!.presentScene(scene)
            }
        }
    }
    
    func movePlayerToTile(destinationTile:Int, tileArray: [Foreground.Tile], runAfterActionCompletion: () -> Void) {
        let ref = createPathBetweenTiles(getCurrentTile(), destinationTile: destinationTile, tileArray: tileArray)
        runAction(SKAction.sequence([SKAction.waitForDuration(1),SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 300)]), completion: runAfterActionCompletion)
        setCurrentTile(destinationTile)
    }

}