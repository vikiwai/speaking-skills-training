//
//  RegistrationViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenteredPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: Actions
    
    @IBAction func signUp(_ sender: Any) {
        if passwordCheck() {
            postRequestCreateNewUser()
        }
    }
    
    // MARK: Private methods
    
    private func passwordCheck() -> Bool {
        var confirmed = false
        
        if passwordTextField.text == reenteredPasswordTextField.text! {
            confirmed = true
        } else {
            DispatchQueue.main.async {
                self.addAlert(alertTitle: "Passwords don't match",
                              alertMessage: "The entered passwords are different, so registration is not completed")
            }
        }
        
        return confirmed
    }
    
    private func postRequestCreateNewUser() {
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
                    
                    print(dict ?? "NULL SIGN-UP")
                    
                    if dict!["status"]! == "200" {
                        DispatchQueue.main.async {
                            // self.save(token: dict!["token"]!, email: self.inputEmailField.text!)
                            
                            self.postRequestGenerateToken()
                            
                            self.addTransitionBetweenViewControllers(nameController: "Registration", identifierController: "App")
                        }
                    } else {
                        print("Validation error")
                        self.addAlert(alertTitle: "Validation error",
                                      alertMessage: "* is required")
                    }
                } else {
                    print("No readable data received in response SIGN-UP")
                }
            }
            
            task.resume()
            
        } catch {
            print("Something was wrong with post request for registration")
        }
    }
    
    private func postRequestGenerateToken() {
        var request = URLRequest(url: URL(string: "")!) // MARK: TODO
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let params: [String: String] = [
            "login": loginTextField.text!,
            "password": passwordTextField.text!
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
                    
                    print(dict ?? "NULL TOKEN")
                    
                    if dict!["status"]! == "200" {
                        DispatchQueue.main.async {
                            print(dict!["token"]!)
                            // self.save(token: dict!["token"]!, email: self.inputEmailField.text!)
                        }
                    } else {
                        print("Password error")
                        self.addAlert(alertTitle: "Password error",
                                      alertMessage: "Wrong password")
                    }
                } else {
                    print("No readable data received in response TOKEN")
                }
            }
            
            task.resume()
            
        } catch {
            print("Something was wrong with post request for token generation")
        }
    }
    
    private func addAlert(alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                       UIAlertAction in NSLog("OK")
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func addTransitionBetweenViewControllers(nameController: String, identifierController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: nameController, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifierController)
        // as! ClassViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    // MARK: Loading the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

// MARK: Extensions

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: true) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
