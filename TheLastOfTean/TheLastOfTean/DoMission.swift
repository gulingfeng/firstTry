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
    
    var currentSceneID = 1
    var scenes: Scene!
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
        //self.view.addSubview(dayLabel)
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.maxX-100, y: appFrame.minY+10, width: 60, height: 20)
        button.addTarget(self, action: "startMission", forControlEvents: .TouchUpInside)
        button.setTitle("出发", forState: .Normal)
        //self.view.addSubview(button)
   
        var dialogBack = UIImageView(image: UIImage(named: "test.png"))
        dialogBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.maxY-60, width:appFrame.width-10, height: 50)
        dialogBack.alpha = 0.5
        //self.view.addSubview(dialogBack)
        scenes = loadScene()
        //println(scene)
        if scenes != nil && scenes.sceneDetails.count>0
        {
            var details = scenes!.sceneDetails
            for detail in details
            {
                if detail.sceneID != 1
                {
                    continue
                }
                var resource: UIView
                var resDef = detail.resource
                var label: SceneLabel
                switch resDef.type
                {
                    case .button:
                        var button = SceneButton()
                        button.layer.borderWidth = 1;
                        button.layer.borderColor = UIColor.blackColor().CGColor
                        button.layer.cornerRadius = 5;
                        button.backgroundColor = UIColor.whiteColor()
                        button.setTitle(resDef.content, forState: .Normal)
                        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                        button.globalID = resDef.globalID
                        button.tag = detail.nextSceneID
                        button.selfDelete = resDef.selfDelete
                        button.addTarget(self, action: "nextScene:", forControlEvents: .TouchUpInside)
                        resource = button
                    case .image:
                        var image = SceneImageView(image: UIImage(named: resDef.content))
                        image.globalID = resDef.globalID
                        image.selfDelete = resDef.selfDelete
                        resource = image
                    case .label:
                        label = SceneLabel()
                        label.text = resDef.content
                        label.globalID = resDef.globalID
                        label.selfDelete = resDef.selfDelete
                        resource = label
                    default:
                        label = SceneLabel()
                        label.globalID = resDef.globalID
                        label.selfDelete = resDef.selfDelete
                        label.text = "unknow type"
                }
                resource.frame = CGRect(x: detail.resource.positionX, y: detail.resource.positionY, width: detail.resource.width, height: detail.resource.height)
                self.view.addSubview(resource)
            }
        }
        
    }
    
    func nextScene(sender: UIButton)
    {
        println(sender.tag)
        var sceneDetail = scenes.sceneDetails[currentSceneID - 1 ]
        for obj in self.view.subviews
        {
            if let subview =  obj as? SceneButton
            {
                println("SceneButton")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
                
            }else if let subview = obj as? SceneImageView{
                println("SceneImage")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
            }else if let subview = obj as? SceneLabel{
                println("label")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
            }
            //println(self.view.subviews)
        }
        if scenes != nil && scenes.sceneDetails.count>0
        {
            var details = scenes!.sceneDetails
            for detail in details
            {
                if detail.sceneID != sender.tag
                {
                    continue
                }
                var resource: UIView
                var resDef = detail.resource
                var label: SceneLabel
                switch resDef.type
                    {
                case .button:
                    var button = SceneButton()
                    button.layer.borderWidth = 1;
                    button.layer.borderColor = UIColor.blackColor().CGColor
                    button.layer.cornerRadius = 5;
                    button.backgroundColor = UIColor.whiteColor()
                    button.setTitle(resDef.content, forState: .Normal)
                    button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                    button.globalID = resDef.globalID
                    button.tag = detail.nextSceneID
                    button.selfDelete = resDef.selfDelete
                    button.addTarget(self, action: "nextScene:", forControlEvents: .TouchUpInside)
                    resource = button
                case .image:
                    var image = SceneImageView(image: UIImage(named: resDef.content))
                    image.globalID = resDef.globalID
                    image.selfDelete = resDef.selfDelete
                    resource = image
                case .label:
                    label = SceneLabel()
                    label.text = resDef.content
                    label.globalID = resDef.globalID
                    label.selfDelete = resDef.selfDelete
                    resource = label
                default:
                    label = SceneLabel()
                    label.globalID = resDef.globalID
                    label.selfDelete = resDef.selfDelete
                    label.text = "unknow type"
                }
                resource.frame = CGRect(x: detail.resource.positionX, y: detail.resource.positionY, width: detail.resource.width, height: detail.resource.height)
                self.view.addSubview(resource)
            }
        }
        
        
    }
    
    func startMission(){
        
    }
    func loadScene()->Scene?
    {
        println("start load scene")
        
        let db = DBUtilSingleton.shared.connection!
        
        if db.open()
        {
            println("open db ok")
        }else{
            println("open db failed")
            return nil
        }
        let querySql = "select * from scene_detail a, scene_resource b where a.resource_id=b.global_id"
        var result = db.executeQuery(querySql, withArgumentsInArray: nil)
        var sceneDetails = [SceneDetail]()
        var scenes = Scene()
        while result.next()
        {
            
            var resource = SceneResource(globalID: result.longForColumn("global_id"), type: result.longForColumn("type"), content: result.stringForColumn("content"), positionX: result.doubleForColumn("position_x"), positionY: result.doubleForColumn("position_y") , width: result.doubleForColumn("width") , height: result.doubleForColumn("height") , alpha: result.doubleForColumn("alpha") , countTouch: result.boolForColumn("count_touch"), touchCount: result.longForColumn("touch_count") , selfDelete: result.longForColumn("self_delete"))
            
            var sceneDetail = SceneDetail(sceneID: result.longForColumn("scene_id"), resource: resource, action: result.stringForColumn("action"), nextSceneID: result.longForColumn("next_scene_id"), rewardGroup: result.longForColumn("reward_group"))
            
            scenes.addSceneDetail(sceneDetail)

            //println(sceneDetail)
        }
        //println(scenes)
        if db.close()
        {
            println("close db ok")
        }else{
            println("close db failed")
        }
        return scenes
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}