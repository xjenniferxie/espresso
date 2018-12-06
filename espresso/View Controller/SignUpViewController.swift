//
//  SignUpViewController.swift
//  espresso
//
//  Created by Jennifer on 11/18/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    var userEmail = ""
    var userName = ""
    var userPassword = ""
    var userVerifiedPassWord = ""
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        guard let verifiedPassword = passwordVerificationTextField.text else { return }
        
        if email == "" || password == "" || name == "" || verifiedPassword == "" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    let user = Auth.auth().currentUser
                    let changeRequest = user!.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges() { (error) in
                        if let error = error {
                            print(error, "error with setting user display name")
                        }
                    }
                    print("account created")
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    
                    let ref = Database.database().reference()
                    ref.child("Users").child((user?.uid)!).child("historyUpToDate").setValue(false)
                    ref.child("Users").child((user?.uid)!).child("currentUpToDate").setValue(false)
                    
                } else if password != verifiedPassword {
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.passwordVerificationTextField.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Sign Up Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUpToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordVerificationTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
