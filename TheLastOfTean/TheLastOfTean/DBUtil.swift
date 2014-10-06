//
//  DBUtil.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-30.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

class DBUtilSingleton{
    var dbFilePath: NSString = NSString()
    
    let DATABASE_RESOURCE_NAME = "TheLastOfTeam"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "TheLastOfTeam.sqlite"
    var count2 = 0
    var count4 = 0
    var count5 = 0
    class var shared:DBUtilSingleton {
        return Inner.instance
    }

    struct Inner {
        static var instance = DBUtilSingleton()

    }

    var connection:FMDatabase?
    init()
    {
        if initializeDb()
        {
            println("init DB Successfully")
            connection = FMDatabase(path: self.dbFilePath)
            if (connection?.open() != nil)
            {
                println("open db ok")
            }else{
                println("open db failed")
            }
        }
    }
    func initializeDb() -> Bool {
        println("start init DB")
        //println(NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE))
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let dbfile = "/" + DATABASE_FILE_NAME;
        
        self.dbFilePath = documentFolderPath.stringByAppendingString(dbfile)
        println(self.dbFilePath)
        let filemanager = NSFileManager.defaultManager()
        if (!filemanager.fileExistsAtPath(dbFilePath) ) {
            
            let backupDbPath = NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE)
            
            if (backupDbPath == nil) {
                return false
            } else {
                var error: NSError?
                let copySuccessful = filemanager.copyItemAtPath(backupDbPath!, toPath:dbFilePath, error: &error)
                if !copySuccessful {
                    println("copy failed: \(error?.localizedDescription)")
                    return false
                }
                
            }
            
        }else{
            var error: NSError?
            let deleteSuccessful = filemanager.removeItemAtPath(self.dbFilePath, error: &error)
            if deleteSuccessful
            {
                println("delete DB file successfully")
            }else{
                println("delete DB file error:\(error)")
            }
            let backupDbPath = NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE)
            
            if (backupDbPath == nil) {
                return false
            } else {
                var error: NSError?
                let copySuccessful = filemanager.copyItemAtPath(backupDbPath!, toPath:dbFilePath, error: &error)
                if !copySuccessful {
                    println("copy DB failed: \(error?.localizedDescription)")
                    return false
                }else{
                    println("copy DB file successfully")
                }
                
            }
        }
        return true
        
    }

    var count = 0
    func executeQuerySql(sql: String) -> FMResultSet!
    {
        println("executeQuerySql:\(sql)")
        
        var result = connection?.executeQuery(sql, withArgumentsInArray: nil)
        
        if result == nil
        {
            result = FMResultSet()
        }
        return result

    }

    func executeUpdateSql(sql: String) -> Bool?
    {
        println("executeUpdateSql:\(sql)")
        
        
        var result = connection?.executeUpdate(sql, withArgumentsInArray: nil)
        /*
        if (connection?.close() != nil)
        {
            println("close db ok")
        }else{
            println("close db failed")
        }
        */
        return result
        
    }
}