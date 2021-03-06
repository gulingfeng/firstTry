//
//  Scene.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-30.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

class Event: NilLiteralConvertible,Printable
{
    var eventType: Int
    var eventID: Int
    var startSceneID: Int
    var probability: Int
    var description: String { get
    {
        return "eventID:\(eventID)"
        }
    }
    required init(eventType:Int, eventID: Int, startSceneID: Int,probability:Int)
    {
        self.eventType = eventType
        self.eventID = eventID
        self.startSceneID = startSceneID
        self.probability = probability
    }
    
    /*
    required init()
    {
        self.triggerValue = ""
        self.eventID = 0
        self.eventType = 0
        self.probability = 0
        self.startSceneID = 0
        self.triggerType = 0
    }*/
    class func convertFromNilLiteral() -> Self
    {
        return self(eventType: 0, eventID: 0, startSceneID: 0, probability: 0)
    }

}
class CalcNextScene
{
    let calcID: Int
    let sceneID: Int
    let probability: Int
    let probabilityAdj: Int
    let resetCount: Bool
    let finalProbability: Int
    init(calcID: Int, sceneID: Int, probability: Int, probabilityAdj: Int,resetCount: Bool,touchCount: Int)
    {
        self.calcID = calcID
        self.sceneID = sceneID
        self.probability = probability
        self.probabilityAdj = probabilityAdj
        self.resetCount = resetCount
        finalProbability = probability + probabilityAdj*touchCount
    }
}
enum ActionType: String
{
    case add = "A"
    case delete = "D"
    case replace = "R"
}
enum NextSceneType: String
{
    case sceneID = "scene_id"
    case calcSceneID = "calc_id"
}
class Scene: Printable
{
    var sceneDetails: [SceneDetail]
    var description: String { get
                                {
                                    var desc = ""
                                    for sceneDetail in sceneDetails
                                    {
                                        desc = "\(desc+sceneDetail.description)\r\n"
                                    }
                                    return desc
                                }
                            }
    init()
    {
        self.sceneDetails = [SceneDetail]()
    }
    func addSceneDetail(sceneDetail:SceneDetail)
    {
        self.sceneDetails.append(sceneDetail)
    }
}
class SceneDetail: Printable
{
    let globalID: Int
    let sceneID: Int
    let resource: SceneResource
    let action: ActionType
    let nextScene: Int
    let rewardGroup: Int
    var nextSceneType: NextSceneType?
    var touchCount: Int
    var recordTouch = 0
    var description: String { get
                                {
                                    return "sceneID:\(sceneID),action:\(action),nextSceneID:\(nextScene),nextSceneType:\(nextSceneType),rewardGroup:\(rewardGroup),resource:\(resource),touchCount:\(touchCount) "
                                }
                            }
    
    init(globalID: Int, sceneID: Int, resource: SceneResource, action: String, nextScene: Int, nextSceneType: String?, rewardGroup: Int, touchCount: Int)
    {
        self.globalID = globalID
        self.sceneID = sceneID
        self.resource = resource
        self.action = ActionType.fromRaw(action)!
        self.nextScene = nextScene
        if nextSceneType != nil
        {
            self.nextSceneType = NextSceneType.fromRaw(nextSceneType!)
        }
        self.rewardGroup = rewardGroup
        self.touchCount = touchCount
    }
    
}

enum ResourceType: Int
{
    case image = 1;
    case label;
    case button;
    case webLabel;
}
class SceneResource:Printable
{
    let globalID:Int
    let type: ResourceType
    let positionX: Double
    let positionY: Double
    let width: Double
    let height: Double
    let alpha: Double
    let countTouch: Bool
    var touchCount: Int
    let selfDelete: Int
    let content: String
    var description: String { get
                                {
                                    return "globalID:\(globalID),type:\(type),positionX:\(positionX),positionY:\(positionY),width:\(width),height:\(height),alpha:\(alpha),countTouch:\(countTouch),touchCount:\(touchCount),selfDelete:\(selfDelete),content:\(content) "
                                }
                            }
    init(globalID:Int, type: Int, content: String, positionX: Double, positionY: Double, width: Double, height: Double, alpha: Double, countTouch: Bool, touchCount: Int, selfDelete: Int)
    {
        self.globalID = globalID
        self.type = ResourceType.fromRaw(type)!
        self.positionX = positionX
        self.positionY = positionY
        self.width = width
        self.height = height
        self.alpha = alpha
        self.countTouch = false
        self.touchCount = touchCount
        self.selfDelete = selfDelete
        self.content = content
    }
}


class SceneButton: UIButton
{
    var globalID: Int?
    var selfDelete: Int?
    var sceneDetailGlobalID: Int?
    var currentSceneID: Int?
    var sceneViewController: SceneViewController?
    var nextSceneType: NextSceneType?
    var nextScene: Int?
    var recordTouch: Int?
}

class SceneImageView: UIImageView
{
    var globalID: Int?
    var selfDelete: Int?
}

class SceneLabel: UILabel
{
    var globalID: Int?
    var selfDelete: Int?
}

class SceneWebLabel: UIWebView
{
    
    var globalID: Int?
    var selfDelete: Int?
}


class SceneViewController: UIViewController
{
    var scenes = GameUtil.shared.allScenes
}

class Reward: Printable
{
    var groupID: Int
    var rewardType: Int
    var objectID: Int
    var objectProperty: Int
    var value: Int
    init(groupID:Int, rewardType:Int, objectID:Int, objectProperty: Int, value:Int)
    {
        self.groupID = groupID
        self.rewardType = rewardType
        self.objectID = objectID
        self.objectProperty = objectProperty
        self.value = value
    }
    var description: String { get
    {
        return "reward groupID:\(groupID), type:\(rewardType), objectID:\(objectID), value:\(value)"
        }
    }
}
enum RewardType: Int
{
    case MainBaseObj = 1;
    case CharacterStatus;
    case Item;
}
enum CharacterProperty: Int
{
    case power = 1;
    case intelligence;
    case health;
    case loyalty;
}
class Item
{
    var itemID:Int
    var desc:String
    init(itemID:Int, desc:String)
    {
        self.itemID = itemID
        self.desc = desc
    }
}
enum EventPropertyType:Int
{
    case PropertyType=1;
    case Desc;
    case CharacterPropertyID;
    case Inventory;
}
enum EventType: Int
{
    case MainBase = 1;
    case Character;
    case Mission;
}
enum CombinType: Int
{
    case NotCombinable = 0;
    case Combinable = 1;
}
enum EventConditionType:Int
{
    case MainBaseProperty = 1;
    case CertainCharacterProperty;
    case AnyCharacterProperty;
    case Item;
}
enum SceneEndType:Int
{
    case DayStart = 0;
    case EventEnd = -1;
    case MissionEnd = -2;
    case DayEnd = -3;
}
