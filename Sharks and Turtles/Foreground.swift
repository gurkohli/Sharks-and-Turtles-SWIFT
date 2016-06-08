//
//  Foreground.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Foreground: SKSpriteNode {
    var foreground: SKSpriteNode

    init(size: CGSize) {
        self.foreground = SKSpriteNode()
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        self.foreground = SKSpriteNode()
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadGrid() -> [SKSpriteNode]{
        var tileArray = [SKSpriteNode]()
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
        
        tileArray[55].color = UIColor.blueColor()
        tileArray[55].hidden = false
        
        tileArray[99].color = UIColor.greenColor()
        tileArray[99].hidden = false
        
        tileArray[79].color = UIColor.whiteColor()
        tileArray[79].hidden = false
        
        tileArray[0].color = UIColor.purpleColor()
        tileArray[0].hidden = false
        
        return tileArray;
    }

}