//
//  AccountViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 22.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registrationDateLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    // MARK: Actions
    
    @IBAction func didTappedLogOutButton(_ sender: Any) {
    }
    
    @IBAction func didTappedHelpButton(_ sender: Any) {
    }
    
    // MARK: Private properties
    
    private var authToken: String?
    private var user: User?
    
    
    // MARK: Loading the view
    
    override func viewDidLoad() {
        view.addSubview(activityIndicator)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        fetchAuthToken()
        getRequestUser()
        
        super.viewDidLoad()
         
    }
    
    // MARK: Core Data methods
    
    func fetchAuthToken() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Token")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                authToken = (data.value(forKey: "token") as! String)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Private methods
    
    private func getRequestUser() {
        var request = URLRequest(url: URL(string: BaseURL.url + "User")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        print("request: ", request as Any)
        
        let session = URLSession(configuration: .default)
        
        let decoder = JSONDecoder()
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if responseError != nil {
                print("responseError: ", responseError.debugDescription as Any)
                return
            }
            
            print("data: ", responseData!)
            
            do {
                let user = try decoder.decode(User.self, from: responseData!)
                
                DispatchQueue.main.async {
                    self.user = user
                    self.setViewElements()
                }
            } catch {
                print("Something was wrong with getting list of topics", error)
            }
        }
        
        task.resume()
    }
    
    private func setViewElements() {
        userLabel.text! = user!.name + " " + user!.surname
        emailLabel.text! = user!.email
        
        let startIndex = user!.creationDate.index(user!.creationDate.startIndex, offsetBy: 0)
        let endIndex = user!.creationDate.index(user!.creationDate.startIndex, offsetBy: 10)
        
        registrationDateLabel.text = String(user!.creationDate[startIndex..<endIndex])
        
        activityIndicator.stopAnimating()
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
