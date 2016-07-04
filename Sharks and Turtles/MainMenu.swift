//
//  MainMenu.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-30.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit
import GameplayKit

@available(iOS 9.0, *)
class MainMenu: SKScene {
    
    let PLAY_GAME_BUTTON_NODE_NAME = "playGameButton"
    let OPTIONS_BUTTON_NODE_NAME = "optionsButton"
    let SOUND_TOGGLE_BUTTON_NODE_NAME = "soundToggleButton"
    let ONE_PLAYER_BUTTON_NODE_NAME = "onePlayerButton"
    let TWO_PLAYER_BUTTON_NODE_NAME = "twoPlayerButton"
    let BACK_BUTTON_NODE_NAME = "backButton"
    
    let MAIN_MENU_STATE = "MAIN_MENU"
    let GAME_MENU_STATE = "GAME_MENU"
    
    var mainMenuNode: SKNode
    var gameMenuNode: SKNode
    
    var state: String
    
    override init(size: CGSize) {
        mainMenuNode = SKNode()
        gameMenuNode = SKNode()
        
        state = MAIN_MENU_STATE
        super.init(size: size)
        
        anchorPoint = CGPointMake(0.5, 0.5)
        name = "MainMenuFrame"
        backgroundColor = UIColor.brownColor()
        let frameSize = size
        
        loadMainMenu(frameSize)
        loadGameMenu(frameSize)
        
        addChild(mainMenuNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMainMenu(frameSize: CGSize) {
        
        let playButtonSize = CGSizeMake(frameSize.width/1.5, 75)
        let optionsButtonSize = CGSizeMake(frameSize.width/2, 75)
        let soundToggleButtonSize = CGSizeMake(50, 50)
        
        let soundToggleButtonPosition = CGPointMake(frameSize.width/2 - 20, -frameSize.height/2 + 20)
        
        let playGameButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: playButtonSize)
        playGameButtonNode.name = PLAY_GAME_BUTTON_NODE_NAME
        playGameButtonNode.position = CGPointZero
        playGameButtonNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        let optionsButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: optionsButtonSize)
        optionsButtonNode.name = OPTIONS_BUTTON_NODE_NAME
        optionsButtonNode.position = CGPointMake(0, -optionsButtonSize.height - 30)
        optionsButtonNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        let soundToggleButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: soundToggleButtonSize)
        soundToggleButtonNode.name = SOUND_TOGGLE_BUTTON_NODE_NAME
        soundToggleButtonNode.position = soundToggleButtonPosition
        soundToggleButtonNode.anchorPoint = CGPointMake(1, 0)
        
        mainMenuNode.addChild(playGameButtonNode)
        mainMenuNode.addChild(optionsButtonNode)
        mainMenuNode.addChild(soundToggleButtonNode)
    }
    
    func loadGameMenu(frameSize: CGSize) {
        let onePlayerButtonSize = CGSizeMake(frameSize.width/1.5, 75)
        let twoPlayerButtonSize = onePlayerButtonSize
        let backButtonSize = CGSizeMake(frameSize.width/3, 50)
        
        //let backButtonPosition = CGPointMake(frameSize.width/2 - 20, -frameSize.height/2 + 20)
        
        let onePlayerButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: onePlayerButtonSize)
        onePlayerButtonNode.name = ONE_PLAYER_BUTTON_NODE_NAME
        onePlayerButtonNode.position = CGPointZero
        onePlayerButtonNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        let twoPlayerButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: twoPlayerButtonSize)
        twoPlayerButtonNode.name = TWO_PLAYER_BUTTON_NODE_NAME
        twoPlayerButtonNode.position = CGPointMake(0, -twoPlayerButtonSize.height - 30)
        twoPlayerButtonNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        let backButtonNode = SKSpriteNode(color: UIColor.blueColor(), size: backButtonSize)
        backButtonNode.name = BACK_BUTTON_NODE_NAME
        backButtonNode.position = CGPointMake(0, -twoPlayerButtonSize.height*2 - 50)
        backButtonNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        gameMenuNode.addChild(onePlayerButtonNode)
        gameMenuNode.addChild(twoPlayerButtonNode)
        gameMenuNode.addChild(backButtonNode)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            
            let viewTouchLocation = touch.locationInView(self.view)
            let sceneTouchPoint = self.convertPointFromView(viewTouchLocation)
            let touchedNode = self.nodeAtPoint(sceneTouchPoint)
            print(touchedNode.name)
            
            if (state == MAIN_MENU_STATE) {
                if (touchedNode.name == PLAY_GAME_BUTTON_NODE_NAME) {
                    mainMenuNode.removeFromParent()
                    addChild(gameMenuNode)
                    state = GAME_MENU_STATE
                    
                } else if (touchedNode.name == OPTIONS_BUTTON_NODE_NAME) {
                    
                } else if (touchedNode.name == SOUND_TOGGLE_BUTTON_NODE_NAME) {
                    
                }
            } else if (state == GAME_MENU_STATE) {
                if (touchedNode.name == ONE_PLAYER_BUTTON_NODE_NAME) {
                    //self.viewController!.performSegueWithIdentifier("startGameOnePlayer", sender: self)
                    let scene = MainGame(size: self.view!.bounds.size)
                    scene.isPlayer2Computer = true
                    let transition = SKTransition.moveInWithDirection(.Right, duration: 1)
                    self.view?.presentScene(scene, transition: transition)
                    
                } else if (touchedNode.name == TWO_PLAYER_BUTTON_NODE_NAME) {
                    let scene = MainGame(size: self.view!.bounds.size)
                    scene.isPlayer2Computer = false
                    let transition = SKTransition.moveInWithDirection(.Right, duration: 1)
                    self.view?.presentScene(scene, transition: transition)
                    
                } else if (touchedNode.name == BACK_BUTTON_NODE_NAME) {
                    gameMenuNode.removeFromParent()
                    addChild(mainMenuNode)
                    state = MAIN_MENU_STATE
                }
            }
        }
    }
    
    deinit {
        self.scene?.removeFromParent()
        self.removeAllChildren()
        self.removeAllActions()
    }
}