//
//  LessonsTableViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 24.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class LessonsTableViewController: UITableViewController {

    // MARK: Properties
    
    var lessons: Array<Lesson> = Array();
    
    // MARK: Private methods
    
    private func loadSampleLessons() {
        
        guard let lesson1 = Lesson(number: 1, title: "Describe a leisure activity that you do with your family", category: "Family topic", level: "B2", description: "You should say: what activity it is, when you do it with your family, how much you enjoy it and explain how this is helpful for you and your family.", rules: "You will have to talk about the topic for one to two minutes. You have one minute to think about what you are going to say. You can make some notes to help you if you wish.", modelAnswer: "One of the great advantages of having a family with active family members is that they never really run out of ideas to spend and enjoy quality time by getting involved with different kinds of leisurely activities. I am lucky that I have one of those active families who never hesitate to enjoy different leisure activities whenever an opportunity arrives.") else {
            fatalError("Unable to instantiate lesson1")
        }
        
        guard let lesson2 = Lesson(number: 2, title: "Describe an experience when you played an indoor game with others", category: "Life topic", level: "B2", description: "You should say: when it was, what game you played, who you played with and explain how much you enjoyed playing this indoor game.", rules: "You will have to talk about the topic for one to two minutes. You have one minute to think about what you are going to say. You can make some notes to help you if you wish.", modelAnswer: "I never really thought that an indoor game could be as exciting as playing a game in the outdoor, and so I never really showed that much interest in it. But, one day about a couple of years ago, when one of my friends insisted that playing indoor table tennis was going to be really fun, I thought that it was worth giving a try.") else {
            fatalError("Unable to instantiate lesson2")
        }
        
        guard let lesson3 = Lesson(number: 3, title: "Describe some local news that people in your locality are interested in", category: "Social topic", level: "C1", description: "You should say: what the news is, how you know about this news, how the news involves your locality and explain why people in your area are interested in the news.", rules: "You will have to talk about the topic for one to two minutes. You have one minute to think about what you are going to say. You can make some notes to help you if you wish.", modelAnswer: "I live in a rather quiet and small town, and nothing much really happens in it except some occasional bird watching (yes, many foreign birds visit it) and spending some lazy times in some local café and restaurants. Luckily, however, there is a local newspaper in my town for us to read, which provides us with local news about what happens in and around our town. So, today, I would like to talk about one such news which the local people are really interested in.") else {
            fatalError("Unable to instantiate lesson3")
        }
        
        lessons += [lesson1, lesson2, lesson3]
        
        // MARK: TO-DO AUTO INIT
        
        /*
        let countOfLessons = 3
        
        repeat {
            guard let lesson = Lesson(title: <#T##String#>, category: <#T##String#>, level: <#T##String#>) else {
                fatalError("Unable to instantiate meal1")
            }
        } while lessons.count != countOfLessons
        */
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Load sample data.
        loadSampleLessons()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LessonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LessonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LessonTableViewCell.")
        }

        // Configure the cell.
        
        let lesson = lessons[indexPath.row]
        
        cell.topicNumber = lesson.number
        cell.titleLabel!.text = lesson.title
        cell.categoryLabel!.text = lesson.category
        cell.levelLable!.text = lesson.level
        cell.topicDescription = lesson.description
        cell.topicRules = lesson.rules
        cell.topicModelAnswer = lesson.modelAnswer
        
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

extension LessonsTableViewController: LessonTableViewCellDelegate {
    func lessonTableViewCell(_ cell: LessonTableViewCell, number: Int, title: String, category: String, level: String, description: String, rules: String, modelAnswer: String) {
        let sb = UIStoryboard(name: "Account", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Topic") as! TopicViewController
        vc.modalPresentationStyle = .fullScreen
        vc.setConfigurationModel(configurationModel: .init(topicsNumber: number, titleText: title, categoryText: category, levelText: level, desriptionText: description, rulesText: rules, modelAnswerText: modelAnswer))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
