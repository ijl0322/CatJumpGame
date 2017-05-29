//
//  SettingsViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

enum AlertType {
    case success
    case failed
    case transfer
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var gameTransferCodeLabel: UILabel!
    @IBOutlet weak var transferCodeTextField: UITextField!
    
    @IBAction func transferGame(_ sender: UIButton) {
        if let code = transferCodeTextField.text {
            let vc = storyboard?.instantiateViewController(withIdentifier:
                "alertViewController") as! AlertViewController
            
            vc.alertType = .transfer
            vc.transferCode = code
            
            self.present(vc, animated: false) {
                print("Detached presented")
            }
        }
    }
    
    @IBAction func showGameTransferCode(_ sender: UIButton) {
        gameTransferCodeLabel.text = UIDevice().identifierForVendor?.uuidString
        gameTransferCodeLabel.font = UIFont(name: "BradyBunchRemastered", size: 20)
        print("\(UIDevice().identifierForVendor?.uuidString ?? "No code")")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.delegate = self
        nickNameTextField.text = UserData.shared.nickName
        nickNameTextField.font = UIFont(name: "BradyBunchRemastered", size: 30)
    }
    
    func showAlert(type: AlertType) {
        let vc = storyboard?.instantiateViewController(withIdentifier:
            "alertViewController") as! AlertViewController
        
        vc.alertType = type
        
        self.present(vc, animated: false) {
            print("Detached presented")
        }
    }
}

extension SettingsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let text = textField.text {
            if textField.tag == 1 {
                print("Text Entered: \(text)")
                UserData.shared.changeNickname(name: text)
                
            }
        }
        return
    }
}

