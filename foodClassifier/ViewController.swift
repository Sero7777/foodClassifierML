//
//  ViewController.swift
//  foodClassifier
//
//  Created by Max Wagner on 20.11.19.
//  Copyright © 2019 Max Wagner. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        spinner.hidesWhenStopped = true
    }
    
    
    @IBAction func onChooseImageButtonClicked(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
 
}

extension ViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image // hier Zugriff auf Image, kann an Backend weitergeleitet werden
        self.textView.text = ""
        self.spinner.startAnimating()

        textView.textColor = UIColor.lightGray
        
        if (image != nil){
            postImage(image: image!)
        }
        
    }
    
    
    private func postImage(image: UIImage){
         
//        let URL_dev = "http://ec2-3-85-221-131.compute-1.amazonaws.com:5000/predict"
        let URL_prod = "http://ec2-54-162-98-100.compute-1.amazonaws.com:5000/predict"
        let imgData = image.jpegData(compressionQuality: 0.2)!

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image", fileName: "image", mimeType: "image/jpg")
            },to:URL_prod, method: .post){ (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let predictionsArray = response.result.value{
                        let predictionsArrayAsString = predictionsArray as! String
                        self.spinner.stopAnimating()
                        self.textView.font = UIFont(name: self.textView.font.fontName, size: 30)
                        self.textView.text = "\(predictionsArrayAsString)"
                        print(predictionsArrayAsString)
                        if (predictionsArrayAsString == "hotdog"){
                            self.textView.backgroundColor = UIColor.green
                        } else {
                            self.textView.backgroundColor = UIColor.red
                        }
                    }
                }

            case .failure(let encodingError):
                print("Failed")
                print(encodingError)
            }
        }
    }
}
