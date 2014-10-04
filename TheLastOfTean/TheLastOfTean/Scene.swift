//
//  Scene.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-30.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

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
    let sceneID: Int
    let resource: SceneResource
    let action: ActionType
    let nextScene: Int
    let rewardGroup: Int
    let nextSceneType: NextSceneType
    var touchCount: Int
    var description: String { get
                                {
                                    return "sceneID:\(sceneID),action:\(action),nextSceneID:\(nextScene),nextSceneType:\(nextSceneType),rewardGroup:\(rewardGroup),resource:\(resource),touchCount:\(touchCount) "
                                }
                            }
    
    init(sceneID: Int, resource: SceneResource, action: String, nextScene: Int, nextSceneType: String, rewardGroup: Int, touchCount: Int)
    {
        self.sceneID = sceneID
        self.resource = resource
        self.action = ActionType.fromRaw(action)!
        self.nextScene = nextScene
        self.nextSceneType = NextSceneType.fromRaw(nextSceneType)!
        self.rewardGroup = rewardGroup
        self.touchCount = touchCount
    }
    
}

enum ResourceType: Int
{
    case image = 1;
    case label;
    case button;
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
