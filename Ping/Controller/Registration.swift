//
//  Registration.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class Registration: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profileImageUpload: UIImageView!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
    }
    

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError()
        }
        profileImageUpload.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {

        let email = emailField.text!
        let username = usernameField.text!

        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                let uid = Auth.auth().currentUser!.uid
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName)")
                if let uploadData = self.profileImageUpload.image?.pngData() {
                    storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        storageRef.downloadURL(completion: { (url, err) in
                            if let err = err {
                                print(err)
                                return
                            }
                            
                            guard let url = url else { return }
                            let values = ["username": username, "email": email, "profileImageURL": url.absoluteString]
                            
                            self.registerUser(uid, values: values as [String: AnyObject])
                        })
                    })
                }
            }
        }
    }
    
    func registerUser(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
        print("Registration Success")
        dismiss(animated: true, completion: nil)
    }
}
