//
//  SignInViewController.swift
//  Markt
//
//  Created by Jeremy Kim on 12/28/17.
//  Copyright © 2017 jkim. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "createUser" {
                print("To Create User Screen!")
            }
            if identifier == "forgotPassword" {
                print("To Forget Password Screen!")
            }
        }
    }
    
    @IBAction func SignInClicked(_ sender: UIButton) {
        dismissKeyboard()
        guard let email = emailTextField.text, let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty
            else{
                return
        }
        AuthService.signIn(controller: self, email: email, password: password) { (user) in
            guard let user = user else {
                print("error: FIRUser does not exist!")
                return
            }
            
            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    User.setCurrent(user, writeToUserDefaults: true)
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                    self.performSegue(withIdentifier: "SignInSeg", sender: self)
                }
                else {
                    print("error: User does not exist!")
                    return
                }
            }
        }
        
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        dismissKeyboard()
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
}

extension SignInViewController{
    func configureView(){
        applyKeyboardPush()
        applyKeyboardDismisser()
        SignInButton.layer.cornerRadius = 10
    }
}
