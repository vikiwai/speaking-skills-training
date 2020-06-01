//
//  TextViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 22.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
        
    struct ConfigurationModel {
        public let mistakes: [(String, Bool)]
        public let correctness: String
    }
    
    var configurationModel: ConfigurationModel?
    
    @IBOutlet weak var correctnessLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var arrayOfMistakes: [(String, Bool)]!
    
    private func setViewElements() {
        guard let configurationModel = self.configurationModel else { return }
        self.arrayOfMistakes = configurationModel.mistakes
        self.correctnessLabel.text = configurationModel.correctness
        self.texty()
    }
    
    public func setConfigurationModel(configurationModel: ConfigurationModel) {
        self.configurationModel = configurationModel
    }
    
    func texty() {
        for item in stride(from: 0, to: arrayOfMistakes.count - 5, by: 5){
                   let value = Int.random(in: item..<item+5)
                   arrayOfMistakes[value].1 = false
        }
        
        let mutableString = NSMutableAttributedString()
        var itemMutableString = NSMutableAttributedString()
        var spaceMutableString = NSMutableAttributedString()
        
        spaceMutableString = NSMutableAttributedString(string: " " as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
        for item in arrayOfMistakes {
            if item.1 == true {
                itemMutableString = NSMutableAttributedString(string: item.0 as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
                itemMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 0, length: item.0.count))
            } else {
                itemMutableString = NSMutableAttributedString(string: item.0 as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
                itemMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: item.0.count))
            }
            
            mutableString.append(itemMutableString)
            mutableString.append(spaceMutableString)
        }
        
        textView.attributedText = mutableString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewElements()
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
