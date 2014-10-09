//
//  ViewController.swift
//  ButtonDropDown
//
//  Created by gulingfeng on 14-10-8.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var selectedOption = UIButton()
    var options = [UIButton]()
    var showed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var basicFrame = CGRect(x: 50, y: 50, width: 100, height: 20)
        selectedOption.frame = CGRect(x: basicFrame.minX, y: basicFrame.minY, width: basicFrame.width, height: 20)
        selectedOption.layer.borderWidth = 1;
        selectedOption.layer.borderColor = UIColor.blackColor().CGColor
        //selectedOption.layer.cornerRadius = 5;
        selectedOption.addTarget(self, action: "dropdownlist:", forControlEvents: .TouchUpInside)
        var dropdown = ButtonDropDown(frame: basicFrame)
        //dropdown.initOptions([("清剿僵尸",1),("打扫卫生",2),("聊天",3),("休息",4)])
        self.view.addSubview(dropdown)

        for i in 1...4
        {
            var button = UIButton()
            button.frame = CGRect(x: 50, y: i*20+50-(i*1), width: 100, height: 20)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.tag = i
            button.addTarget(self, action: "selectOption:", forControlEvents: .TouchUpInside)
            button.hidden = true
            options.append(button)
            //self.view.addSubview(button)
        }
    }

    func dropdownlist(sender:UIButton)
    {
        
        for button in options
        {
            button.hidden = showed
        }
        showed = !showed

    }
    func selectOption(sender:UIButton)
    {
        println(sender.tag)
        selectedOption.setTitle("\(sender.tag)", forState: .Normal)
        selectedOption.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

