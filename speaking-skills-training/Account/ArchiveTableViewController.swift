//
//  ArchiveTableViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var attempts: Array<Attempt> = Array();
    
    // MARK: Private methods
    
    private func loadSampleAttempts() {
        
        // MARK: TO-DO AUTO INIT
        guard let attempt1 = Attempt(path: URL(fileURLWithPath: ""), title: "Describe a leisure activity that you do with your family", number: 3, date: "20.05.2020", text: "When is the great advantages of having a family visit to family members is that they never really Ronaldo ideas to spend and enjoy quality time by getting involved with different kinds of ways activities and like iSerya to have one of those extra two families never hesitate to enjoy different leisure activities for an hour and a bit insurers", time: 27.423625) else {
            fatalError("Unable to instantiate lesson1")
        }
        
        attempts += [attempt1]
        
        // Getting score for every attempts
        checkCorrectSpokenText(sourceText: "One of the great advantages of having a family with active family members is that they never really run out of ideas to spend and enjoy quality time by getting involved with different kinds of leisurely activities. I am lucky that I have one of those active families who never hesitate to enjoy different leisure activities whenever an opportunity arrives.", spokenText: attempt1.text)
        
    }
    
    // MARK: Private function
    
    func checkCorrectSpokenText(sourceText: String, spokenText: String) {
        var arrayOfWordsForSourceText: Array<String> = []
        for item in sourceText.components(separatedBy: [" ", "."]) {
            if item != "" {
                arrayOfWordsForSourceText.append(item)
            }
        }
        
        let arrayOfWordsForSpokenText = spokenText.split(separator: " ")
    
        var params: [(String, Bool)] = []
        
        /*
        for (index, item) in arrayOfWordsForSourceText.enumerated() {
            if item == arrayOfWordsForSpokenText[index] || item == arrayOfWordsForSpokenText[index + 1] || item == arrayOfWordsForSpokenText[index + 2] && index != {
                params.append((item, true))
            } else {
                params.append((item, false))
            }
        }
        */
        for item in params {
            print("The word '\(item.0)' is \(item.1) recognized")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Load sample data.
        loadSampleAttempts()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attempts.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AttemptTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AttemptTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AttemptTableViewCell.")
        }

        // Configure the cell.
        
        let attempt = attempts[indexPath.row]
        
        cell.scoreLabel.text = "Score for the attempt #\(attempt.number) — (\(attempt.date))"
        cell.path = attempt.path
        cell.correctSpokenTextLabel.text = "\(attempt.correctSpokenText) %"
        
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
