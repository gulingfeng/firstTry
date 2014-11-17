//
//  AppDelegate.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-11-10.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate{ //NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    var treeNode = NSArray(array: [["FirstColumn":"aaa"],["FirstColumn":"bbb"]])
    
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var connButton: NSButton!
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    @IBOutlet weak var selectButton: NSButton!
    
    @IBOutlet weak var tableNameList: NSOutlineView!
    
    @IBOutlet weak var tableNameColumn: NSTableColumn!
    

   
    @IBOutlet weak var tableNameView: NSTableView!
    
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
            //var tableName = TableNameListTree()
            //tableNameList.setDataSource(tableName)
            //tableNameList.insertText("aaa")
            //tableNameList.insertValue("bbb", atIndex: 0, inPropertyWithKey: "b")
            //treeNode = NSArray(array: ["aaa","bbb"])
            //tableNameList.setDataSource(self)
            
            tableNameView.setDataSource(self)
            
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
        //tableNameList.setDelegate(self)
        //tableNameList.tableColumns
   
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    /*func outlineView(outlineView: NSOutlineView!, child index: Int, ofItem item: AnyObject!) -> AnyObject!{
        println(treeNode.objectAtIndex(index))
        return (item == nil) ? treeNode.objectAtIndex(index) : nil
    }
    
    func outlineView(outlineView: NSOutlineView!, isItemExpandable item: AnyObject!) -> Bool{
        if(item == nil){
            return true
        }else{
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView!, numberOfChildrenOfItem item: AnyObject!) -> Int{
        println(treeNode.count)
        return (item == nil) ? treeNode.count : 0
    }
    
    func outlineView(outlineView: NSOutlineView!, objectValueForTableColumn tableColumn: NSTableColumn!, byItem item: AnyObject!) -> AnyObject!{
        println(tableColumn.identifier)
        return "tet"
    }

    func outlineView(outlineView: NSOutlineView!, viewForTableColumn tableColumn: NSTableColumn!, item: AnyObject!) -> NSView!{
        println("111")
        return outlineView.makeViewWithIdentifier("column1", owner: self) as NSView
    }*/
    
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int{
        println(treeNode.count)
        return treeNode.count
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!{
        println(treeNode.objectAtIndex(row).objectForKey(tableColumn.identifier))
        return treeNode.objectAtIndex(row).objectForKey(tableColumn.identifier)
        
    }
}


