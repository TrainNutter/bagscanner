//
//  GameScene.swift
//  BagScanner
//
//  Created by Edward Thwaites on 30/11/2020.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var viewController: UIViewController?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var bagNode : SKTexture?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        self.createBag()
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for touch in touches {
             let location = touch.location(in: self)
             let touchedNode = atPoint(location)
             if touchedNode.name == "pause_Button" {
                presentPauseScene()
             }
             if touchedNode.name == "TV" {
                    
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
    
    func presentPauseScene() {
        if let scene = GKScene(fileNamed: "PauseScene") {
            
            // Get the SKScene from the loaded GKScene
            if let pauseScene = scene.rootNode as! PauseScene? {
                pauseScene.viewController = viewController
                
                // Set the scale mode to scale to fit the window
                pauseScene.scaleMode = .aspectFill
                
                // Present the scene
                //as! SKView also works
                if let view = self.view {
                    view.presentScene(pauseScene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func createBag() {
//        let randomBagSelect = Int.random(in: 0..<4)
//        
//        bagNode = SKSpriteNode
//        
//        if var bagNode = self.bagNode {
//        
//            if randomBagSelect == 0 {
//                bagNode.texture = (SKTexture(imageNamed: "Suitcase 1"))
//            }
//            
//            if randomBagSelect == 1 {
//                bagNode.texture = (SKTexture(imageNamed: "Suitcase 2"))
//            }
//            
//            if randomBagSelect == 2 {
//                bagNode.texture = (SKTexture(imageNamed: "Suitcase 3"))
//            }
//            
//            if randomBagSelect == 3 {
//                bagNode.texture = (SKTexture(imageNamed: "Suitcase 4"))
//            }

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
