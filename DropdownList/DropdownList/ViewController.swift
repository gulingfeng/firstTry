//
//  ViewController.swift
//  DropdownList
//
//  Created by gulingfeng on 14-9-21.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var button = UIButton()

    var myData = ["apple","orange","pineapple","grape","pear","peach","blueberry","blackberry"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var dd = Dropdown(frame: CGRect(x: 20, y: 20, width: 100, height: 200))
        //dd.options = myData
        dd.initDropDown(20, y: 20, width: 100, height: 20,options: myData)
        self.view.addSubview(dd)
        
        button.frame = CGRect(x: 120, y: 20, width: 100, height: 50)
        button.backgroundColor = UIColor.blackColor()
        button.addTarget(self, action: "testButton", forControlEvents: .TouchUpInside)
        //self.view.addSubview(button)
        
    }

    func testButton()
    {
        println("tset button")
        button.setTitle("change", forState: .Normal)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

