//Perspective transformation
/*var rotationWithPerspective = CATransform3DIdentity;
rotationWithPerspective.m34 = -1.0/200;
rotationWithPerspective = CATransform3DRotate(rotationWithPerspective, CGFloat(GLKMathDegreesToRadians(30)), 1, 0, 0);
view.layer.transform = rotationWithPerspective*/
//view.layer.sublayerTransform = rotationWithPerspective


// Camera panning
/*let delay = SKAction.waitForDuration(0.2)
let moveToPlayer = SKAction.moveTo(currentPlayer.position, duration: 0.2)
let rotate = SKAction.rotateToAngle(currentPlayer.zRotation, duration: 0.2, shortestUnitArc: true)
let scale = SKAction.scaleTo(0.15, duration: 0.2)
let switchCam = SKAction.runBlock({
self.camera = self.playerCam
/*var rotationWithPerspective = CATransform3DIdentity;
rotationWithPerspective.m34 = -1.0/200;
rotationWithPerspective = CATransform3DRotate(rotationWithPerspective, CGFloat(GLKMathDegreesToRadians(10)), 1, 0, 0);
self.view?.layer.transform = rotationWithPerspective*/
self.birdEyeCam.position = CGPointMake(self.size.width/4, self.size.height/4)
self.birdEyeCam.zRotation = self.zRotation
self.birdEyeCam.setScale(0.5)
})
camera?.runAction(SKAction.sequence([delay, moveToPlayer, rotate, scale, switchCam]), completion:  {
currentPlayer.movePlayerToTile(self.getTurtleDestinationTile(currentTile), tileArray: self.tileArray,runAfterActionCompletion: {
self.isSharkTurtleActionRunning = false
let delay = SKAction.waitForDuration(0.2)
let moveToPlayer = SKAction.moveTo(CGPointMake(self.size.width/4, self.size.height/4), duration: 0.2)
let rotateBack = SKAction.rotateToAngle(self.zRotation, duration: 0.2, shortestUnitArc: true)
let scaleBack = SKAction.scaleTo(0.5, duration: 0.2)
let switchCam = SKAction.runBlock({
self.camera = self.birdEyeCam
self.playerCam.setScale(0.15)
var rotationWithPerspective = CATransform3DIdentity;
self.view?.layer.transform = rotationWithPerspective
})
self.camera?.runAction(SKAction.sequence([delay, rotateBack, scaleBack, moveToPlayer, switchCam]), completion: callback)
})
})
*/
//if (isSharkTurtleActionRunning) {// && self.camera?.name == "playerCam") {
//    
//    let rotation = SKAction.rotateToAngle(curPlayer.zRotation, duration: 0.2, shortestUnitArc: true)
//    let moveToPlayer = SKAction.moveTo(curPlayer.position, duration: 0.2)
//    playerCam.runAction(SKAction.sequence([moveToPlayer, rotation]))
//}
