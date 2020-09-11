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

    
    private lazy var carTextFieldView: LXCarTextFieldView = {
        var carTextFieldView = LXCarTextFieldView()
//        carTextFieldView.backgroundColor = UIColor.green
        carTextFieldView.delegate = self
        carTextFieldView.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
        
        return carTextFieldView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carTextFieldView.set(placeholder: "请输入车牌号", placeholderColor: "e2e2e2")
        view.addSubview(carTextFieldView)    
        carTextFieldView.paddingEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
        
        self.view.backgroundColor = UIColor.white
        
        
        carTextFieldView.setHandle { (textStr) in
            print("--------\(textStr)")
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("-=-=-=--=-=-=-=\(carTextFieldView.textStr)==\(carTextFieldView.isValidCarid())")
        
        carTextFieldView.isResignFirstResponder()
    }

}

extension ViewController: LXCarTextFieldViewDelegate {
    
    func carTextFieldView(textStr: String) {
                print("=======\(textStr)")

    }
   
}


