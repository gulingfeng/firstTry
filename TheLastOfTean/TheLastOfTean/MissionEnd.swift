//
//  MissionEnd.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-11-5.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

import UIKit

class MissionEnd: SceneViewController {
    
    var info = UILabel()
    var dayLabel = UILabel()
    var propertys = [SceneWebLabel]()
    var actionButton = UIButton()
    var walkButton = UIButton()
    var chatButton = UIButton()
    var cheerButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back_fire.png"))
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
        
        info.textAlignment = .Center
        info.frame = CGRect(x: appFrame.x*0.03, y: appFrame.y*0.85, width: appFrame.width*0.98, height: appFrame.height*0.15)
        self.view.addSubview(info)
        
        println(info.font)
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        //dayLabel.font = UIFont.systemFontOfSize(15)
        dayLabel.frame = CGRect(x: appFrame.x*0.021, y: appFrame.y*0.021, width: appFrame.width*0.2, height:appFrame.height*0.10)
        self.view.addSubview(dayLabel)
        
        
        actionButton.layer.borderWidth = 1;
        actionButton.layer.borderColor = UIColor.blackColor().CGColor
        actionButton.layer.cornerRadius = 5;
        actionButton.backgroundColor = UIColor.whiteColor()
        actionButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        actionButton.frame = CGRect(x: appFrame.x*0.85, y: appFrame.y*0.03, width: appFrame.width*0.10, height: appFrame.height*0.05)
        actionButton.addTarget(self, action: "endDay", forControlEvents: .TouchUpInside)
        actionButton.setTitle("休息", forState: .Normal)
        self.view.addSubview(actionButton)
        
        
        walkButton.layer.borderWidth = 1;
        walkButton.tag = 1
        walkButton.layer.borderColor = UIColor.blackColor().CGColor
        walkButton.layer.cornerRadius = 5;
        walkButton.backgroundColor = UIColor.whiteColor()
        walkButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        walkButton.frame = CGRect(x: appFrame.x*0.15, y: appFrame.y*0.50, width: appFrame.width*0.15, height: appFrame.height*0.05)
        walkButton.addTarget(self, action: "operation:", forControlEvents: .TouchUpInside)
        walkButton.setTitle("随便走走", forState: .Normal)
        self.view.addSubview(walkButton)
        
        chatButton.layer.borderWidth = 1;
        chatButton.tag = 2
        chatButton.layer.borderColor = UIColor.blackColor().CGColor
        chatButton.layer.cornerRadius = 5;
        chatButton.backgroundColor = UIColor.whiteColor()
        chatButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        chatButton.frame = CGRect(x: appFrame.x*0.45, y: appFrame.y*0.50, width: appFrame.width*0.15, height: appFrame.height*0.05)
        chatButton.addTarget(self, action: "operation:", forControlEvents: .TouchUpInside)
        chatButton.setTitle("聊天", forState: .Normal)
        self.view.addSubview(chatButton)
        
        cheerButton.layer.borderWidth = 1;
        cheerButton.tag = 3
        cheerButton.layer.borderColor = UIColor.blackColor().CGColor
        cheerButton.layer.cornerRadius = 5;
        cheerButton.backgroundColor = UIColor.whiteColor()
        cheerButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        cheerButton.frame = CGRect(x: appFrame.x*0.75, y: appFrame.y*0.50, width: appFrame.width*0.15, height: appFrame.height*0.05)
        cheerButton.addTarget(self, action: "operation:", forControlEvents: .TouchUpInside)
        cheerButton.setTitle("鼓舞士气", forState: .Normal)
        self.view.addSubview(cheerButton)
        
    }
    
    func operation(sender:UIButton)
    {
        var types = [EventType]()
        switch sender.tag
        {
            case 1:
                types = [EventType.Chat]
            case 2:
                types = [EventType.Chat]
            case 3:
                types = [EventType.Chat]
            default:
                GameUtil.shared.printDebugInfo("wrong sender tag:\(sender.tag)")
        }
        GameUtil.shared.initEventList(types)
        var event = GameUtil.shared.getEventFromList()
        if event != nil
        {
            var sceneID = event!.startSceneID
            //scenes = GameUtil.shared.loadScene()!
            //println(scene)
            if scenes.count>0
            {
                var scene = scenes[sceneID]
                GameUtil.shared.showScene(scene!, vc: self)
            }
        }
    }
    
    func endDay()
    {
        //self.view.removeFromSuperview()
        GameBasicInfo.shared.currentTurn++
        var dayStart = ViewController()
        self.presentViewController(dayStart, animated: true, completion: nil)
        self.view.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    
    
    
}