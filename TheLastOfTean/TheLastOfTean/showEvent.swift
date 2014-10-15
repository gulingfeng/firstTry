//
//  showEvent.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-27.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

import UIKit

class showEvent: SceneViewController {
    
    var info = UILabel()
    var dayLabel = UILabel()
    var missionOption = ["采集食物","清剿僵尸","打扫基地","休息"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = GameUtil.shared.appFrame
        mainBack.frame = CGRect(x: appFrame.x*0.01, y: appFrame.y*0.01, width: appFrame.width*0.98, height: appFrame.height*0.98)
        self.view.addSubview(mainBack)
        println("showEvent appFrame: \(appFrame)")
        println("showEvent bounds: \(UIScreen.mainScreen().bounds)")
        
        var infoBack = UIImageView(image: UIImage(named: "label_back.png"))
        infoBack.frame = CGRect(x: appFrame.x*0.02, y: appFrame.y*0.78, width:appFrame.width*0.96, height: appFrame.height*0.20)
        infoBack.alpha = 0.5
        self.view.addSubview(infoBack)
        var mainBase = GameUtil.shared.loadMainBase()
        var text = ""
        if mainBase.objs.count>0
        {
            for obj in mainBase.objs
            {
                var desc = obj.objType.desc
                var value = obj.value
                text = text + desc + ":" + String(value)
            }
        }
        //info.text = "食物: \(mainBase.food)  物资: \(mainBase.supply)  防御: \(mainBase.defend)  安全: \(mainBase.security)  卫生: \(mainBase.health)  幸存者: \(mainBase.character)"
        info.text = text
        info.textAlignment = .Center
        info.frame = CGRect(x: appFrame.x*0.03, y: appFrame.y*0.85, width: appFrame.width*0.98, height: appFrame.height*0.15)
        self.view.addSubview(info)

        println(info.font)
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        //dayLabel.font = UIFont.systemFontOfSize(15)
        dayLabel.frame = CGRect(x: appFrame.x*0.021, y: appFrame.y*0.021, width: appFrame.width*0.2, height:appFrame.height*0.10)
        self.view.addSubview(dayLabel)
        
        var lable = UILabel()
        lable.text = "----基地概况----"
        lable.frame = CGRect(x: appFrame.x*0.35, y: appFrame.y*0.78, width: appFrame.width*0.30, height: appFrame.height*0.09)
        self.view.addSubview(lable)
        
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.x*0.90, y: appFrame.y*0.03, width: appFrame.width*0.05, height: appFrame.height*0.05)
        button.addTarget(self, action: "startMission", forControlEvents: .TouchUpInside)
        button.setTitle("出发", forState: .Normal)
        self.view.addSubview(button)
        
        for i in 1...5
        {
            var img = UIImageView(image: UIImage(named: "human_\(i).png"))
            var x = appFrame.x*0.02
            var width = CGFloat(appFrame.width)/5-appFrame.x*0.01
            var y = appFrame.y*0.1
            var height = CGFloat(appFrame.height*2/3)
            img.frame = CGRect(x: CGFloat(x+CGFloat(i-1)*width), y: y, width: width, height: height)
            self.view.addSubview(img)
            var dd = Dropdown(frame: CGRect(x: CGFloat(x+CGFloat(i-1)*width), y: appFrame.y*0.6, width: width, height: appFrame.height*0.4))
            dd.initDropDown(CGFloat(0), y: y, width: width, height: appFrame.height*0.05,options: missionOption,id: i)
            self.view.addSubview(dd)
            GameUtil.shared.printDebugInfo(dd.frame)
            GameUtil.shared.printDebugInfo(img.frame)
        }
        
        
        
        var events = GameUtil.shared.getAllEvent()
        if events.count>0
        {
            var event = events[0]
            var sceneID = event.startSceneID
            scenes = GameUtil.shared.loadScene()!
            //println(scene)
            if scenes.count>0
            {
                var scene = scenes[sceneID]
                GameUtil.shared.showScene(scene!, vc: self)
            }
        }
        
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
        var appFrame = GameUtil.shared.appFrame

        var mainBase = MainBase.shared
        var text = ""
        if mainBase.objs.count>0
        {
            for obj in mainBase.objs
            {
                var desc = obj.objType.desc
                var value = obj.value
                text = text + desc + ":" + String(value) + " "
            }
        }
        info.text = text
        
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        
    }
    
    
}