/*
 * Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
import UIKit
import SafariServices
import AWSRekognition

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var CelebImageView: UIImageView!
    
    var infoLinksMap: [Int:String] = [1000:""]
    var rekognitionObject:AWSRekognition?
    var checkCamera: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let celebImage:Data = UIImageJPEGRepresentation(CelebImageView.image!, 0.2)!
        //sendImageToRekognition(celebImageData: celebImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if checkCamera == true {
            self.CameraOpen(nil)
            checkCamera = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Button Actions
    @IBAction func CameraOpen(_ sender: AnyObject?) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.cameraCaptureMode = .photo
        present(pickerController, animated: true)
    }
    
    @IBAction func PhotoLibraryOpen(_ sender: AnyObject?) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
    
    @IBAction func ReturnToHome(_ sender: Any) {
        performSegue(withIdentifier: "ReturnFromLogin", sender: self)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        CelebImageView.image = image
        let celebImage:Data = UIImageJPEGRepresentation(image, 0.2)!
        
        //Demo Line
        sendImageToRekognition(celebImageData: celebImage)
    }
    
    
    //MARK: - AWS Methods
    func sendImageToRekognition(celebImageData: Data){
        print("Recognizing")
        //Delete older labels or buttons
        DispatchQueue.main.async {
            [weak self] in
            for subView in (self?.CelebImageView.subviews)! {
                subView.removeFromSuperview()
            }
        }
        
        guard let request = AWSRekognitionSearchFacesByImageRequest() else
        {
            print("Unable to initialize AWSRekognitionSearchfacerequest.")
            return
        }
        request.collectionId = "UserFaces"
        request.faceMatchThreshold = 75
        request.maxFaces = 2
        
        let image = AWSRekognitionImage()
        image!.bytes = celebImageData
        request.image = image
        print("testing")
        rekognitionObject?.searchFaces(byImage: request) { (response:AWSRekognitionSearchFacesByImageResponse?, error:Error?) in
            if error == nil
            {
                print(response!)
                print("testing recognizer")
            } else{
                print(error!)
            }
            
        }
        
    }
    
    @objc func handleTap(sender:UIButton){
        print("tap recognized")
        let celebURL = URL(string: self.infoLinksMap[sender.tag]!)
        let safariController = SFSafariViewController(url: celebURL!)
        safariController.delegate = self
        self.present(safariController, animated:true)
    }
}
