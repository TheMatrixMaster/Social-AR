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
    
    @IBOutlet weak var NextStepField: UIView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var PhotoInstructions: UILabel!
    @IBOutlet weak var PhotoButton: UIButton!
    
    @IBOutlet weak var UserImageView: UIImageView!
    
    @IBOutlet weak var NameField: UIView!
    @IBOutlet weak var NextStepInstructions: UILabel!
    @IBOutlet weak var NextStepButton: UIButton!
    @IBOutlet weak var FinishRegistration: UIButton!
    
    var photoCount: Int = 0
    
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
    
    func addImageToRekognitionCollection(imageData: Data, PhotoId: Int) {
        rekognitionClient = AWSRekognition.default()
        let image = AWSRekognitionImage()
        image?.bytes = imageData
        let imageRequest = AWSRekognitionIndexFacesRequest()
        imageRequest?.collectionId = "UserFaces"
        imageRequest?.externalImageId = FirstName.text! + "_" + LastName.text! + "_" + String(PhotoId)
        
        imageRequest?.image = image
    
        rekognitionClient?.indexFaces(imageRequest!) { (response:AWSRekognitionIndexFacesResponse?, error:Error?) in
            if error == nil {
                print(response!)
            } else {
                print(error!)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        if photoCount == 0 {
            UserImageView.isHidden = false
            NameField.isHidden = true
            NextStepField.isHidden = false
        } else if photoCount == 1 {
            self.NextStepInstructions.text = "For the next photo, tilt your head down by 30 degrees."
        } else if photoCount == 2 {
            self.NextStepInstructions.text = "For the next photo, tilt your head left by 45 degrees."
        } else if photoCount == 3 {
            self.NextStepInstructions.text = "For the next photo, tilt your head right by 45 degrees."
        } else if photoCount == 4 {
            self.NextStepInstructions.text = "You have finished your registration. Press on the Finish button to begin using Social App."
            NextStepButton.isHidden = true
            FinishRegistration.isHidden = false
        }
        
        UserImageView.image = image
        photoCount += 1
        
        let userImage:Data = UIImageJPEGRepresentation(image, 0.2)!
        addImageToRekognitionCollection(imageData: userImage, PhotoId: photoCount)
    }
}
