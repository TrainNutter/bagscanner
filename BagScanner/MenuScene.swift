//
//  MenuScene.swift
//  BagScanner
//
//  Created by Edward Thwaites on 30/11/2020.
//

import SpriteKit
import GameplayKit
import UIKit

class MenuScene: SKScene {

    var viewController: UIViewController?
    
    override func sceneDidLoad() {

    }
    
    func presentGameScene() {
        if let scene = GKScene(fileNamed: "GameScene")  {
            
            // Get the SKScene from the loaded GKScene
            if let gameScene = scene.rootNode as! GameScene? {
                gameScene.viewController = viewController

                // Copy gameplay related content over to the scene
                gameScene.entities = scene.entities
                gameScene.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                gameScene.scaleMode = .aspectFill
                
                // Present the scene
                //as! SKView also works
                if let view = self.view {
                    view.presentScene(gameScene)
                    
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
             if touchedNode.name == "play_Button" {
                presentGameScene()
                }
             if touchedNode.name == "exit_Button"{
                exit(1)
                //Can only be used on MacOS version - Will be rejected on App store for tvOS, WatchOS & iOS app stores
             }
        }
        
        // check touch is inside play button
        // play animation on the play button

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

    }
}
