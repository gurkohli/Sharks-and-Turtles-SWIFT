//
//  GameOverMenu.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-22.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit

class GameOverMenu: PopupMenu {
    
    let WINNING_PLAYER_NODE = "winningPlayerLabel"
    let PLAY_AGAIN_BUTTON_NODE = "playAgainButton"
    let EXIT_GAME_BUTTON_NODE = "exitGameButton"
    
    let winningPlayerNode = SKLabelNode(fontNamed: "AmericanTypewriter")
    
    override init(nodeSize: CGSize) {
        super.init(nodeSize: nodeSize)
        
        name = "gameOverMenu"
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
        let INTER_BUTTON_PADDING = CGFloat(15)
        let noOfButtons = CGFloat(3)
        let availableWidth = size.width - 2*PADDING
        let availableHeight = size.height - 2*PADDING
        
        let buttonWidth = availableWidth
        let buttonHeight = (availableHeight - noOfButtons*INTER_BUTTON_PADDING)/noOfButtons
        let buttonSize = CGSizeMake(buttonWidth, buttonHeight)
        
        winningPlayerNode.name = WINNING_PLAYER_NODE
        winningPlayerNode.position = CGPointMake(0, buttonHeight/2 + INTER_BUTTON_PADDING)
        winningPlayerNode.verticalAlignmentMode = .Bottom
        winningPlayerNode.horizontalAlignmentMode = .Center
        winningPlayerNode.fontSize = 18.0
        //winningPlayerNode.anchorPoint = CGPointMake(0.5,0)
        
        let playAgainButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        playAgainButtonNode.name = PLAY_AGAIN_BUTTON_NODE
        playAgainButtonNode.position = CGPointMake(0, 0)
        playAgainButtonNode.anchorPoint = CGPointMake(0.5,0.5)
        
        let exitGameButtonNode = SKSpriteNode(color: UIColor.brownColor(), size: buttonSize)
        exitGameButtonNode.name = EXIT_GAME_BUTTON_NODE
        exitGameButtonNode.position = CGPointMake(0, -(buttonHeight/2 + INTER_BUTTON_PADDING))
        exitGameButtonNode.anchorPoint = CGPointMake(0.5,1)
        
        addChild(winningPlayerNode)
        addChild(playAgainButtonNode)
        addChild(exitGameButtonNode)
    }
    
    
}