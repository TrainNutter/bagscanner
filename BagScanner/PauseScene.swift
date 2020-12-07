//
//  PauseScene.swift
//  BagScanner
//
//  Created by Edward Thwaites on 03/12/2020.
//
import SpriteKit
import GameplayKit

class PauseScene: SKScene {

    override func sceneDidLoad() {

    }
    
    func exitWithoutSave() {
        let alert = UIAlertController(title: "Exit to Main Menu", message: "Are you sure you want to exit without saving?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        //self.present(alert, animated: true)
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
    
    func presentMainMenuScene() {
        if let scene = GKScene(fileNamed: "MenuScene") {
            if let sceneNode = scene.rootNode as! MenuScene? {
                
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
    
    //func saveAndExit() {
    //let saveFile = FILE(fileNames: "GameSave")
          
    //}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
             let location = touch.location(in: self)
             let touchedNode = atPoint(location)
             if touchedNode.name == "continue_Button" {
                presentGameScene()
             }
             if touchedNode.name == "exitMenu_Button"{
                presentMainMenuScene()
                
                //Can only be used on MacOS version - Will be rejected on App store for tvOS, WatchOS & iOS app stores
            }
            if touchedNode.name == "saveExit_Button"{
                
            }
        }
        
        // check touch is inside play button
        // play animation on the play button

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
            }
}
