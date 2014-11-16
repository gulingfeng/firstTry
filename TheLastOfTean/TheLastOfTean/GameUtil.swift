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
    var appFrame: AppFrame!
    var allScenes = [Int:Scene]()
    var eventList = NSMutableArray(array: [Event]())
    var currentEventID = 0
    var missionCharacter = [Character]()
    override init()
    {
        super.init()
        allScenes = loadScene()!

        if getGameStatus("debug") == "Y"
        {
            isDebug = true
        }else{
            isDebug = false
        }
        var tempFrame = UIScreen.mainScreen().bounds
        if tempFrame.width > tempFrame.height
        {
            appFrame = AppFrame(x: tempFrame.maxX,y: tempFrame.maxY,width: tempFrame.width,height: tempFrame.height)
        }else{
            appFrame = AppFrame(x: tempFrame.maxY,y: tempFrame.maxX,width: tempFrame.height,height: tempFrame.width)
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
            events.append(Event(eventType:resultSet.longForColumn("event_type"),eventID: resultSet.longForColumn("event_id"),startSceneID: resultSet.longForColumn("start_scene_id"),probability: resultSet.longForColumn("probability")))
        }
        return events
    }
    func loadScene()->[Int:Scene]?
    {
        println("start load scene")
        
        let querySql = "select a.global_id as detail_global,b.global_id as res_global,a.touch_count as detail_touch_count,b.touch_count as res_touch_count,* from scene_detail a, scene_resource b where a.resource_id=b.global_id order by a.sequence"
        var result = DBUtilSingleton.shared.executeQuerySql(querySql)
        var sceneDetails = [SceneDetail]()
        var scenesMap = [Int:Scene]()
        while result.next()
        {
            
            var resource = SceneResource(globalID: result.longForColumn("res_global"), type: result.longForColumn("type"), content: result.stringForColumn("content"), positionX: result.doubleForColumn("position_x"), positionY: result.doubleForColumn("position_y") , width: result.doubleForColumn("width") , height: result.doubleForColumn("height") , alpha: result.doubleForColumn("alpha") , countTouch: result.boolForColumn("count_touch"), touchCount: result.longForColumn("res_touch_count") , selfDelete: result.longForColumn("self_delete"))
            
            var sceneDetail = SceneDetail(globalID: result.longForColumn("detail_global"), sceneID: result.longForColumn("scene_id"), resource: resource, action: result.stringForColumn("action"), nextScene: result.longForColumn("next_scene"), nextSceneType: result.stringForColumn("next_scene_type"), rewardGroup: result.longForColumn("reward_group"), touchCount: result.longForColumn("detail_touch_count"))
            sceneDetail.recordTouch = result.longForColumn("record_touch")
            sceneDetail.maxEnemy = result.longForColumn("max_enemy")
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
                switch detail.action
                {
                case .add:
                    addNewSceneResource(detail, vc: vc)
                case .delete:
                    deleteOldSceneResource(detail, vc: vc)
                case .replace:
                    printDebugInfo("replace scene resource")
                default:
                    printDebugInfo("unknow resource process")
                }
                
            }
        }
    }
    func finghtEnemy(detail:SceneDetail) -> String
    {
        if detail.maxEnemy>0
        {
            let random = arc4random_uniform(UInt32(detail.maxEnemy))+1
            var power = 100
            for i in 0..<GameUtil.shared.missionCharacter.count
            {
                power = power + 100
            }
            
            return "消灭\(random)个僵尸"

        }
        return ""
    }
    func addNewSceneResource(detail:SceneDetail, vc: SceneViewController)
    {
        var label: SceneLabel
        var resource: UIView
        var resDef = detail.resource
        var rewardText = ""
        var hasReward = false
        var hasItemReward = false
        var itemText = ""
        var t = [(Int,Int)]()
        var map = [Int:[(Int,Int)]]()
        var fightText = finghtEnemy(detail)
        

        if detail.rewardGroup > 0
        {
            var rewards = getReward(detail.rewardGroup)
            hasReward = true
            for reward in rewards
            {
                var type = RewardType.fromRaw(reward.rewardType)!
                switch type
                {
                    case .MainBaseObj:
                        printDebugInfo(reward)
                        var change = reward.value>=0 ? "+\(reward.value)":"\(reward.value)"
                        let sql = "update main_base_object set value=value\(change) where object_id=\(reward.objectID)"
                        DBUtilSingleton.shared.executeUpdateSql(sql)
                        let textSql = "select * from object_type a, main_base_object b where a.type=b.object_type and b.object_id=\(reward.objectID)"
                        let temp = DBUtilSingleton.shared.executeQuerySql(textSql)
                        if temp.next()
                        {
                            rewardText = rewardText + temp.stringForColumn("desc") + ":\(reward.value) "
                        }
                    case .CharacterStatus:
                        var character = reward.objectID
                        var property = reward.objectProperty
                        var value = reward.value
                        var temp = map[character]
                        if temp != nil
                        {
                            temp?.append((property,value))
                            map[character] = temp
                        }else{
                            map[character] = [(property,value)]
                        }
                        
                        let sql = "select * from character_property a where property_id=\(reward.objectProperty)"
                        var result = DBUtilSingleton.shared.executeQuerySql(sql)
                        if result.next()
                        {
                            var desc = "value"
                            desc = reward.value>=0 ? "\(desc)=\(desc)+\(reward.value)":"\(desc)=\(desc)\(reward.value)"
                            let updateSql = "update character set \(desc) where character_id=\(reward.objectID) and property_id=\(property)"
                            DBUtilSingleton.shared.executeUpdateSql(updateSql)
                        }
                    case .Item:
                        hasItemReward = true
                        var sql="select * from item where item_id=\(reward.value) and property=\(EventPropertyType.Desc.toRaw())"
                        var itemResult = DBUtilSingleton.shared.executeQuerySql(sql)
                        if itemResult.next()
                        {
                            if itemText == ""
                            {
                                itemText = itemText + itemResult.stringForColumn("value")
                            }else{
                                itemText = itemText + "," + itemResult.stringForColumn("value")
                            }
                        }
                    
                    default:
                        println("in reward default")
                    
                }
            }
            
            for id in map.keys
            {
                var tempResult = DBUtilSingleton.shared.executeQuerySql("select value from character where character_id=\(id) and property_id=1")
                if tempResult.next()
                {
                    rewardText = rewardText + tempResult.stringForColumn("value") + " "
                }
                var obj = map[id]!
                for i in 0 ..< obj.count
                {
                    var property = obj[i].0
                    var value = obj[i].1
                    tempResult = DBUtilSingleton.shared.executeQuerySql("select gui_desc from character_property where property_id=\(property)")
                    if tempResult.next()
                    {
                        rewardText = rewardText + tempResult.stringForColumn("gui_desc")
                    }
                    rewardText = rewardText + (value>=0 ? "+\(value)":"\(value)") + " "
                }
            }
            if hasItemReward
            {
                rewardText = rewardText + " 道具：" + itemText
            }
            printDebugInfo(rewardText)

        }
        
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
            button.selfDelete = resDef.selfDelete
            button.sceneDetailGlobalID = detail.globalID
            button.currentSceneID = detail.sceneID
            button.nextSceneType = detail.nextSceneType
            button.nextScene = detail.nextScene
            button.recordTouch = detail.recordTouch
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
            if fightText != ""
            {
                label.text = label.text! + "\r" + fightText
            }
            if hasReward
            {
                label.text = label.text! + "\r" + rewardText
            }
            label.numberOfLines = 0
            label.globalID = resDef.globalID
            label.selfDelete = resDef.selfDelete
            resource = label
        case .webLabel:
            var webLabel = SceneWebLabel()
            var text = resDef.content
            if fightText != ""
            {
                text = text + "\r" + fightText
            }
            if hasReward
            {
                text = text + "<br>" + rewardText
            }
            webLabel.loadHTMLString(text, baseURL: nil)
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
        var appFrame = GameUtil.shared.appFrame
        var x = CGFloat(appFrame.x*CGFloat(detail.resource.positionX/100))
        var y = CGFloat(appFrame.y*CGFloat(detail.resource.positionY/100))
        var width = CGFloat(appFrame.width*CGFloat(detail.resource.width/100))
        var height = CGFloat(appFrame.height*CGFloat(detail.resource.height/100))
        resource.frame = CGRect(x: x, y: y, width: width, height: height)
        vc.view.addSubview(resource)
        
        
    }
    func deleteOldSceneResource(detail:SceneDetail, vc: SceneViewController)
    {
        var resDef = detail.resource
        var id = resDef.globalID
        for obj in vc.view.subviews
        {
            if let subview =  obj as? SceneButton
            {
                //println("SceneButton")
                if subview.globalID == id
                {
                    subview.removeFromSuperview()
                }
                
            }else if let subview = obj as? SceneImageView{
                //println("SceneImage")
                if subview.globalID == id
                {
                    subview.removeFromSuperview()
                }
            }else if let subview = obj as? SceneLabel{
                //println("label")
                if subview.globalID == id
                {
                    subview.removeFromSuperview()
                }
            }else if let subview = obj as?SceneWebLabel{
                if subview.globalID == id
                {
                    subview.removeFromSuperview()
                }
            }
            //println(self.view.subviews)
        }

    }
    func nextScene(sender:SceneButton)
    {
        var vc = sender.sceneViewController!
        var scenes = allScenes
        println("nextScene sceneDetailGlobalID:\(sender.sceneDetailGlobalID)")
        //let sql = "update scene_detail set touch_count=ifnull(touch_count,0)+1 where global_id = \(sender.sceneDetailGlobalID!)"
        var result = getNextSceneID(sender.globalID!, nextScene: sender.nextScene!, nextSceneType: sender.nextSceneType!, recordTouch: sender.recordTouch!)
        //DBUtilSingleton.shared.executeUpdateSql(sql)
        
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
        
        if result < 0
        {
            var event = getEventFromList()
            if event != nil
            {
                result = event!.startSceneID
            }else{
                var sceneEndType = SceneEndType.fromRaw(result)!
                switch sceneEndType
                {
                    case .EventEnd:
                        return
                    case .MissionEnd:
                        GameBasicInfo.shared.gameStage = SceneEndType.MissionEnd
                        vc.dismissViewControllerAnimated(true, completion: nil)
                    case .DayEnd:
                        GameBasicInfo.shared.gameStage = SceneEndType.DayEnd
                        vc.dismissViewControllerAnimated(true, completion: nil)
                    default:
                        vc.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
        
        scene = scenes[result]
        
        if scene?.sceneDetails.count>0
        {
            GameUtil.shared.showScene(scene!, vc: vc)
        }
    }
    func getNextSceneID(resourceGlobalID:Int,nextScene:Int,nextSceneType: NextSceneType,recordTouch:Int)->Int
    {
        var result = 0

        switch nextSceneType
        {
            case .sceneID:
                result = nextScene
                println("directly:\(result)")
                return result
            case .calcSceneID:
                
                var touchCount = 0
                var sql = "select * from scene_detail where global_id=\(resourceGlobalID)"
                var tempResult = DBUtilSingleton.shared.executeQuerySql(sql)
                if tempResult.next()
                {
                    touchCount = tempResult.longForColumn("touch_count")
                }
                println("touchCount:\(touchCount)")
                
                let random = arc4random_uniform(100)+1
                
                var isReset = false
                let querySql = "select * from calc_scene_id where calc_id=\(nextScene)"
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
                            isReset = true
                            DBUtilSingleton.shared.executeUpdateSql("update scene_detail set touch_count=0 where global_id=\(resourceGlobalID)")
                        }
                        break
                    }else{
                        temp = temp+finalProbability
                    }
                    
                }
                if (recordTouch == 1 && !isReset)
                {
                    let sql = "update scene_detail set touch_count=ifnull(touch_count,0)+1 where global_id = \(resourceGlobalID)"
                    var result = DBUtilSingleton.shared.executeUpdateSql(sql)
                }
                
            case .eventType:
                printDebugInfo("event type next scene")
            default:
                result = 0
        }
        
        printDebugInfo("random:\(result)")
       
        
        return result
    }
    
    func loadCharacter()->[Character]
    {
        var character = [Character]()
        let sql = "select distinct character_id from character"
        var result = DBUtilSingleton.shared.executeQuerySql(sql)
        while result.next()
        {
            character.append(Character(id: result.longForColumn("character_id")))
            //var property = Property(propertyID: i)
            //property.stringValue = value
            //character.propertyList.append(property)
        }
        return character
    }
    
    func loadMainBase()->MainBase
    {
        var mainBaseObjs = [MainBaseObj]()
        let sql = "select * from object_type a,main_base_object b where a.type=b.object_type"
        var result = DBUtilSingleton.shared.executeQuerySql(sql)
        while result.next()
        {
            var objType = ObjectType(typeID: result.longForColumn("type"), desc: result.stringForColumn("desc"))
            mainBaseObjs.append(MainBaseObj(objType: objType, objID: result.longForColumn("object_id"), value: result.longForColumn("value")))
        }
        var character = loadCharacter()
        MainBase.shared.character = character
        MainBase.shared.objs = mainBaseObjs
        return MainBase.shared
    }
    
    func getReward(groupID: Int)->[Reward]
    {
        var rewards = [Reward]()
        var sql = "select * from reward_group where group_id=\(groupID)"
        var result = DBUtilSingleton.shared.executeQuerySql(sql)
        while result.next()
        {
            var max = result.longForColumn("max_value")>=0 ? result.longForColumn("max_value"):-1*result.longForColumn("max_value")
            var min = result.longForColumn("min_value")>=0 ? result.longForColumn("min_value"):-1*result.longForColumn("min_value")
            var temp = max+1-min
            var rewardType = RewardType.fromRaw(result.longForColumn("reward_type"))
            var objID = result.longForColumn("object_id")
            var value = min
            var random = arc4random_uniform(UInt32(temp))
            value = value + Int(random)
            if result.longForColumn("min_value")<0
            {
                value = -1*value
            }
            switch rewardType!
            {
                case .CharacterStatus,.MainBaseObj:
                    rewards.append(Reward(groupID: result.longForColumn("group_id"),rewardType: result.longForColumn("reward_type"),objectID: result.longForColumn("object_id"), objectProperty: result.longForColumn("object_property"), value: Int(value)))
                case .Item:
                    if value>0
                    {
                        var items = [Item]()
                        sql="select a.item_id,b.value from reward_item_group a,item b where item_group_id=\(objID) and a.item_id=b.item_id and b.property=\(EventPropertyType.Desc.toRaw())"
                        var itemResult = DBUtilSingleton.shared.executeQuerySql(sql)
                        while itemResult.next()
                        {
                            items.append(Item(itemID: itemResult.longForColumn("item_id"), desc: itemResult.stringForColumn("value")))
                        }
                        for i in 1...value
                        {
                            random = arc4random_uniform(UInt32(items.count))
                            let item = items[Int(random)]
                            rewards.append(Reward(groupID: result.longForColumn("group_id"),rewardType: result.longForColumn("reward_type"),objectID: result.longForColumn("object_id"), objectProperty: result.longForColumn("object_property"), value: item.itemID))
                            updateItemInventory(item.itemID, count: 1)
                        }
                    }
                default:
                    printDebugInfo("reward type is unknow")
            }
            
            
        }
        printDebugInfo(rewards)
        return rewards
    }
    
    func initEventList(eventTypes:[EventType])
    {
        currentEventID = 0
        var sql = ""
        var events = [Event]()
        for eventType in eventTypes
        {
            events = getCombinableEvent(eventType)
            eventList.addObjectsFromArray(events)
        }
        var event = getNotCombinableEvent(eventTypes)
        if event != nil
        {
            eventList.addObject(event!)
        }
        
    }
    
    func getEvent(eventType:EventType, combinType:CombinType,probability:Int=0) -> [Event]
    {
        var events = [Event]()
        var sql = "select * from event where event_type=\(eventType.toRaw()) and combinable=\(combinType.toRaw()) and (repeatable=1 or (repeatable!=1 and happened_count<1))"
        if probability==100
        {
            sql = sql + " and probability=100 "
        }
        var resultSet = DBUtilSingleton.shared.executeQuerySql(sql)
        while resultSet.next()
        {
            events.append(Event(eventType:resultSet.longForColumn("event_type"),eventID: resultSet.longForColumn("event_id"),startSceneID: resultSet.longForColumn("start_scene_id"),probability: resultSet.longForColumn("probability")))
        }
        return events
    }
    
    func getCombinableEvent(eventType:EventType)->[Event]
    {
        var events = getEvent(eventType, combinType: .Combinable)
        var result = [Event]()
        for event in events
        {
            var random = Int(arc4random_uniform(100)+1)
            if random<=event.probability
            {
                if checkEventCondition(event)
                {
                    result.append(event)
                }
            }
        }
        return result
    }
    
    func getNotCombinableEvent(eventTypes:[EventType])->Event?
    {
        for eventType in eventTypes
        {
            var events = getEvent(eventType, combinType: .NotCombinable,probability: 100)
            for i in 0..<events.count
            {
                var event = events[0]
                if checkEventCondition(event)
                {
                    return event
                }
            }
        }
        for eventType in eventTypes
        {
            var events = getEvent(eventType, combinType: .NotCombinable)
            for i in 0..<events.count
            {
                var seed = Int(arc4random_uniform(UInt32(events.count-i)))
                var event = events[seed]
                var random = Int(arc4random_uniform(100)+1)
                if random<=event.probability
                {
                    if checkEventCondition(event)
                    {
                        return event
                    }
                }
                events[seed] = events[events.count-i-1]
            }
        }
        return nil
    }
    
    func checkEventCondition(event:Event)->Bool
    {
        var id = event.eventID
        var sql = "select * from event_condition where event_id=\(id)"
        var condition = DBUtilSingleton.shared.executeQuerySql(sql)
        var pass = true
        while condition.next()
        {
            var conditionType = EventConditionType.fromRaw(condition.longForColumn("condition_type"))!
            var conditionObjID = condition.longForColumn("condition_obj_id")
            var conditionValue = condition.stringForColumn("condition_value")
            var conditionPropertyID = condition.longForColumn("condition_property_id")
            switch conditionType
                {
            case .MainBaseProperty:
                sql = "select * from main_base_object where object_id=\(conditionObjID) and value\(conditionValue)"
            case .CertainCharacterProperty:
                sql = "select * from character where character_id=\(conditionObjID) and property_id=\(conditionPropertyID) and value\(conditionValue)"
            case .Item:
                sql = "select * from item where item_id=\(conditionObjID) and property=\(EventPropertyType.Inventory.toRaw()) and value\(conditionValue)"
            case .AnyCharacterProperty:
                sql = "select * from character where property_id=\(conditionPropertyID) and value\(conditionValue)"
            }
            var temp = DBUtilSingleton.shared.executeQuerySql(sql)
            if !temp.next()
            {
                pass = false
                break
            }
        }
        
        return pass
    }
    
    func getEventFromList()->Event?
    {
        if currentEventID != 0
        {
            updateEventHappenedCount(currentEventID, count: 1)
        }
        if eventList.count>0
        {
            var event = eventList[0] as Event
            eventList.removeObjectAtIndex(0)
            currentEventID = event.eventID
            return event
        }else{
            currentEventID = 0
            return nil
        }
    }
    
    func updateEventHappenedCount(eventID:Int, count:Int)
    {
        let sql = "update event set happened_count=happened_count+1 where event_id=\(eventID)"
        DBUtilSingleton.shared.executeUpdateSql(sql)
    }
    
    func updateItemInventory(itemID:Int,count:Int)
    {
        let sql = "update item set value=value+\(count) where item_id=\(itemID) and property=\(EventPropertyType.Inventory.toRaw())"
        DBUtilSingleton.shared.executeUpdateSql(sql)
    }
    
    func calculateMissionResult()
    {
        printDebugInfo("calc mission result")
    }
}

class AppFrame
{
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    init(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)
    {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
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
    var gameStage = SceneEndType.DayStart
    var missionEnd = false
    var dayEnd = false
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
