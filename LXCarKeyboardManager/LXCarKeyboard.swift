//
//  LXDarkModeManager.swift
//  LXCarKeyboardModule
//
//  Created by XL on 2020/9/10.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXDarkModeManager
import LXFitManager

/// 回调协议
public protocol LXCarKeyboardDelegate: AnyObject {
    func carKeyboardDidChangeWithText(textStr: String) -> ()
}

public class LXCarKeyboard: UIView {
    
    public weak var delegate: LXCarKeyboardDelegate?
    
    private var textField = UITextField()
    private var provinceDatas = [String]()
    private var numDatas = [String]()
    private let provinceInputView = UIView()
    private let numInputView = UIView()
    private let model = LXCarKeyboardModel()

    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        provinceDatas = model.keyboardProvinceDatas()
        numDatas = model.keyboardNumDatas()
        self.bounds = model.backgroundViewFrame()
        setInputView()
        NotificationCenter.default.addObserver(self, selector: #selector(beginEditing(noti:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 键盘通知
    @objc private func beginEditing(noti: NSNotification) {
        let theTextField = noti.object as! UITextField
        if theTextField.inputView == self {
            textField = theTextField
            setKeyboardHidden()
        }
    }

    /// 创建界面
    private func setInputView() {
        //创建输入子界面
        provinceInputView.frame = model.keyboardViewFrame()
        numInputView.frame = model.keyboardViewFrame()
        provinceInputView.backgroundColor = UIColor(hex: "F0F0F0")
        numInputView.backgroundColor =  UIColor(hex: "F0F0F0")
        addSubview(provinceInputView)
        addSubview(numInputView)
        
        setProvinceInputViewBtn()
        setNumInputViewBtn()
        setKeyboardHidden()
    }
    
    ///排列省按钮位置
    private func setProvinceInputViewBtn() {
        for i in 0..<provinceDatas.count {
            let btn: UIButton = UIButton(type: .custom)
            provinceInputView.addSubview(btn)
            btn.backgroundColor = UIColor.white
            btn.setTitle(provinceDatas[i], for: .normal)
            btn.setTitleColor(UIColor(hex: "263245"), for: .normal)
            btn.setTitleColor(UIColor(hex: "FFAC54"), for: .highlighted)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16).fitFont
            btn.accessibilityIdentifier = provinceDatas[i]
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            btn.layer.cornerRadius = 3
            btn.tag = i + 10
            //位置排列
            var horizontal: Int = 0
            var vertical: Int = 0
            if i < 20 {
                horizontal = i % 10
                vertical = i / 10
            } else if i >= 20 && i < 28 {
                horizontal = i % 10 + 1
                vertical = 2
            } else {
                horizontal = (i + 2) % 10 + 2
                vertical = 3
            }
            setBtnFrame(btn: btn, horizontal: horizontal, vertical: vertical)
        }
        setChangeAndDeleteBtnInView(inView: provinceInputView, titleStr: "A", tag: 8)
    }
    
    
    ///排列字母和数字按钮位置
    private func setNumInputViewBtn() {
        for i in 0..<numDatas.count {
            let btn: UIButton = UIButton(type: .custom)
            numInputView.addSubview(btn)
            btn.backgroundColor = UIColor.white
            btn.setTitle(numDatas[i], for: .normal)
            btn.setTitleColor(UIColor(hex: "263245"), for: .normal)
            btn.setTitleColor(UIColor(hex: "FFAC54"), for: .highlighted)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16).fitFont
            btn.accessibilityIdentifier = numDatas[i]
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            btn.layer.cornerRadius = 3
            btn.tag = i + 100
            //位置排列
            var horizontal: Int = 0
            var vertical: Int = 0
            if i < 30 {
                 horizontal = i % 10
                 vertical = i / 10
            } else {
                 horizontal = i % 10 + 2
                 vertical = 3
            }
            setBtnFrame(btn: btn, horizontal: horizontal, vertical: vertical)
        }
        setChangeAndDeleteBtnInView(inView: numInputView, titleStr: "省", tag: 98)
    }
    
    /// 设置按钮位置
    private func setBtnFrame(btn: UIButton, horizontal: Int, vertical: Int) {
        btn.frame = CGRect(x: (model.btnWidthSpace + model.btnWidth) * CGFloat(horizontal) + model.btnWidthSpace,
                           y: (model.btnHeightSpace + model.btnHeight) * CGFloat(vertical) + model.btnHeightSpace,
                           width: model.btnWidth,
                           height: model.btnHeight)
    }
    
    ///添加切换和删除按钮
    private func setChangeAndDeleteBtnInView(inView: UIView, titleStr: String, tag: Int) {
        //切换按钮
        let changeBtn: UIButton = UIButton(type: .custom)
        inView.addSubview(changeBtn)
        changeBtn.addTarget(self, action: #selector(changeClick(sender:)), for: .touchUpInside)
        changeBtn.setTitle(titleStr, for: .normal)
        changeBtn.setTitleColor(UIColor.white, for: .normal)
        changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16).fitFont
        changeBtn.frame = CGRect(x: model.btnWidthSpace,
                                 y: (model.btnHeightSpace + model.btnHeight) * 3 + model.btnHeightSpace,
                                 width: model.btnWidth + model.btnWidthSpace,
                                 height: model.btnHeight)
        changeBtn.backgroundColor = UIColor(hex: "FFAC54")
        changeBtn.layer.cornerRadius = 3
        changeBtn.tag = tag
        //删除按钮
        let deleteBtn: UIButton = UIButton(type: .custom)
        inView.addSubview(deleteBtn)
        deleteBtn.addTarget(self, action: #selector(deleteClick(sender:)), for: .touchUpInside)
        deleteBtn.frame = CGRect(x: (model.btnWidthSpace + model.btnWidth) * 9,
                                 y: (model.btnHeightSpace + model.btnHeight) * 3 + model.btnHeightSpace,
                                 width: model.btnWidth + model.btnWidthSpace,
                                 height: model.btnHeight)
        deleteBtn.backgroundColor = UIColor.white
        
        if let path = Bundle(for: LXCarKeyboard.self).path(forResource: "LXKeyboard", ofType: "bundle") {
            deleteBtn.setImage(UIImage(contentsOfFile: path + "/LXCarKeyboardBack.png"), for: .normal)
        }
        deleteBtn.layer.cornerRadius = 3
        let deleteBtnWidth: CGFloat = 18
        let deleteBtnHeight: CGFloat = 34 * 18 / 45
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: (model.btnHeight - deleteBtnHeight) / 2.0,
                                                 left: (model.btnWidth + model.btnHeightSpace - deleteBtnWidth) / 2.0,
                                                 bottom: (model.btnHeight - deleteBtnHeight) / 2.0,
                                                 right: (model.btnWidth + model.btnWidthSpace - deleteBtnWidth) / 2.0)
        deleteBtn.tag = tag + 1
    }
    
    /// 判断两种类型键盘hiden  汉字和字母与数字
    private func setKeyboardHidden() {
        if textField.isKind(of: UITextField.self) {
            provinceInputView.isHidden = ((textField.text?.lengthOfBytes(using: String.Encoding.utf8)) != 0)
            numInputView.isHidden = !provinceInputView.isHidden
           
        } else {
             //默认隐藏字母数字键盘
            numInputView.isHidden = true
            provinceInputView.isHidden = false
        }
    }
    
    ///中间内容选择按钮
    @objc private func btnClick(sender: UIButton) {
        if textField.isKind(of: UITextField.self) {
            var textStr: String = textField.text ?? ""
            textStr.append(sender.accessibilityIdentifier ?? "")
            textField.text = textStr
            
            if sender.tag < 100 && ((textField.text?.count) != nil) {
                //默认输入省后 切换输入数字和字母
                numInputView.isHidden = false
                provinceInputView.isHidden = true
            }
            delegate?.carKeyboardDidChangeWithText(textStr: textField.text ?? "")
        }
    }
    
    ///转换界面按钮点击事件
    @objc private func changeClick(sender: UIButton) {
        provinceInputView.isHidden = !provinceInputView.isHidden
        numInputView.isHidden = !numInputView.isHidden
    }
    
    ///删除按钮点击事件
    @objc private func deleteClick(sender: UIButton) {
        if textField.isKind(of: UITextField.self) {
            var textStr: String = textField.text ?? ""
            if textStr.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                textStr = (textStr as NSString).replacingCharacters(in: NSRange(location: textStr.count - 1, length: 1), with: "")
            }
            textField.text = textStr
            if textField.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                //默认无任何输入时显示省简称选择界面
                provinceInputView.isHidden = false
                numInputView.isHidden = true
            }
            delegate?.carKeyboardDidChangeWithText(textStr: textField.text ?? "")
        }
    }
}
