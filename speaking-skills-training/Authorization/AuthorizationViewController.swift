//
//  AuthorizationViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            // successful
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        // user doesn't exist
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Registration") as! RegistrationViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
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
