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
class ButtonDropDown: UIView, UIGestureRecognizerDelegate
{
    var selectedOption: UIButton
    var options = [UIButton]()
    var showed = false
    var popDirection = popDirectionValue.DOWN
    var minX: Double
    var minY: Double
    var width: Double
    var height: Double
    
    override init(frame: CGRect) {

        self.popDirection = .DOWN
        self.minX = Double(frame.minX)
        self.minY = Double(frame.minY)
        self.width = Double(frame.width)
        self.height = Double(frame.height)
        self.selectedOption = UIButton()
        super.init(frame: frame)
        self.selectedOption.frame = frame

        selectedOption.layer.borderWidth = 1;
        selectedOption.layer.borderColor = UIColor.blackColor().CGColor
        //self.selectedOption.addTarget(self, action: "onClickDropDown:", forControlEvents: .TouchUpInside)
        self.selectedOption.setTitle("select", forState: .Normal)
        self.selectedOption.setTitleColor(UIColor.blackColor(), forState: .Normal)

        var temp = UITapGestureRecognizer(target: self, action: "onClickDropDown")
        temp.delegate = self
        //selectedOption.addGestureRecognizer(temp)
        self.addGestureRecognizer(temp)
        //self.addSubview(self.selectedOption)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
    
        println("rec touh")
        return false
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
            button.frame = CGRect(x: self.minX, y: self.height*Double(i)-1+self.minY, width: width, height: height)
            button.tag = option.1
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(option.0, forState: .Normal)
            button.addTarget(self, action: "selectOption:", forControlEvents: .TouchUpInside)
            button.hidden = true
            self.addSubview(button)
            self.options.append(button)
            
        }
    }
    func onClickDropDown(sender:UIButton)
    {
        println("onclickdropdown")
        showOptions(sender)
    }
    
    func showOptions(sender:UIButton)
    {
        println(self.options)
        println(self.showed)
        for button in self.options
        {
            button.hidden = self.showed
        }
        self.showed = !self.showed
    }
    func selectOption(sender:UIButton)
    {
        println("select option \(sender.tag)")
        selectedOption.setTitle(sender.titleLabel?.text, forState: .Normal)
        selectedOption.tag = sender.tag
        showOptions(sender)
    }
}