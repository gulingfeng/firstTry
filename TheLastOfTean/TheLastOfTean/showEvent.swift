//
//  showEvent.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-27.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

import UIKit

class showEvent: UIViewController {
    
    var mainBase = MainBase.shared
    var info = UILabel()
    var dayLabel = UILabel()
    var missionOption = ["采集食物","清剿僵尸","打扫基地","休息"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = UIScreen.mainScreen().applicationFrame
        mainBack.frame = CGRect(x: appFrame.minX, y: appFrame.minY, width: appFrame.width, height: appFrame.height)
        self.view.addSubview(mainBack)
        println("showEvent appFrame: \(appFrame)")
        println("showEvent bounds: \(UIScreen.mainScreen().bounds)")
        
        info.text = "食物: \(mainBase.food)  物资: \(mainBase.supply)  防御: \(mainBase.defend)  安全: \(mainBase.security)  卫生: \(mainBase.health)  幸存者: \(mainBase.character)"
        info.frame = CGRect(x: appFrame.minX+80, y: appFrame.maxY-40, width: 500, height: 20)
        self.view.addSubview(info)
        
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        dayLabel.frame = CGRect(x: appFrame.minX+15, y: appFrame.minY+10, width: 100, height:8)
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
        
        for i in 1...2
        {
            var img = UIImageView(image: UIImage(named: "human_\(i).png"))
            var x = 45
            var y = 35
            var width = 94
            var height = 200
            img.frame = CGRect(x: (i-1)*100+x, y: y, width: width, height: height)
            self.view.addSubview(img)
            
            var dd = Dropdown(frame: CGRect(x: (i-1)*100+x, y: 100, width: 90, height: 400))
            dd.initDropDown(0, y: 100, width: 90, height: 20,options: missionOption,id: i)
            self.view.addSubview(dd)
            GameUtil.shared.printDebugInfo(dd.frame)
            GameUtil.shared.printDebugInfo(img.frame)
        }
        
        var lable = UILabel()
        lable.text = "----基地概况----"
        lable.frame = CGRect(x: appFrame.maxX/2-50, y: appFrame.maxY-80, width: 200, height: 50)
        self.view.addSubview(lable)
        
        
        
        
    }

    func startMission(){
        var doMission = DoMission()
        self.presentViewController(doMission, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        var appFrame = UIScreen.mainScreen().applicationFrame

        info.text = "食物: \(mainBase.food)  物资: \(mainBase.supply)  防御: \(mainBase.defend)  安全: \(mainBase.security)  卫生: \(mainBase.health)  幸存者: \(mainBase.character)"
        
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        
    }
    
}