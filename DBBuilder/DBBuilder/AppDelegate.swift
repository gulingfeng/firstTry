//
//  AppDelegate.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-11-10.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var connButton: NSButton!
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    @IBOutlet weak var selectButton: NSButton!
    
    @IBOutlet weak var tableNameList: NSOutlineView!
    
    @IBAction func selectDBFile(sender: NSButton) {
        var fileDialog: NSOpenPanel = NSOpenPanel()
        fileDialog.worksWhenModal = true
        fileDialog.allowsMultipleSelection = false
        fileDialog.canChooseDirectories = false
        fileDialog.resolvesAliases = true
        fileDialog.allowedFileTypes = NSArray(array: ["sqlite"])
        fileDialog.title = "请选择数据文件"
        fileDialog.message = "sqlite文件"

        fileDialog.runModal()
        var chosenFile = fileDialog.URL
        if (chosenFile != nil){
            var chosenFileString = chosenFile.absoluteString
            fileNameTextField.stringValue = chosenFileString
            DBUtilSingleton.shared.dbFilePath = chosenFileString!
         }

        //DBUtilSingleton.shared.connection?.executeQuery("select * from ", withArgumentsInArray: nil)
    }

    
    @IBAction func connectDB(sender: NSButton) {
        if (DBUtilSingleton.shared.dbFilePath != ""){
            DBUtilSingleton.shared.connectDB()
            
            var sqlSelectAllTableName = "select name from sqlite_master where type='table' order by name"
            var result = DBUtilSingleton.shared.executeQuerySql(sqlSelectAllTableName)
    
            while result.next(){
                println(result.stringForColumn("name"))
            
            }
            ///test
            var tableName = TableNameListTree()
            tableNameList.setDataSource(tableName)

        }
        else{
            var alertView:NSAlert = NSAlert()
            alertView.informativeText = "警告"
            alertView.messageText = "请选择数据文件！"
            alertView.addButtonWithTitle("确定")
            alertView.alertStyle = NSAlertStyle.CriticalAlertStyle
            alertView.runModal()
            
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

