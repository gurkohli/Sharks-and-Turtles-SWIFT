//
//  Dice.swift
//  Sharks and Turtles
//
//  Created by Gur Kohli on 2016-06-08.
//  Copyright © 2016 Gur Kohli. All rights reserved.
//

import SpriteKit
import GameKit

@available(iOS 9.0, *)
class Dice: SKSpriteNode {
    var dicelogic = GKRandomDistribution.d6()
    
    //Placeholder for the actual dice. TODO - Remove this
    var dicePlaceholder: SKLabelNode
    
    init(nodeSize: CGSize, nodePosition: CGPoint) {
        //TODO Remove this
        self.dicePlaceholder = SKLabelNode(fontNamed: "Chalkduster")
        super.init(texture: nil, color: UIColor.clearColor(), size: nodeSize)
        
        //TODO Remove all this
        dicePlaceholder.name = "dicePlaceholder"
        dicePlaceholder.text = "0"
        dicePlaceholder.position = nodePosition
        dicePlaceholder.color = UIColor.blackColor()
        
        self.name = "dice"
        self.addChild(dicePlaceholder)
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        //TODO Remove this
        self.dicePlaceholder = SKLabelNode()
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rollDice() -> Int {
        let dieRoll = dicelogic.nextInt();
        dicePlaceholder.text = String(dieRoll);
        return dieRoll;
    }
}
