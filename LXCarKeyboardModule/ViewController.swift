//
//  ViewController.swift
//  LXCarKeyboardModule
//
//  Created by XL on 2020/9/10.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXDarkModeManager
import LXCarKeyboardManager

class ViewController: UIViewController {
    private let carKeyboard = LXCarKeyboard()

    
    private lazy var carNumberTextField: UITextField = {
        var carNumberTextField = UITextField(frame: CGRect(x: 10, y: 100, width: 300, height: 40))
        carNumberTextField.placeholder = "请输入车牌号"
        carNumberTextField.font = UIFont.systemFont(ofSize: 18)
        carNumberTextField.textColor = UIColor(hex: "263245")
        carNumberTextField.clearButtonMode = .whileEditing
        carNumberTextField.inputView = carKeyboard
        
//        carNumberTextField.delegate = self
        return carNumberTextField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carKeyboard.delegate = self
        
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(carNumberTextField)
        
        
    }


}

extension ViewController: LXCarKeyboardDelegate {
    func carKeyboardDidChangeWithText(textStr: String) {
       
        print("=======\(textStr)")
    }
}


