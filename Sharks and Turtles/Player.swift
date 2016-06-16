//
//  Player.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var PLAYER_SPEED = CGFloat(100);
    
    init(nodeSize: CGSize, nodeColor: UIColor?, nodePosition: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        name = "Player"
        size = nodeSize
        anchorPoint = CGPointMake(0.5,0.5)
        position = nodePosition
        zPosition = 3.0
        userData = ["tilePosition": 1, "offsetFromTileBottom": position.y]
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
    func getOffsetFromTileBottom() -> CGFloat {
        return userData!.objectForKey("offsetFromTileBottom") as! CGFloat
    }
    
    func createPathBetweenTiles(sourceTile: Int, destinationTile: Int, tileArray:[Foreground.Tile]) -> CGPath {
        let ref = CGPathCreateMutable()
        if (sourceTile < destinationTile) {
            for var i = sourceTile; i <= destinationTile; ++i {
                let p = tileArray[i]
                
                if i == sourceTile {
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + getOffsetFromTileBottom())
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + getOffsetFromTileBottom())
                }
            }
        } else if (sourceTile > destinationTile) {
            for var i = sourceTile; i >= destinationTile; --i {
                let p = tileArray[i]
                
                if i == sourceTile {
                    CGPathMoveToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + getOffsetFromTileBottom())
                } else {
                    CGPathAddLineToPoint(ref, nil, p.position.x + p.size.width/2, p.position.y + getOffsetFromTileBottom())
                }
            }
        }
        return ref
    }
    func movePlayer(dieRoll: Int, tileArray: [Foreground.Tile], runAfterActionCompletion: () -> Void) -> Bool{
        
        let sourceTile = getCurrentTile()
        let destinationTile = sourceTile + dieRoll;
        
        if destinationTile <= 100 {
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.5),
                SKAction.runBlock({
                    let ref = self.createPathBetweenTiles(sourceTile, destinationTile: destinationTile, tileArray: tileArray)
                    
                    let action = SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: self.PLAYER_SPEED);
                    self.runAction(action);
                })
                ]), completion: runAfterActionCompletion);
            setCurrentTile(destinationTile)
            if (destinationTile == 100) {
                return true
                //Do Stuff
                //self.removeAllChildren()
                //self.view!.presentScene(scene)
            }
            return false
        }
        runAfterActionCompletion()
        return false;
    }
    
    func movePlayerToTile(destinationTile:Int, tileArray: [Foreground.Tile], runAfterActionCompletion: () -> Void) {
        let ref = createPathBetweenTiles(getCurrentTile(), destinationTile: destinationTile, tileArray: tileArray)
        runAction(SKAction.sequence([SKAction.waitForDuration(0.5),SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: PLAYER_SPEED + 100)]), completion: runAfterActionCompletion)
        setCurrentTile(destinationTile)
    }

}