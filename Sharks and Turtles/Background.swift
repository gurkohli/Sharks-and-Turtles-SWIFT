//
//  Background.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    var bg: SKSpriteNode
    
    init(size: CGSize) {
        self.bg = SKSpriteNode()
        //let texture = SKTexture(imageNamed: "BG1")
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
    }
    
    init(texture: SKTexture!) {
        self.bg = SKSpriteNode()
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        self.bg = SKSpriteNode()
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}