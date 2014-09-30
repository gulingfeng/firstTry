//
//  ViewController.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-27.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dbFilePath: NSString = NSString()
    
    // MARK: - FMDB
    
    let DATABASE_RESOURCE_NAME = "TheLastOfTeam"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "TheLastOfTeam.sqlite"
    
    func initializeDb() -> Bool {
        //println(NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE))
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let dbfile = "/" + DATABASE_FILE_NAME;
        
        self.dbFilePath = documentFolderPath.stringByAppendingString(dbfile)
        
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
            
        }
        return true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = UIScreen.mainScreen().applicationFrame
        mainBack.frame = CGRect(x: appFrame.minX, y: appFrame.minY, width: appFrame.width, height: appFrame.height)
        self.view.addSubview(mainBack)
        println(appFrame)
        println(UIScreen.mainScreen().bounds)
        
        var newDayBack = UIImageView(image: UIImage(named: "new_day_bak.png"))
        newDayBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.minY+5, width:appFrame.width-10, height: appFrame.height-10)
        self.view.addSubview(newDayBack)
        var dayLabel = UILabel()
        dayLabel.text = "第 20 天"
        dayLabel.frame = CGRect(x: appFrame.minX+264, y: appFrame.minY+130, width: 100, height: 20)
        self.view.addSubview(dayLabel)
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.minX+264, y: appFrame.minY+180, width: 60, height: 20)
        button.addTarget(self, action: "showEventPage", forControlEvents: .TouchUpInside)
        button.setTitle("开始", forState: .Normal)
        
        self.view.addSubview(button)
        if self.initializeDb() {
            println("Successful db copy")
        }
        testDB()
    }

    func showEventPage()
    {
        var vc = showEvent()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func testDB()
    {
        println("start testdb")
        let db = FMDatabase(path: dbFilePath)
        
        if db.open()
        {
            println("open db ok")
        }else{
            println("open db failed")
            return
        }
        /*
        let create="create table test_db (name text,keyword text)"
        let queryTable = "select count(1) from test_db"
        var tableResult = db.executeQuery(queryTable, withArgumentsInArray: nil)
        var success = false
        if tableResult == nil || !tableResult.next()
        {
            success = db.executeUpdate(create, withArgumentsInArray: nil)
            if success
            {
                println("create success")
            }
        }else{
            println("table is already created")
        }
        
        let insertSql = "insert into test_db (name,keyword) values('xiaoming','keyword xiaoming')"
        success = db.executeUpdate(insertSql, withArgumentsInArray: nil)
        if success
        {
            println("insert success")
        }
        let updateSql = "update test_db set keyword='new xiaoming keyword' where name='xiaoming'"
        success = db.executeUpdate(updateSql, withArgumentsInArray: nil)
        if success
        {
            println("update success")
        }
        */
        let querySql = "select * from scene_detail"
        let result = db.executeQuery(querySql, withArgumentsInArray: nil)
        while result.next()
        {
            let name = result.stringForColumn("scene_id")
            let keyword = result.stringForColumn("resource_id")
            println("scene_id: \(name) resource_id: \(keyword)")
        }
    }


}

