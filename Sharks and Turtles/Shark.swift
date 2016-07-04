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
    
    init(nodeSize: CGSize, nodePosition: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        name = "Shark"
        size = nodeSize
        anchorPoint = CGPointMake(0.5,0.5)
        position = nodePosition
        
        color = UIColor.redColor()
        
        // To create non-uniformity
        let randomFloatValue = CGFloat(Float(arc4random())%10)/CGFloat(10)
        
        let ref = CGPathCreateMutable()
        CGPathAddRoundedRect(ref, nil, CGRectMake(nodePosition.x, nodePosition.y, nodeSize.width*2, nodeSize.height*2), 0.5, 0.5)
        
        CGPathCloseSubpath(ref)
        let delay = SKAction.waitForDuration(NSTimeInterval(randomFloatValue))
        let followPath = SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 20+randomFloatValue*20);
        
        runAction(SKAction.sequence([delay,SKAction.repeatActionForever(followPath)]))
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
