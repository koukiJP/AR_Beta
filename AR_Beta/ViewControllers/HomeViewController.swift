//
//  ViewController.swift
//  AR_Beta
//
//  Created by ryo on 2022/11/29.
//

import UIKit
import SceneKit
import ARKit

class HomeViewController: UIViewController, ARSCNViewDelegate  {
    
    
    @IBOutlet weak var sceneView: SCNView!
    var animations = [String: SCNAnimation]()
    var idle:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        sceneView.allowsCameraControl = true
        
        sceneView.scene = scene
        
        loadAnimations()
        
    }
    
    @IBAction func InteractionPressed(_ sender: UIButton) {
        let vc = SelectorViewController()
        vc.modalPresentationStyle = .overCurrentContext
        let nav = UINavigationController(rootViewController: vc)
        
        vc.navigationItem.title = "道具"
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium() , .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        present(nav, animated: true , completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let location = touches.first!.location(in: sceneView)
            
            // Let's test if a 3D Object was touch
            var hitTestOptions = [SCNHitTestOption: Any]()
            hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
            
            let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
            
            if hitResults.first != nil {
                if(idle) {
                    playAnimation(key: "Walk")
                } else {
                    stopAnimation(key: "Walk")
                }
                idle = !idle
                return
            }
    }
    
    func loadAnimations(){
        
        let idleScene = SCNScene(named: "art.scnassets/cat_Sit.dae")!
        
        let node = SCNNode()
        
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(x: 0, y: 1, z: 3)
        node.scale = SCNVector3(0.2, 0.2, 0.2)
        
        sceneView.scene?.rootNode.addChildNode(node)
        
        loadAnimation(withKey: "Walk" , sceneName: "art.scnassets/cat_Walk" , animationIdentifier: "cat_Walk-1")
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: SCNAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 5
//            animationObject.blendInDuration = CGFloat(1)
//            animationObject.blendOutDuration = CGFloat(0.5)
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
        
        
        
        
        func playAnimation(key: String) {
            // Add the animation to start playing it right away
            sceneView.scene!.rootNode.addAnimation(animations[key]!, forKey: key)
        }
        
        func stopAnimation(key: String) {
            // Stop the animation with a smooth transition
            sceneView.scene!.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
        }
        
    }



