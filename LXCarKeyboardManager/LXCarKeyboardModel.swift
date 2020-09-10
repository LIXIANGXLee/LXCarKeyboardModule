//
//  LXCarKeyboardModel.swift
//  LXCarKeyboardModule
//
//  Created by XL on 2020/9/10.
//  Copyright © 2020 李响. All rights reserved.
//


import UIKit

class LXCarKeyboardModel: NSObject {

    var btnHeight: CGFloat = 0.0 //按钮高度
    var btnWidth: CGFloat = 0.0 //按钮宽度
    var btnHeightSpace: CGFloat = 0.0 //按钮上下间隔
    var btnWidthSpace: CGFloat = 0.0 //按钮左右间隔
    
    override init() {
        super.init()
        configData()
    }
    
    /// 设置btn大小数据
    private func configData() {
        
        if #available(iOS 11.0, *) {
            let edge = UIApplication.shared.delegate?.window??.safeAreaInsets
            let screenWidth = UIScreen.main.bounds.width
            let left = edge?.left ?? 0
            let right = edge?.right ?? 0
            btnWidth = (screenWidth - left - right - 5 * 11.0) / 10.0
        }
        btnHeight = 45.0
        btnWidthSpace = 5
        btnWidth = (UIScreen.main.bounds.width - 5 * 11.0) / 10.0
        btnHeightSpace = (216 - btnHeight * 4) / 5.0
    }

    func keyboardNumDatas() -> [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    }
    
    func keyboardProvinceDatas() -> [String] {
        return  ["京", "沪", "津", "渝", "冀", "晋", "蒙", "辽", "吉", "黑", "苏", "浙", "皖", "闽", "赣", "鲁", "豫", "鄂", "湘", "粤", "桂", "琼", "川", "贵", "云", "藏", "陕", "甘", "青", "宁", "新", "台", "澳", "港"]
    }
    
    /// 键盘背景视图
    func keyboardViewFrame() -> CGRect {
        var theViewFrame: CGRect = CGRect.zero
        
        if #available(iOS 11.0, *) {
            let edge = UIApplication.shared.delegate?.window??.safeAreaInsets
            let bottom = edge?.bottom ?? 0
            theViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216 + bottom)
        } else {
            theViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        }
        
        return theViewFrame
    }
    
    /// 父视图
    func backgroundViewFrame() -> CGRect {
        var theViewFrame: CGRect = CGRect.zero
        
        if #available(iOS 11.0, *) {
            let edge = UIApplication.shared.delegate?.window??.safeAreaInsets
            let bottom = edge?.bottom ?? 0
            theViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216 + bottom)
        } else {
            theViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        }
        
        return theViewFrame
    }
    
}
