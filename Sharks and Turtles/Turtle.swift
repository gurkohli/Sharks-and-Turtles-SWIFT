//
//  Shark.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Turtle: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "BG1")
        super.init(texture: nil, color: UIColor.clearColor(), size: texture.size())
    }
    
    init(size: CGSize, point: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        loadTurtle(point)
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadTurtle(centerPoint: CGPoint) -> SKSpriteNode {
        name = "Turtle"
        size.width = frame.width / 40
        size.height = frame.height / 40
        anchorPoint = CGPointMake(0.5,0.5)
        position.x = centerPoint.x
        position.y = centerPoint.y
        zPosition = 3.0

        color = UIColor.greenColor()

        // To create non-uniformity
        let randomFloatValue = CGFloat(Float(arc4random())%10)/CGFloat(10)

        let ref = CGPathCreateMutable()
        CGPathAddRoundedRect(ref, nil, CGRectMake(centerPoint.x + size.width, centerPoint.y, 2, size.height*2), 0.5, 0.5)

        CGPathCloseSubpath(ref)

        runAction(SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(randomFloatValue)),SKAction.repeatActionForever(SKAction.followPath(ref, asOffset: false, orientToPath: true, speed: 10+randomFloatValue*5))]))
        return self
    }
}
