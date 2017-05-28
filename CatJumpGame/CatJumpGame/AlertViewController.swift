//
//  AlertViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 28/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    var alertType: AlertType?
    var transferCode = ""

    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func okayButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        if alertType == .success {
            alertLabel.text = "Your game transfer was successful!"
            alertLabel.font = UIFont(name: "BradyBunchRemastered", size: 20)
            yesButton.isHidden = true
            noButton.isHidden = true
        } else if alertType == .failed {
            alertLabel.text = "Oops! There seems to be a problem. Make sure your transfer code is correct and you have internet connection"
            alertLabel.font = UIFont(name: "BradyBunchRemastered", size: 20)
            yesButton.isHidden = true
            noButton.isHidden = true
        } else if alertType == .transfer {
            okButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
