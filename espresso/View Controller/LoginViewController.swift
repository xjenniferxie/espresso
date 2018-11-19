//
//  LoginViewController.swift
//  espresso
//
//  Created by Jennifer on 11/18/18.
//  Copyright © 2018 Jennifer iOS. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var userEmail = ""
    var userPassword = ""
    
    @IBAction func logInPressed(_ sender: Any) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        if emailText == "" || passwordText == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Log In Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }  else {
            // email and password fields are not blank, let's try logging in the user!
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (user, error) in
                if (error == nil) {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Log In Error", message:
                        error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignUp", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
