//
//  AccountViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 22.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registrationDateLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBAction func didTappedLogOutButton(_ sender: Any) {
    }
    
    @IBAction func didTappedHelpButton(_ sender: Any) {
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
