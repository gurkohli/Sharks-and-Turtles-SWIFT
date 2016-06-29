//
//  File.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-19.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class PopupMenu: SKSpriteNode {
    
    init(nodeSize: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        name = "popupMenu"
        size = nodeSize
        anchorPoint = CGPointMake(0.5, 0.5)
        zPosition = 100.0
        color = UIColor.clearColor()
        
        let ref = CGPathCreateWithRoundedRect(CGRectMake(-nodeSize.width/2, -nodeSize.height/2, nodeSize.width, nodeSize.height), 5, 5, nil)
        let shape = SKShapeNode(path: ref)
        shape.fillColor = UIColor.whiteColor()
        shape.alpha = 0.5
        addChild(shape)

    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
