//
//  File.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-19.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class PauseMenu: SKSpriteNode {
    
    let RESUME_BUTTON_NODE_NAME = "resumeButton"
    let RESTART_BUTTON_NODE_NAME = "restartButton"
    let OPTIONS_BUTTON_NODE_NAME = "optionsButton"
    let END_GAME_BUTTON_NODE_NAME = "endGameButton"
    
    init(nodeSize: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        name = "pauseMenu"
        size = nodeSize
        anchorPoint = CGPointMake(0.5, 0.5)
        zPosition = 100.0
        color = UIColor.clearColor()
        
        let ref = CGPathCreateWithRoundedRect(CGRectMake(-nodeSize.width/2, -nodeSize.height/2, nodeSize.width, nodeSize.height), 5, 5, nil)
        let shape = SKShapeNode(path: ref)
        shape.fillColor = UIColor.whiteColor()
        shape.alpha = 0.5
        addChild(shape)
        
        createButtons()

    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButtons() {
        let PADDING = CGFloat(10)
        let INTER_BUTTON_PADDING = CGFloat(10)
        let noOfButtons = CGFloat(4)
        let availableWidth = size.width - 2*PADDING
        let availableHeight = size.height - 2*PADDING
        
        let buttonWidth = availableWidth
        let buttonHeight = (availableHeight - noOfButtons*INTER_BUTTON_PADDING)/noOfButtons
        let buttonSize = CGSizeMake(buttonWidth, buttonHeight)
        
        let resumeButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        resumeButtonNode.name = RESUME_BUTTON_NODE_NAME
        resumeButtonNode.position = CGPointMake(0, INTER_BUTTON_PADDING/2 + buttonHeight + INTER_BUTTON_PADDING)
        resumeButtonNode.anchorPoint = CGPointMake(0.5,0)
        
        let restartButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        restartButtonNode.name = RESTART_BUTTON_NODE_NAME
        restartButtonNode.position = CGPointMake(0, INTER_BUTTON_PADDING/2)
        restartButtonNode.anchorPoint = CGPointMake(0.5,0)
        
        let optionsButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        optionsButtonNode.name = OPTIONS_BUTTON_NODE_NAME
        optionsButtonNode.position = CGPointMake(0, -INTER_BUTTON_PADDING/2)
        optionsButtonNode.anchorPoint = CGPointMake(0.5,1)
        
        let endGameButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        endGameButtonNode.name = END_GAME_BUTTON_NODE_NAME
        endGameButtonNode.position = CGPointMake(0, -(INTER_BUTTON_PADDING/2 + buttonHeight + INTER_BUTTON_PADDING))
        endGameButtonNode.anchorPoint = CGPointMake(0.5,1)
        
        addChild(resumeButtonNode)
        addChild(restartButtonNode)
        addChild(optionsButtonNode)
        addChild(endGameButtonNode)
    }


}