//
//  Foreground.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class Foreground: SKSpriteNode {

    init(nodeSize: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        var backgroundTexture = [SKTexture]()
            
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
        size = nodeSize
    }

    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Tile {
        var size: CGSize
        var position: CGPoint
    }

    func loadGrid() -> [Tile]{
        var tileArray = [Tile]()
        
        // Append point size tile to get 1-indexed tiles
        let temp = Tile(size: CGSizeMake(0, 0), position: CGPointMake(0, 0));
        tileArray.append(temp)
        
        var columns = 0
        var rows = 0
        let width = frame.width/10 - 1.0
        let height = frame.height/10 - 1.0

        for var y=CGFloat(0) ; rows <= 9 ; y += frame.height/10  {
            for var x=CGFloat(0) ; columns <= 9 ; x += frame.width/10 {

                let temp = Tile(size: CGSizeMake(width, height), position: CGPointMake(x, y));
                tileArray.append(temp)
                columns++;
            }
            y += frame.height/10
            rows++;
            for var x=CGFloat(frame.width - frame.width/10) ; columns >= 0 && x >= 0; x -= frame.width/10 {

                let temp = Tile(size: CGSizeMake(width, height), position: CGPointMake(x, y));
                tileArray.append(temp)
                columns--;
            }
            rows++;
        }
        print(tileArray.count, terminator: "")
        return tileArray;
    }
}