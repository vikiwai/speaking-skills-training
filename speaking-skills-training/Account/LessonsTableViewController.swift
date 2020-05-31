//
//  LessonsTableViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 24.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import CoreData

class LessonsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var authToken: String?
    var lessons: Array<Lesson> = Array();
    
    // MARK: Private methods
    
    private func getRequestListOfTopics() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Topic/list")!)
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
            
            struct List: Decodable {
                let list: Array<Lesson>
            }
            
            do {
                let array = try decoder.decode(List.self, from: responseData!)
                
                DispatchQueue.main.async {
                    self.lessons = array.list
                    self.tableView.reloadData()
                }
            } catch {
                print("Something was wrong with getting list of topics", error)
            }
        }
        
        task.resume()
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
    
    // MARK: Loading the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAuthToken()
        getRequestListOfTopics()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LessonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LessonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LessonTableViewCell.")
        }

        let lesson = lessons[indexPath.row]
        
        cell.topicNumber = lesson.id
        cell.titleLabel!.text = lesson.name
        cell.categoryLabel!.text = lesson.theme
        cell.levelLable!.text = lesson.levelName
        cell.topicModelAnswer = lesson.text
        cell.topicDescription = lesson.questionsString
        
        cell.delegate = self
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
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

extension LessonsTableViewController: LessonTableViewCellDelegate {    
    func lessonTableViewCell(_ cell: LessonTableViewCell, id: Int, titleText: String, categoryText: String, levelText: String, modelAnswerText: String, descriptionText: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Topic") as! TopicViewController

        newViewController.modalPresentationStyle = .fullScreen
        
        newViewController.setConfigurationModel(configurationModel: .init(id: id, titleText: titleText, categoryText: categoryText, levelText: levelText, modelAnswerText: modelAnswerText, descriptionText: descriptionText))
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func lessonTableViewCell(_ cell: LessonTableViewCell) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Archive") as! ArchiveTableViewController

        newViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
