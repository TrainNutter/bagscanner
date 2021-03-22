//
//  SuccessScene.swift
//  BagScanner
//
//  Created by Edward Thwaites on 17/03/2021.
//

import SpriteKit
import GameplayKit
import UIKit

class SuccessScene: SKScene {
    
    var viewController: UIViewController?
    
    private var bestScoreLabel : SKLabelNode
    private var currentScoreLabel : SKLabelNode

    override func sceneDidLoad() {
        self.bestScoreLabel = self.childNode(withName: "//bestScoreLabel") as? SKLabelNode
        self.currentScoreLabel = self.childNode(withName: "//currentScoreLabel") as? SKLabelNode
    }
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
             let location = touch.location(in: self)
             let touchedNode = atPoint(location)
             if touchedNode.name == "exitMenuSave" {
                presentMainMenuScene()
             }
             if touchedNode.name == "continueButton" {
                presentGameScene()
            }
            if touchedNode.name == "exitMenuNoSave"{
                exitWithoutSave()
            }
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func presentMainMenuScene() {
        if let scene = GKScene(fileNamed: "MenuScene") {
            if let sceneNode = scene.rootNode as! MenuScene? {
                sceneNode.viewController = viewController

                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                //as! SKView also works
                if let view = self.view {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func presentGameScene() {
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.viewController = viewController

                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                //as! SKView also works
                if let view = self.view {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func exitWithoutSave() {
        let alert = UIAlertController(title: "Exit to Main Menu", message: "Are you sure you want to exit without saving?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.presentMainMenuScene()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true)
    }
    
    
}
