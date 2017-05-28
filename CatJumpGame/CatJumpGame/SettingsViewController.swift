//
//  SettingsViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var gameTransferCodeLabel: UILabel!
    @IBOutlet weak var transferCodeTextField: UITextField!
    
    @IBAction func transferGame(_ sender: UIButton) {
        if let code = transferCodeTextField.text {
            UserData.shared.updateFromTransfer(code: code)
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

