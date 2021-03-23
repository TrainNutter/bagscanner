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
    var currentScore = 0
    var gameTimerCount:Int = 90
    var gameTimerLabel = String()
    var timer : Timer!
    var timeString = ""
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    private var bagNode : SKSpriteNode?
    private var contrabandNode : SKSpriteNode?
    private var clutterNode : SKSpriteNode?
    private var contrabandNodes = [SKSpriteNode]()
    private var clutterNodes = [SKSpriteNode]()
    private var bagNodes = [SKSpriteNode]()
    private var randomLoop = Int.random(in: 1..<10)
    private var yesButtonPressed = false
    private var noButtonPressed = false
    private var contrabandChance = 4
    private var contrabandPresent = false
    private var scoreLabel : SKLabelNode?
    private var timerLabel : SKLabelNode?
    private var bestScoreLabel : SKLabelNode?

    let score = "Score"
    let bestScore = "BestScore"
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        self.timerLabel = self.childNode(withName: "//timerLabel") as? SKLabelNode
        
        // get bag and child nodes from scene
        
//        self.bagNode = self.childNode as? SKSpriteNode
//        for parent in self.bagNode.parent {
//            if let parentNode = parent as? SKSpriteNode {
//                if (parentNode.name!.hasPrefix("bagNode")) {
//                    bagNodes.append(parentNode)
//                } else {
//
//                }
//            }
//        }
        
        self.bagNode = self.childNode(withName: "bagNode1") as? SKSpriteNode
        for child in self.bagNode!.children {
            if let childNode = child as? SKSpriteNode {
                if (childNode.name!.hasPrefix("clutter")) {
                    clutterNodes.append(childNode)
                } else {
                    contrabandNodes.append(childNode)
                }
            }
        }
        
        /* Reset Score label */
        scoreLabel?.text = "\(currentScore)"
        
        // setup bag and contents
        self.createBag()
        self.showContraband()
        self.showClutter()
        
        // timer - call now to set to 3:00
        timerLabel!.text = "01:30"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameTimerCounter), userInfo: nil, repeats: true)
        
//        bestScoreLabel!.text = "\(bestScore)"
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
             if touchedNode.name == "pause_Button" {
                presentPauseScene()
             }
             if touchedNode.name == "yesButton" {
                yesButtonPressed = true
                bagVerify()
             }
             if touchedNode.name == "noButton" {
                noButtonPressed = true
                bagVerify()
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
    
//    func presentSuccessScene() {
//        if let scene = GKScene(fileNamed: "SuccessScene") {
//
//            // Get the SKScene from the loaded GKScene
//            if let successScene = scene.rootNode as! SuccessScene? {
//                successScene.viewController = viewController
//
//                // Set the scale mode to scale to fit the window
//                successScene.scaleMode = .aspectFill
//
//                // Present the scene
//                //as! SKView also works
//                if let view = self.view {
//                    view.presentScene(successScene)
//
//                    view.ignoresSiblingOrder = true
//
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                }
//            }
//        }
//    }
//
    @objc func gameTimerCounter() -> Void {
        gameTimerCount = gameTimerCount - 1
        if (gameTimerCount < 0) {
            // todo: game over!
//            presentSuccessScene()
            return
        }
        let seconds = gameTimerCount % 60
        let minutes = gameTimerCount / 60
        
        let secondsStr = String(format: "%02d", seconds)
        timerLabel!.text = "0\(minutes):\(secondsStr)"
    }

    func makeTimeString(minutes: Int, seconds: Int) -> String{
        timeString += String(format: "0%2d&", minutes)
        timeString += ":"
        timeString += String(format: "0%2d", seconds)
        return timeString
    }
    
    func showBag() {
        for node in self.bagNodes {
            node.isHidden = true
        }
        self.bagNodes.randomElement()?.isHidden = false
    }
    
    func createBag() {
        if let bag = self.bagNode {
            let textureNames = ["bag1", "bag2", "bag3", "bag4"]
            let randomName = textureNames.randomElement()!

            bag.texture = SKTexture(imageNamed: randomName)
//            self.bagNode?.texture = texture
        }
    }
    
    func showClutter() {
        for node in self.clutterNodes {
            node.isHidden = false
        }
        self.clutterNodes.randomElement()?.isHidden = true
    }
    
    func showContraband() {
        for node in self.contrabandNodes {
            node.isHidden = true
        }
        contrabandChance = Int.random(in:1..<3)
        if contrabandChance == 1 {
            contrabandPresent = true
            self.contrabandNodes.randomElement()?.isHidden = false
        } else {
            contrabandPresent = false
        }
    }
    
    func createNewBag() {
        createBag()
        showClutter()
        showContraband()
    }
    
    func createBagOld() {
        if let bag = self.bagNode {
            let randomBagSelect = Int.random(in: 0..<4)

            if randomBagSelect == 0 {
                bag.texture = SKTexture(imageNamed: "bag1")
            }

            if randomBagSelect == 1 {
                bag.texture = SKTexture(imageNamed: "bag2")
            }

            if randomBagSelect == 2 {
                bag.texture = SKTexture(imageNamed: "bag3")
            }

            if randomBagSelect == 3 {
                bag.texture = SKTexture(imageNamed: "bag4")
            }
        }
    }
    
    func bagVerify() {
        if yesButtonPressed == true {
            if contrabandPresent == true {
                currentScore+=1
                scoreLabel?.text = String(currentScore)
            }
            if contrabandPresent == false {
                currentScore-=2
                scoreLabel?.text = String(currentScore)
                }
            }
            yesButtonPressed = false
        if noButtonPressed == true {
            if contrabandPresent == false {
                currentScore+=1
                scoreLabel?.text = String(currentScore)
            }
            if contrabandPresent == true {
                currentScore-=2
                scoreLabel?.text = String(currentScore)
            }
            noButtonPressed = false
        }
        contrabandPresent = false
        createNewBag()
    }
    
    func setScore(_ value: Int) {
        
        if value > getBestScore() {
            setBestScore(value)
        }
        
        UserDefaults.standard.set(value, forKey: score)
        UserDefaults.standard.synchronize()
    }
    
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: score)
    }
    
    func setBestScore(_ value: Int) {
        UserDefaults.standard.set(value, forKey: bestScore)
        UserDefaults.standard.synchronize()
//        writeData()
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: bestScore)
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
    
//    func writeData() {
//        let file = "gamesave.rtf" //this is the file. we will write to and read from it
//
//        let text = getBestScore //just a text
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            let fileURL = dir.appendingPathComponent(file)
//
//            //writing
//            do {
//                try text.write(to: fileURL, atomically: false, encoding: UTF8)
//            }
//            catch {/* error handling here */}
//        }
//    }
//    func retriveData() {
//        let file = "gamesave.rtf"
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = dir.appendingPathComponent(file)
//            do {
//                _ = try String(contentsOf: fileURL, encoding: utf8)
//            }
//            catch {/* error handling here */}
//        }
//    }
}
