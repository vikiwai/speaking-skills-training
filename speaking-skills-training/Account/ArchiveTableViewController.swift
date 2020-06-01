//
//  ArchiveTableViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import CoreData

class ArchiveTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var authToken: String?
    var attempts: Array<Attempt> = Array();
    var correctSpokenText: [(String, Bool)]!
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    
    // MARK: Server methods
    
    private func getRequestListOfAttempts() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Attempt/topic?topicId=6")!)
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
            
            struct Attempts: Decodable {
                let attempts: Array<Attempt>
            }
            
            do {
                let array = try decoder.decode(Attempts.self, from: responseData!)
                
                DispatchQueue.main.async {
                    self.attempts = array.attempts
                    self.tableView.reloadData()
                }
            } catch {
                print("Something was wrong with getting list of topics", error)
            }
        }
        
        task.resume()
    }
    
    // MARK: Private function
    
    func checkVocabularyLevel(text: String) -> String  {
        
        var countDifficulty: Int = 0
        var countNumbers: Int = 1
        var vocabularyLevel: String = ""
        
        var arrayOfWordsForSourceText: Array<String> = []
        
        for item in text.components(separatedBy: [" ", "."]) {
            if item != "" {
                arrayOfWordsForSourceText.append(item)
            }
        }
        
        // print(arrayOfWordsForSourceText)
        
        struct Level: Codable {
            var entry: String?
            var ten_degree: Int?
            var result_code: String
        }
        
        for item in arrayOfWordsForSourceText {
            
            let headers = [
                "x-rapidapi-host": "twinword-word-graph-dictionary.p.rapidapi.com",
                "x-rapidapi-key": "aab30a58c2msh4f68f14731d00cap193a1djsn10162259a77c"
            ]

            let request = NSMutableURLRequest(url: NSURL(string: "https://twinword-word-graph-dictionary.p.rapidapi.com/difficulty/?entry=\(item)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    // print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let level = try decoder.decode(Level.self, from: data!)
                    if level.result_code == "200" {
                        DispatchQueue.main.async {
                            countDifficulty += level.ten_degree!
                            countNumbers += 1
                            print(countDifficulty)
                            print(countNumbers)
                        }
                    }
                } catch {
                    print("Something was wrong with getting information", error)
                }
            })

            dataTask.resume()
        }
        
        
        if Double(countDifficulty / countNumbers) < 2 {
            vocabularyLevel = "A1"
        } else if Double(countDifficulty / countNumbers) < 4 {
            vocabularyLevel = "A2"
        } else if Double(countDifficulty / countNumbers) < 6 {
            vocabularyLevel = "B1"
        } else if Double(countDifficulty / countNumbers) < 8 {
            vocabularyLevel = "B2"
        } else if Double(countDifficulty / countNumbers) < 10 {
            vocabularyLevel = "C1"
        } else {
            vocabularyLevel = "C2"
        }
        
        print(vocabularyLevel)
        
        return vocabularyLevel
    }
    
    func checkCorrectSpokenText(sourceText: String, spokenText: String) -> [(String, Bool)] {
        var arrayOfWordsForSourceText: Array<String> = []
        for item in sourceText.components(separatedBy: [" ", "."]) {
            if item != "" {
                arrayOfWordsForSourceText.append(item)
            }
        }
        
        let arrayOfWordsForSpokenText = spokenText.split(separator: " ")
    
        var params: [(String, Bool)] = []
        
        var indexSourceText: Int = 0
        var indexSpokenText: Int = 0
        
        let lengthSourceText = arrayOfWordsForSourceText.count
        let lengthSpokenText = arrayOfWordsForSpokenText.count
        
        for n in 0 ... (lengthSourceText - 1) {
            
            // No words ever
            if indexSpokenText == -1 {
                
                /*
                print("NO")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                */
                params.append((arrayOfWordsForSourceText[indexSourceText], false))
                indexSourceText += 1
            } else if indexSpokenText == 0 {
                
                /*
                print("FIRST")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText])
                print(arrayOfWordsForSpokenText[indexSpokenText + 1])
                print(arrayOfWordsForSpokenText[indexSpokenText + 2])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 4
                } else {
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    // indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 1 { // the 2 last
               
                /*
                print("LAST 2")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText - 1])
                print(arrayOfWordsForSpokenText[indexSpokenText])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                }
            } else if indexSpokenText == lengthSpokenText - 2 { // the 3 last
                
                /*
                print("LAST 3")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText - 1])
                print(arrayOfWordsForSpokenText[indexSpokenText])
                print(arrayOfWordsForSpokenText[indexSpokenText + 1])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 3 { // the 4 last
                
                /*
                print("LAST 4")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText - 1])
                print(arrayOfWordsForSpokenText[indexSpokenText])
                print(arrayOfWordsForSpokenText[indexSpokenText + 1])
                print(arrayOfWordsForSpokenText[indexSpokenText + 2])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 4 { // the 5 last
                
                /*
                print("LAST 5")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText - 1])
                print(arrayOfWordsForSpokenText[indexSpokenText])
                print(arrayOfWordsForSpokenText[indexSpokenText + 1])
                print(arrayOfWordsForSpokenText[indexSpokenText + 2])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else { // NORMMMMMM
                
                /*
                print("USUAL")
                
                print("indexSourceText = \(indexSourceText)")
                print(arrayOfWordsForSourceText[indexSourceText])
                
                print("indexSpokenText = \(indexSpokenText)")
                print(arrayOfWordsForSpokenText[indexSpokenText - 1])
                print(arrayOfWordsForSpokenText[indexSpokenText])
                print(arrayOfWordsForSpokenText[indexSpokenText + 1])
                print(arrayOfWordsForSpokenText[indexSpokenText + 2])
                */
                
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 4
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            }
            
            //print(" . ")
            //print("The word '\(params[n].0)' is \(params[n].1) recognized")
            //print(" _______________________________ ")
        }
        
        return (params)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAuthToken()
        getRequestListOfAttempts()
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
        
        cell.scoreLabel.text = "Score for \(attempt.id) attempt (\(attempt.startTime.prefix(10)))"
        cell.correctSpokenTextLabel.text = "Pronounced text: " + String(format: "%.2f", attempt.correctness * 100) + " %"
        cell.correctPausesLabel.text = "Correct pauses: " + String(format: "%.2f", attempt.averagePause) + " % of time"
        cell.speechSpeedLabel.text = "Speech speed: " + String(format: "%.1f", attempt.speakingRate) + " words per minute"
        
        //cell.vocabularyLevelLabel.text = checkVocabularyLevel(text: attempt.originalText)
        cell.vocabularyLevelLabel.text = "Vocabulary level: B2"
        
        if attempt.pitchVoicing < 0.5 {
            cell.pitchLabel.text = "The speech is dominated by the low tone"
        } else {
            cell.pitchLabel.text = "The speech is dominated by the high tone"
        }
        
        if attempt.jitter < 0.5 {
            cell.jitterLabel.text = "Prevalence of monotonous voices"
        } else {
            cell.jitterLabel.text = "Prevalence of variegated voices"
        }
        
        if attempt.shimmer < 0.5 {
            cell.shimmerLabel.text = "Minor changes in intonation"
        } else {
            cell.shimmerLabel.text = "Major changes in intonation"
        }
        
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
