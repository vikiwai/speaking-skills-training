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
        if passwordCheck() {
            var request = URLRequest(url: URL(string: "")!) // MARK: TODO
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let params: [String: String] = [
                "login": loginTextField.text!,
                "password": passwordTextField.text!,
                "email": emailTextField.text!,
                "name": firstNameTextField.text!,
                "surname": lastNameTextField.text!
            ]
            
            let encoder = JSONEncoder()
            
            do {
                request.httpBody = try encoder.encode(params)
                
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request) {
                    (responseData, response, responseError) in guard responseError == nil else {
                        print(responseError as Any)
                        return
                    }
                    
                    if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                        print("response: ", utf8Representation)
                        
                        let dict = utf8Representation.toJSON() as? [String: String]
                        
                        print(dict ?? "NULL")
                        
                        if dict!["status"]! == "200" {
                            DispatchQueue.main.async {
                                // self.save(token: dict!["token"]!, email: self.inputEmailField.text!)
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "App") as! LessonsTableViewController
                                
                                newViewController.modalPresentationStyle = .fullScreen
                                
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        } else {
                            print("Validation error")
                            
                            let alertController = UIAlertController(title: "Validation error",
                                                                    message: "* is required",
                                                                    preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                                           UIAlertAction in NSLog("OK")
                            }
                            
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    } else {
                        print("No readable data received in response")
                    }
                }
                
                task.resume()
            } catch {
                print("Something was wrong with post request for registration")
            }
        }
    }
    
    private func passwordCheck() -> Bool {
        var confirmed = false
        
        if passwordTextField.text == reenteredPasswordTextField.text! {
            confirmed = true
        } else {
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

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: true) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
