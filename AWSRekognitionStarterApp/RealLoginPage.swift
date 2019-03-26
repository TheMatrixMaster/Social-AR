//
//  RealLoginPage.swift
//  AWSRekognitionStarterApp
//
//  Created by Stephen Lu on 2019-03-25.
//  Copyright © 2019 AWS. All rights reserved.
//

import UIKit

class RealLoginPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func RealLogin(_ sender: Any) {
        performSegue(withIdentifier: "RealLoginSegue", sender: self)
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
