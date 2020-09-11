//
//  LXCarTextFieldView.swift
//  LXCarKeyboardManager
//
//  Created by XL on 2020/9/10.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager
import LXDarkModeManager

public typealias LXCarTextFieldViewCallBack = ((_ textStr: String) -> ())
public protocol LXCarTextFieldViewDelegate: AnyObject {
    func carTextFieldView(textStr: String)
}

public class LXCarTextFieldView: UIView {

    public weak var delegate: LXCarTextFieldViewDelegate?
    public var callBack: LXCarTextFieldViewCallBack?
    
    /// 外界为只读属性
    public private(set) var textStr: String = ""
    
    /// 设置左右内边距
    public var paddingEdgeInsets: UIEdgeInsets = .zero{
        didSet { setNeedsLayout() }
    }
    
    public var tintColorStr: String? {
        didSet {
            guard let tintColorStr = tintColorStr else { return }
            numberTextField.tintColor = UIColor(hex: tintColorStr)
        }
    }
    
    private lazy var carKeyboard: LXCarKeyboard = {
        let carKeyboard = LXCarKeyboard()
        carKeyboard.delegate = self
        return carKeyboard
    }()
    
     private lazy var numberTextField: UITextField = {
         var numberTextField = UITextField()
         numberTextField.clearButtonMode = .whileEditing
         numberTextField.delegate = self
         return numberTextField
    }()
    
    public init(_ frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        numberTextField.frame = CGRect(x: paddingEdgeInsets.left, y:  paddingEdgeInsets.top, width: bounds.width - paddingEdgeInsets.left - paddingEdgeInsets.right, height:  bounds.height - paddingEdgeInsets.top - paddingEdgeInsets.bottom)
    }
    
    public override var frame: CGRect {
        didSet {  setNeedsLayout() }
    }
}

//MARK: - private
extension LXCarTextFieldView {
    /// 初始化UI
    private func setUI() {
        
        addSubview(numberTextField)
        numberTextField.inputView = carKeyboard
        set(textFont: UIFont.systemFont(ofSize: 16).fitFont, textColor:  "263245")
    }
}


//MARK: - public
extension LXCarTextFieldView {
    
    /// 设置默认文案 和颜色
    public func set(placeholder: String, placeholderColor: String){
        
        guard let color = UIColor(hex: placeholderColor) else { return }
        numberTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    /// 设置文字颜色和大小
    public func set(textFont: UIFont, textColor: String){
        
        numberTextField.font = textFont
        numberTextField.textColor = UIColor(hex: textColor)
    }

    /// 判断是否为有效的车牌号码
    public func isValidCarid() -> Bool {
        return self.textStr.isFinishValidCarid()
    }
    
    /// 设置字符串回调
    public func setHandle(_ callBack: LXCarTextFieldViewCallBack?) {
        self.callBack = callBack
    }

    ///拉起键盘 第一响应
    public func isBecomeFirstResponder(){
        numberTextField.becomeFirstResponder()
    }
    
    ///退下键盘 失去第一响应
    public func isResignFirstResponder(){
          numberTextField.resignFirstResponder()
      }
}


//MARK: - LXCarKeyboardDelegate
extension LXCarTextFieldView: LXCarKeyboardDelegate {
    
    public func carKeyboardDidChangeWithText(textStr: String) {
        //长度限制
        if textStr.lengthOfBytes(using: String.Encoding.utf8) > 8 {
            numberTextField.text = textStr.substring(to: 8)
        }
        
        /// 属性赋值
        self.textStr = numberTextField.text ?? ""
        /// 字符串回调
        delegate?.carTextFieldView(textStr: self.textStr)
        self.callBack?(self.textStr)
    }
}

//MARK: - UITextFieldDelegate
extension LXCarTextFieldView: UITextFieldDelegate{
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.numberTextField.text = ""
        self.textStr = ""
        carKeyboard.delegate?.carKeyboardDidChangeWithText(textStr: self.textStr)
        return true
    }
}
