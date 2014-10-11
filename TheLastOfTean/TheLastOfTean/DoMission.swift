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
    var scenes: [Int:Scene]!
    var mainBase = MainBase.shared
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = UIScreen.mainScreen().applicationFrame
        mainBack.frame = CGRect(x: appFrame.minX, y: appFrame.minY, width: appFrame.width, height: appFrame.height)
        self.view.addSubview(mainBack)
        println("DoMission appFrame: \(appFrame)")
        println("DoMission bounds: \(UIScreen.mainScreen().bounds)")
        
        var newDayBack = UIImageView(image: UIImage(named: "mission_back.jpg"))
        newDayBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.minY+5, width:appFrame.width-10, height: appFrame.height-10)
        //self.view.addSubview(newDayBack)
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
        button.frame = CGRect(x: appFrame.maxX-150, y: appFrame.minY+10, width: 100, height: 20)
        button.addTarget(self, action: "nextTurn", forControlEvents: .TouchUpInside)
        button.setTitle("返回基地", forState: .Normal)
   
        var dialogBack = UIImageView(image: UIImage(named: "test.png"))
        dialogBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.maxY-60, width:appFrame.width-10, height: 50)
        dialogBack.alpha = 0.5
        //self.view.addSubview(dialogBack)
        scenes = loadScene()
        //println(scene)
        if scenes != nil && scenes.count>0
        {
            var scene = scenes[1]
            showScene(scene!)
        }
        self.view.addSubview(button)

    }
    
    func getNextSceneID(sceneDetail: SceneDetail)->Int
    {
        let db = DBUtilSingleton.shared.connection!

        var result = 0
        if (sceneDetail.nextSceneType != nil)
        {
            switch sceneDetail.nextSceneType!
            {
                case .sceneID:
                    result = sceneDetail.nextScene
                    println("directly:\(result)")
                    return result
                case .calcSceneID:
                    
                    var touchCount = 0
                    var sql = "select * from scene_detail where global_id=\(sceneDetail.globalID)"
                    var tempResult = DBUtilSingleton.shared.executeQuerySql(sql)
                    if tempResult.next()
                    {
                        touchCount = tempResult.longForColumn("touch_count")
                    }
                    println("touchCount:\(touchCount)")
                    
                    let random = arc4random_uniform(100)+1
                    
                    let querySql = "select * from calc_scene_id where calc_id=\(sceneDetail.nextScene)"
                    var resultSet = DBUtilSingleton.shared.executeQuerySql(querySql)
                    var temp = 0 as UInt32
                    var resultSceneID = 0
                    while resultSet.next()
                    {
                        var calcID = resultSet.longForColumn("calc_id")
                        var sceneID = resultSet.longForColumn("scene_id")
                        var probability = resultSet.longForColumn("probability")
                        var probabilityAdj = resultSet.longForColumn("probability_adj")
                        var resetCount = resultSet.boolForColumn("reset_count")
                        
                        var finalProbability = probability + probabilityAdj*touchCount
                        if finalProbability<0
                        {
                            finalProbability = 0
                        }
                        println("finalProbability: \(finalProbability)")

                        if random > temp && random <= temp + finalProbability
                        {
                            result = sceneID
                            if resetCount
                            {
                                DBUtilSingleton.shared.executeUpdateSql("update scene_detail set touch_count=0 where global_id=\(sceneDetail.globalID)")
                            }
                            break
                        }else{
                            temp = temp+finalProbability
                        }
                        
                    }
                
                
                default:
                    result = 0
            }
        }
        println("random:\(result)")
        if result == 2
        {
            DBUtilSingleton.shared.count2++
        }else if result == 4
        {
            DBUtilSingleton.shared.count4++
        }else if result == 5
        {
            DBUtilSingleton.shared.count5++
        }
        println("count2:\(DBUtilSingleton.shared.count2) count4:\(DBUtilSingleton.shared.count4) count5:\(DBUtilSingleton.shared.count5)")
        /*
        if !db.close()
        {
            println("getNextSceneID close db failed")
        }
        */
        return result
    }
    
    func nextScene(sender: SceneButton)
    {
        //println(sender.tag)
        println("nextScene sceneDetailGlobalID:\(sender.sceneDetailGlobalID)")
        let sql = "update scene_detail set touch_count=ifnull(touch_count,0)+1 where global_id = \(sender.sceneDetailGlobalID!)"
        var result = DBUtilSingleton.shared.executeUpdateSql(sql)
        
        var scene = scenes[currentSceneID]
        var sceneDetail = scene?.sceneDetails
        for obj in self.view.subviews
        {
            if let subview =  obj as? SceneButton
            {
                //println("SceneButton")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
                
            }else if let subview = obj as? SceneImageView{
                //println("SceneImage")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
            }else if let subview = obj as? SceneLabel{
                //println("label")
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
            }
            //println(self.view.subviews)
        }
        scene = scenes[sender.tag]
        if sender.tag == 5
        {
            var mainBase = MainBase.shared
            mainBase.food+=10
            mainBase.supply+=5
        }
        if scene?.sceneDetails.count>0
        {
            showScene(scene!)
        }
        
        
    }
    
    func showScene(scene: Scene)
    {
        if scene.sceneDetails.count>0
        {
            var details = scene.sceneDetails
            for detail in details
            {
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
                    button.tag = getNextSceneID(detail)
                    button.selfDelete = resDef.selfDelete
                    button.sceneDetailGlobalID = detail.globalID
                    mainBase.touchRecord[detail.globalID] = detail
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
                case .webLabel:
                    var webLabel = SceneWebLabel()
                    
                    webLabel.globalID = resDef.globalID
                    webLabel.selfDelete = resDef.selfDelete
                    resource = webLabel
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
    func nextTurn(){
        GameBasicInfo.shared.nextTurn()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func loadScene()->[Int:Scene]?
    {
        println("start load scene")
        
        let querySql = "select a.global_id as detail_global,b.global_id as res_global,a.touch_count as detail_touch_count,b.touch_count as res_touch_count,* from scene_detail a, scene_resource b where a.resource_id=b.global_id"
        var result = DBUtilSingleton.shared.executeQuerySql(querySql)
        var sceneDetails = [SceneDetail]()
        var scenesMap = [Int:Scene]()
        while result.next()
        {
            
            var resource = SceneResource(globalID: result.longForColumn("res_global"), type: result.longForColumn("type"), content: result.stringForColumn("content"), positionX: result.doubleForColumn("position_x"), positionY: result.doubleForColumn("position_y") , width: result.doubleForColumn("width") , height: result.doubleForColumn("height") , alpha: result.doubleForColumn("alpha") , countTouch: result.boolForColumn("count_touch"), touchCount: result.longForColumn("res_touch_count") , selfDelete: result.longForColumn("self_delete"))
            
            var sceneDetail = SceneDetail(globalID: result.longForColumn("detail_global"), sceneID: result.longForColumn("scene_id"), resource: resource, action: result.stringForColumn("action"), nextScene: result.longForColumn("next_scene"), nextSceneType: result.stringForColumn("next_scene_type"), rewardGroup: result.longForColumn("reward_group"), touchCount: result.longForColumn("detail_touch_count"))
            
            var temp = scenesMap[sceneDetail.sceneID]
            if (temp != nil)
            {
                temp?.addSceneDetail(sceneDetail)
            }else{
                var scenes = Scene()
                scenes.addSceneDetail(sceneDetail)
                scenesMap[sceneDetail.sceneID] = scenes
            }

            //println(sceneDetail)
        }
        //println(scenes)

        //println(scenesMap)
        return scenesMap
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}