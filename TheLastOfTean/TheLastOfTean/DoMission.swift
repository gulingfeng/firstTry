//
//  DoMission.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-27.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

import UIKit

class DoMission: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = UIScreen.mainScreen().applicationFrame
        mainBack.frame = CGRect(x: appFrame.minX, y: appFrame.minY, width: appFrame.width, height: appFrame.height)
        self.view.addSubview(mainBack)
        println(appFrame)
        println(UIScreen.mainScreen().bounds)
        
        var newDayBack = UIImageView(image: UIImage(named: "mission_back.jpg"))
        newDayBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.minY+5, width:appFrame.width-10, height: appFrame.height-10)
        self.view.addSubview(newDayBack)
        var dayLabel = UILabel()
        dayLabel.text = "清剿僵尸任务"
        dayLabel.frame = CGRect(x: appFrame.minX+220, y: appFrame.minY+10, width: 200, height:8)
        self.view.addSubview(dayLabel)
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.maxX-100, y: appFrame.minY+10, width: 60, height: 20)
        button.addTarget(self, action: "startMission", forControlEvents: .TouchUpInside)
        button.setTitle("出发", forState: .Normal)
        self.view.addSubview(button)
   
        var dialogBack = UIImageView(image: UIImage(named: "test.png"))
        dialogBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.maxY-60, width:appFrame.width-10, height: 50)
        dialogBack.alpha = 0.5
        self.view.addSubview(dialogBack)
        
        
    }
    
    func startMission(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}