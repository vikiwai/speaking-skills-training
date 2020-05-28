//
//  RegistrationViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenteredPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
    }
    
    private func passwordCheck() -> Bool {
        var confirmed = false
        
        if passwordTextField.text == reenteredPasswordTextField.text! {
            confirmed = true
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Passwords don't match",
                                                        message: "The entered passwords are different, so registration is not completed",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                               UIAlertAction in NSLog("OK")
                }
                
                alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
        
        return confirmed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
