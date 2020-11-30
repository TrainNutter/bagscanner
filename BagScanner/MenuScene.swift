//
//  MenuScene.swift
//  BagScanner
//
//  Created by Edward Thwaites on 30/11/2020.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    override func sceneDidLoad() {

    }
    
    func presentGameScene() {
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
             let location = touch.location(in: self)
             let touchedNode = atPoint(location)
             if touchedNode.name == "play_button" {
                presentGameScene()
             }
        }
        
        // check touch is inside play button
        // play animation on the play button

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

    }
}
