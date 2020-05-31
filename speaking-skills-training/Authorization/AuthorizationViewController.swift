//
//  AuthorizationViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Actions
    
    @IBAction func signIn(_ sender: Any) {
        postRequestGenerateToken()
        //addTransitionBetweenViewControllers(nameController: "Authorization", identifierController: "Lessons")
    }
    
    @IBAction func signUp(_ sender: Any) {
        addTransitionBetweenViewControllers(nameController: "Authorization", identifierController: "Registration")
    }
    
    // MARK: Private methods
    
    private func postRequestGenerateToken() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Auth/login")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(myToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let params: [String: String] = [
            "login": usernameTextField.text!,
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
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifierController) as! LessonsTableViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    // MARK: Loading the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
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
