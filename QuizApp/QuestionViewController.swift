//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Саша Восколович on 25.02.2024.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    private var question: String = ""
    
    convenience init(question: String) {
        self.init()
        self.question = question
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
    }
}
