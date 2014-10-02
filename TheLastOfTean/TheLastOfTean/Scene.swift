//
//  Scene.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-30.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

enum ActionType: String
{
    case add = "A"
    case delete = "D"
    case replace = "R"
}
class Scene: Printable
{
    var sceneDetails: [SceneDetail]
    var description: String { get
                                {
                                    var desc = ""
                                    for sceneDetail in sceneDetails
                                    {
                                        desc = "\(desc + sceneDetail.description)"
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
    let nextSceneID: Int
    let rewardGroup: Int
    var description: String { get
                                {
                                    return "sceneID:\(sceneID),action:\(action),nextSceneID:\(nextSceneID),rewardGroup:\(rewardGroup),resource:\(resource) "
                                }
                            }
    
    init(sceneID: Int, resource: SceneResource, action: String, nextSceneID: Int, rewardGroup: Int)
    {
        self.sceneID = sceneID
        self.resource = resource
        self.action = ActionType.fromRaw(action)!
        self.nextSceneID = nextSceneID
        self.rewardGroup = rewardGroup
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