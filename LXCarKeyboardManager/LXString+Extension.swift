//
//  LXString+Extension.swift
//  LXCarKeyboardModule
//
//  Created by XL on 2020/9/10.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 验证车牌号
extension String {
    
    ///判断是否是合法的车牌号
    ///"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}"
    public func isFinishValidCarid() -> Bool {
        let pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}[A-Z0-9挂学警港澳]{1}$"
        return verification(pattern: pattern)
    }
    
    ///验证字符串匹配结果是否符合要求, 返回Bool值
    private func verification(pattern: String) -> Bool {
        return (matching(pattern: pattern)?.count ?? -1) > 0
    }
    
    
    ///获取匹配结果的数组
    private func matching(pattern: String,
                          options: NSRegularExpression.Options = .caseInsensitive) -> [NSTextCheckingResult]? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let results = regex?.matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, self.count))
        return results
    }
    
    /// 返回字符串子串
    internal func substring(to index: Int) -> String {
        return substring(from: 0, to: index)
    }
    
    /// 返回字符串子串
    ///
    /// - Parameters:
    ///   - sIndex: 开始位置
    ///   - eIndex: 结束位置
    internal func substring(from sIndex: Int, to eIndex: Int) -> String {
        if sIndex < eIndex && eIndex < self.count && sIndex >= 0 {
            let startIndex = self.index(self.startIndex, offsetBy: sIndex)
            let endIndex = self.index(self.startIndex, offsetBy: eIndex)
            return String(self[startIndex..<endIndex])
        }else{
            return self
        }
    }
}
