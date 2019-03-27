//
//  RegisterPage.swift
//  AWSRekognitionStarterApp
//
//  Created by Stephen Lu on 2019-03-23.
//  Copyright © 2019 AWS. All rights reserved.
//

import UIKit
import AWSRekognition

class RegisterPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var NameField: UIView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var PhotoInstructions: UILabel!
    @IBOutlet weak var PhotoButton: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    
    var rekognitionClient:AWSRekognition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ReturnToHome(_ sender: Any) {
        performSegue(withIdentifier: "ReturnFromRegister", sender: self)
    }
    
    @IBAction func NameFieldDone(_ sender: Any) {
        print(FirstName)
        print(LastName)
        dismissKeyboard()
        FirstName.isHidden = true
        LastName.isHidden = true
        SaveButton.isHidden = true
        PhotoInstructions.isHidden = false
        PhotoButton.isHidden = false
    }
    
    @IBAction func PhotoSetup(_ sender: AnyObject?) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        NameField.isHidden = true
        UserImageView.image = image
        UserImageView.isHidden = false
        
        let userImage:Data = UIImageJPEGRepresentation(image, 0.2)!
        addImageToRekognitionCollection(imageData: userImage)
    }
    
    func addImageToRekognitionCollection(imageData: Data) {
        rekognitionClient = AWSRekognition.default()
        let image = AWSRekognitionImage()
        image?.bytes = imageData
        let imageRequest = AWSRekognitionIndexFacesRequest()
        imageRequest?.collectionId = "UserFaces"
        imageRequest?.externalImageId = FirstName.text! + "_" + LastName.text!
        
        imageRequest?.image = image
        
        rekognitionClient?.indexFaces(imageRequest!) { (response:AWSRekognitionIndexFacesResponse?, error:Error?) in
            if error == nil
            {
                print(response!)
                print("Testing registration")
            } else {
                print(error!)
            }
        }
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

