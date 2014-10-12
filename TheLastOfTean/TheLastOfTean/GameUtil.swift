//
//  GameUtil.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-10-7.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit
class GameUtil: NSObject
{
    class var shared:GameUtil {
    return Inner.instance
    }

    struct Inner {
        static var instance = GameUtil()
        
    }
    
    var isDebug: Bool!
    override init()
    {
        super.init()
        if getGameStatus("debug") == "Y"
        {
            isDebug = true
        }else{
            isDebug = false
        }
    }
    func updateGameStatus(name:String, value:String)->Bool?
    {
        var sql = "update game_status set value='\(value)' where name='\(name)'"
        var result = DBUtilSingleton.shared.executeUpdateSql(sql)
        return result
    }
    func getGameStatus(name:String)->String?
    {
        var sql = "select value from game_status where name='\(name)'"
        var dbResult = DBUtilSingleton.shared.executeQuerySql(sql)
        var result:String?
        if dbResult.next()
        {
            result = dbResult.stringForColumn("value")
        }
        
        return result
    }
    func printDebugInfo<T>(obj:T)
    {
        if isDebug.boolValue
        {
            println(obj)
        }
    }
    func initGame()
    {
        
    }
    
    func getAllEvent()->[Event]
    {
        var events = [Event]()
        var resultSet = DBUtilSingleton.shared.executeQuerySql("select * from event")
        while resultSet.next()
        {
            events.append(Event(eventID: resultSet.longForColumn("event_id"),startSceneID: resultSet.longForColumn("start_scene_id")))
        }
        return events
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
    func showScene(scene: Scene, vc: SceneViewController)
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
                    button.currentSceneID = detail.sceneID
                    button.sceneViewController = vc
                    button.addTarget(self, action: "nextScene:", forControlEvents: .TouchUpInside)
                    resource = button
                case .image:
                    var image = SceneImageView(image: UIImage(named: resDef.content))
                    image.alpha = CGFloat(resDef.alpha)
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
                    webLabel.loadHTMLString(resDef.content, baseURL: nil)
                    webLabel.opaque = 0
                    webLabel.backgroundColor = UIColor.clearColor()
                    webLabel.scrollView.scrollEnabled = false
                    webLabel.globalID = resDef.globalID
                    webLabel.selfDelete = resDef.selfDelete
                    resource = webLabel
                default:
                    label = SceneLabel()
                    label.globalID = resDef.globalID
                    label.selfDelete = resDef.selfDelete
                    label.text = "unknow type"
                }
                var appFrame = UIScreen.mainScreen().applicationFrame
                var x = CGFloat(appFrame.maxX*CGFloat(detail.resource.positionX/100))
                var y = CGFloat(appFrame.maxY*CGFloat(detail.resource.positionY/100))
                var width = CGFloat(appFrame.width*CGFloat(detail.resource.width/100))
                var height = CGFloat(appFrame.height*CGFloat(detail.resource.height/100))
                resource.frame = CGRect(x: x, y: y, width: width, height: height)
                vc.view.addSubview(resource)
            }
        }
    }
    func nextScene(sender:SceneButton)
    {
        GameUtil.shared.printDebugInfo(sender.sceneViewController)
        var vc = sender.sceneViewController!
        var scenes = vc.scenes
        println("nextScene sceneDetailGlobalID:\(sender.sceneDetailGlobalID)")
        let sql = "update scene_detail set touch_count=ifnull(touch_count,0)+1 where global_id = \(sender.sceneDetailGlobalID!)"
        var result = DBUtilSingleton.shared.executeUpdateSql(sql)
        
        var scene = scenes[sender.currentSceneID!]
        var sceneDetail = scene?.sceneDetails
        for obj in vc.view.subviews
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
            }else if let subview = obj as?SceneWebLabel{
                if subview.selfDelete == 1
                {
                    subview.removeFromSuperview()
                }
            }
            //println(self.view.subviews)
        }
        if sender.tag == -1
        {
            return
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
            GameUtil.shared.showScene(scene!, vc: vc)
        }
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

        return result
    }
    
    
}

class GameBasicInfo
{
    class var shared:GameBasicInfo {
    return Inner.instance
    }
    
    struct Inner {
        static var instance = GameBasicInfo()
        
    }
    
    let totalTurn:Int
    var currentTurn:Int
    init()
    {
        var result = DBUtilSingleton.shared.executeQuerySql("select value from game_status where name='total_turn'")
        if result.next()
        {
            self.totalTurn = result.longForColumn("value")
        }else{
            self.totalTurn = 150
        }
        result = DBUtilSingleton.shared.executeQuerySql("select value from game_status where name='current_turn'")
        if result.next()
        {
            self.currentTurn = result.longForColumn("value")
        }else{
            self.currentTurn = 1
        }
    }
    
    func nextTurn()
    {
        self.currentTurn++
        DBUtilSingleton.shared.executeUpdateSql("update game_status set value='\(self.currentTurn)' where name='current_turn'")
    }
    
    
}
