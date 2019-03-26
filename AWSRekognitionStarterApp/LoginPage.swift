//
//  LoginPage.swift
//  AWSRekognitionStarterApp
//
//  Created by Stephen Lu on 2019-03-23.
//  Copyright © 2019 AWS. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Login(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    
    @IBAction func Register(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
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
