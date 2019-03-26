//
//  ARPage.swift
//  AWSRekognitionStarterApp
//
//  Created by Stephen Lu on 2019-03-25.
//  Copyright © 2019 AWS. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARPage: UIViewController {
    
    
    @IBOutlet weak var ARSceneView: ARSCNView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

