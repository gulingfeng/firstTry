//
//  DropDownButton.swift
//  ButtonDropDown
//
//  Created by gulingfeng on 14-10-9.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

class DropDownButton: UIButton,UIGestureRecognizerDelegate
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        var temp = UITapGestureRecognizer(target: self, action: "onclick")
        temp.delegate = self
        self.addGestureRecognizer(temp)
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        println("in dropdownbutton gestureRecognizer")
        return true
    }
    
    func onclick()
    {
        println("onlcick")
    }
}