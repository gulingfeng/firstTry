//
//  GameUtil.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-10-7.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
class GameUtil
{
    class var shared:GameUtil {
    return Inner.instance
    }

    struct Inner {
        static var instance = GameUtil()
        
    }
    
    var isDebug: Bool!
    init()
    {
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
}