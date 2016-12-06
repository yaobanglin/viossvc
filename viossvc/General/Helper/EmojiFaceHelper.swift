//
//  EmojiFaceHelper.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/6.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class EmojiFaceHelper: NSObject {
    static let shared  = EmojiFaceHelper()
    
    private var m_faceArray  = [String]()
    func getFaceArray() -> [String] {
        return m_faceArray
    }
    
    
    override init() {
       super.init()
        initFace()

    }
    
   private func EMOJI_CODE_TO_SYMBOL(x : Int) -> uint {
        let sym = (((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24
        return   uint(sym)
    }
    
   private func MULITTHREEBYTEUTF16TOUNICODE(x : Int , y : Int) -> Int {
        return (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000
    }
    

    private   func xStringReplaceEmoji(array: [Int]) -> NSString {
        
        
        let bytes = array
        let data = NSData(bytes: bytes, length: bytes.count)
        let dogString = NSString.init(data: data, encoding: NSUTF8StringEncoding)
        return dogString == nil ? "" : dogString!
    }
    
    private   func emojiStringArray(array: [[Int]]) -> [String] {
        
        var  emojiArray = [String]()
        for bytes in array {
            emojiArray.append(xStringReplaceEmoji(bytes) as String)
        }
        return emojiArray
    }

    private   func initFace() {
        for i  in 0x1F600...0x1F69F {
            if i < 0x1F641 || ( i > 0x1F644 && i < 0x1F650) || i > 0x1F67F {
                var sym = EMOJI_CODE_TO_SYMBOL(i)
                
               let emojiT = NSString(bytes: &sym , length: sizeofValue(sym), encoding: NSUTF8StringEncoding)
                m_faceArray.append(emojiT as! String)
            }
        }
    
        for i  in 1...m_faceArray.count / 27 {
            m_faceArray.insert("", atIndex: 27 * i + i - 1)
        }
    
    }

}
