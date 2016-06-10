//
//  Shark.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Shark: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "BG1")
        super.init(texture: nil, color: UIColor.clearColor(), size: texture.size())
    }
    
    init(size: CGSize, point: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        loadShark(point)
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadShark(centerPoint: CGPoint) -> SKSpriteNode {
        name = "Shark"
        size.width = frame.width / 40
        size.height = frame.height / 40
        anchorPoint = CGPointMake(0.5,0.5)
        position.x = centerPoint.x
        position.y = centerPoint.y
        zPosition = 3.0
        
        color = UIColor.redColor()
        
        // To create non-uniformity
        let randomFloatValue = CGFloat(Float(arc4random())%10)/CGFloat(10)
        
        let ref = CGPathCreateMutable()
        CGPathAddRoundedRect(ref, nil, CGRectMake(centerPoint.x, centerPoint.y, size.width*2, size.height*2), 0.5, 0.5)
        
        CGPathCloseSubpath(ref)
        
        
        runAction(SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(randomFloatValue)),SKAction.repeatActionForever(SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 20+randomFloatValue*20))]))
        return self
    }
    
}
