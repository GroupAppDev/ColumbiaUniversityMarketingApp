//
//  SignUpViewController.swift
//  Markt
//
//  Created by Jeremy Kim on 12/27/17.
//  Copyright © 2017 jkim. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
        @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty
            else {
                print("Required fields are not all filled!")
                return
        }
        
        AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
            guard let firUser = authUser else {
                return
            }
            
            UserService.create(firUser, username: username) { (user) in
                guard let user = user else {
                    return
                }
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                self.performSegue(withIdentifier: "SignUpSeg", sender: self)
            }
        }
        
        
    }
    
}

extension SignUpViewController{
    func configureView(){
        applyKeyboardPush()
        applyKeyboardDismisser()
        createAccount.layer.cornerRadius = 10
    }
}

