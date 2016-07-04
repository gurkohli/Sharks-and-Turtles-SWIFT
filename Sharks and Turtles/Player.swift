//
//  Player.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var PLAYER_SPEED = CGFloat(200);
    var offsetFromTileBottom = CGFloat(0);
    
    init(nodeSize: CGSize, nodeColor: UIColor?, nodePosition: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        name = "Player"
        size = nodeSize
        anchorPoint = CGPointMake(0.5,0.5)
        position = nodePosition
        userData = ["tilePosition": 1]
        offsetFromTileBottom = position.y
        zRotation = -1.5708 //90 Degrees
        color = UIColor.blackColor()
        if ((nodeColor) != nil) {
            color = nodeColor!
        }
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
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + offsetFromTileBottom)
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + offsetFromTileBottom)
                }
            }
        } else if (sourceTile > destinationTile) {
            for var i = sourceTile; i >= destinationTile; --i {
                let p = tileArray[i]
                
                if i == sourceTile {
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + offsetFromTileBottom)
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + offsetFromTileBottom)
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
                SKAction.waitForDuration(0.5),
                SKAction.runBlock({
                    let ref = self.createPathBetweenTiles(sourceTile, destinationTile: destinationTile, tileArray: tileArray)
                    
                    let action = SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: self.PLAYER_SPEED);
                    self.runAction(action, completion: runAfterActionCompletion);
                })
                ]));
            setCurrentTile(destinationTile)
            if (destinationTile == 100) {
                
            }
        } else {
            runAfterActionCompletion()
        }
    }
    
    func movePlayerToTile(destinationTile:Int, tileArray: [Foreground.Tile], runAfterActionCompletion: () -> Void) {
        let ref = createPathBetweenTiles(getCurrentTile(), destinationTile: destinationTile, tileArray: tileArray)
        let tileDifference = Double(abs(destinationTile - getCurrentTile()))
        runAction(SKAction.sequence([SKAction.waitForDuration(0.5),SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: PLAYER_SPEED + 200 + CGFloat(1.5 * tileDifference))]), completion: runAfterActionCompletion)
        setCurrentTile(destinationTile)
    }

}