//
//  ViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 21.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Authorization")
            self.present(newViewController, animated: true, completion: nil)
        }
    }


}

