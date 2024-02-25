//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Саша Восколович on 25.02.2024.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var question: String = ""
    private var options: [String] = []
    
    convenience init(question: String, options: [String]) {
        self.init()
        self.question = question
        self.options = options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if #available(iOS 14, *) {
            var content = cell.defaultContentConfiguration()
            content.text = options[indexPath.row]
            cell.contentConfiguration = content
            
        } else {
            cell.textLabel?.text = options[indexPath.row]
        }
        return cell
    }
}
