//
//  outViewController.swift
//  AR_Beta
//
//  Created by ryo on 2022/12/8.
//

import ARKit
import SceneKit
import UIKit

class OutViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var catArray = [SCNNode]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics.insert(.personSegmentationWithDepth)
        configuration.planeDetection = .horizontal
        
        configuration.isCollaborationEnabled = true
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .any) {
                if let result = sceneView.session.raycast(query).first {
                    addCat(atLocation: result)
                }
            }
        }
    }
    
    func addCat(atLocation location: ARRaycastResult) {
        let position = location.worldTransform
        let catScene = SCNScene(named: "art.scnassets/cat.scn")!
        if let catNode = catScene.rootNode.childNode(withName: "rig",recursively: true) {
            
//            catNode.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
            
            catNode.position = SCNVector3(
                x: position.columns.3.x,
                y: position.columns.3.y,
                z: position.columns.3.z)
            
            catArray.append(catNode)
            
            sceneView.scene.rootNode.addChildNode(catNode)
        }
    }
    
}
