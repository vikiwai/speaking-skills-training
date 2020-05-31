//
//  AuthorizationViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import CoreData

class AuthorizationViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var authToken: NSManagedObject!
    
    // MARK: Actions
    
    @IBAction func signIn(_ sender: Any) {
        postRequestGenerateToken()
    }
    
    @IBAction func signUp(_ sender: Any) {
        addTransitionBetweenViewControllers(nameStoryBoard: "Registration", identifierController: "Registration")
    }
    
    // MARK: Private methods
    
    private func postRequestGenerateToken() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Auth/login")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
            
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                if responseError != nil {
                    print("responseError: ", responseError.debugDescription as Any)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        print(httpResponse)
                        
                        DispatchQueue.main.async {
                            self.addAlert(alertTitle: "Wrong", alertMessage: "")
                        }
                        return
                    } else {
                        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                            print("response: ", utf8Representation)
                            
                            let dict = utf8Representation.toJSON() as? [String: String]
                            
                            DispatchQueue.main.async {
                                self.save(token: dict!["token"]!)
                                self.addTransitionBetweenViewControllers(nameStoryBoard: "Account", identifierController: "App")
                            }
                        } else {
                            print("No readable data received in response TOKEN")
                        }
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Something was wrong with post request for token generation")
        }
    }
    
    func save(token: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Token", in: managedContext)!
        
        let thisToken = NSManagedObject(entity: entity, insertInto: managedContext)
        thisToken.setValue(token, forKeyPath: "token")
        
        do {
            try managedContext.save()
            authToken = thisToken
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
    
    private func addTransitionBetweenViewControllers(nameStoryBoard: String, identifierController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifierController)
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .flipHorizontal
        
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
