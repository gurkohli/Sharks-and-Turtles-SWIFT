//
//  Background.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        loadBackground()
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadBackground() {
        var backgroundTexture = [SKTexture]()
        
        name = "Background"
        size = frame.size
        anchorPoint = CGPointMake(0.0,0.0)
        zPosition = 1.0
        
        
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
        runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(backgroundTexture, timePerFrame: 0.20)))
        
        color = UIColor.blueColor()
        colorBlendFactor = 0.3
    }
}