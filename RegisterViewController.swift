//
//  RegisterViewController.swift
//  RecTest
//
//  Created by Julia Sheth on 7/25/18.
//  Copyright © 2018 InternHack. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //Textfields for email and password
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    //label for displaying message
    @IBOutlet weak var labelMessage: UILabel!
    
    //button for registration
    @IBAction func buttonRegister(sender: UIButton) {
        //do the registration operation here
        
        //first take the email and password from the views
        let email = textFieldEmail.text
        let password = textFieldPassword.text
        
        Auth.auth().createUser(withEmail: email!, password: password!)
        { (user, error) in
            if error == nil {
                self.labelMessage.text = "You are successfully registered"
            }else{
                self.labelMessage.text = "Registration Failed.. Please Try Again"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //initialising firebase
        FirebaseApp.configure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
