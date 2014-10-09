//
//  ButtonDropDown.swift
//  ButtonDropDown
//
//  Created by gulingfeng on 14-10-8.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

enum popDirectionValue: Int
{
    case UP = 0
    case DOWN = 1
}
class ButtonDropDown: UIView
{
    var selectedOption = UIButton()
    var options = [UIButton]()
    var showed = false
    var popDirection = popDirectionValue.DOWN
    var minX: Double
    var minY: Double
    var width: Double
    var height: Double
    
    init(minX:Double, minY:Double, width:Double, height:Double, popDirection: popDirectionValue)
    {
        self.minX = minX
        self.minY = minY
        self.width = width
        self.height = height
        self.selectedOption.frame = CGRect(x: minX, y: minY, width: width, height: height)
        self.popDirection = popDirection
        super.init()

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initOptions(options:[(String,Int)])
    {

        for i in 0..<options.count
        {
            var option = options[i]
            var button = UIButton()
            var temp = self.height.advancedBy(5)
            println(temp)
            button.frame = CGRect(x: self.minX, y: self.height, width: width, height: height)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(option.0, forState: .Normal)
            
            
        }
    }
}