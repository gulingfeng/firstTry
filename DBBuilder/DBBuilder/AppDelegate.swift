//
//  AppDelegate.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-11-10.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {
    
    var treeNode = [String]() // 数据表名称 即树状列表节点
    
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var connButton: NSButton! //连接按钮
    @IBOutlet weak var fileNameTextField: NSTextField! //文件名称输入框
    @IBOutlet weak var selectButton: NSButton! //选择按钮
    
    @IBOutlet weak var addButton: NSButton! //添加按钮
    @IBOutlet weak var deleteButton: NSButton! //删除按钮
    @IBOutlet weak var submitButton: NSButton! //提交按钮
    @IBOutlet weak var cancelButton: NSButton! //取消按钮
    
    var isConnected: Bool = false //是否已连接
    var isTableSelected: Bool = false //是否已选择表
    var isRowSelected: Bool = false //是否已选择行
    var tableName: String = "" //选择数据表名称
    var rowsCount: Int32 = 0 //记录总数
    var columnCount: Int32 = 0 //列数
    var currentIndex: Int = 0 //选择记录在Array Controller中的索引
    var currentRowId: Int = 0 //选择记录的rowid
    enum actionTypes{  //操作类型
        case Add
        case Delete
        case Edit
        case Cancel
        case None
    }
    var currentAction = actionTypes.None //现在的操作类型
    
    @IBOutlet weak var tableNameView: NSTableView! //所有表列表
  
    @IBOutlet weak var lableTableName: NSTextField! //数据表名称Label
    
    @IBOutlet var arrayController: NSArrayController! //存储表头的Array Controller
    var tableHeads: NSMutableArray = NSMutableArray() //
    
    
    @IBOutlet weak var tableInfoView: MyItemView!
    @IBOutlet weak var tableInfoCollectionView: NSCollectionView!
    @IBOutlet weak var tableInfoCollectionViewItem: NSCollectionViewItem!
    @IBOutlet var infoArrayController: NSArrayController!
    var tableInfos: NSMutableArray = NSMutableArray()
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        setButton()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    //设置按钮
    func setButton(){
        if (!isTableSelected ){
            addButton.enabled = false
            deleteButton.enabled = false
            submitButton.enabled = false
            cancelButton.enabled = false
        }else if(!isRowSelected){
            addButton.enabled = true
            deleteButton.enabled = false
            submitButton.enabled = true
            cancelButton.enabled = true
        }else{
            addButton.enabled = true
            deleteButton.enabled = true
            submitButton.enabled = true
            cancelButton.enabled = true
        }
    }    
    
    //选择数据文件
    @IBAction func selectDBFile(sender: NSButton) {
        //弹出选择文件对话框
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
    
    //连接数据文件 读取所有数据表名称 并添加至TableView视图中
    @IBAction func connectDB(sender: NSButton) {
        if (DBUtilSingleton.shared.dbFilePath != ""){
            isConnected = true
            
            DBUtilSingleton.shared.connectDB()
            
            var sqlSelectAllTableName = "select name from sqlite_master where type='table' order by name" //"PRAGMA table_info(item)"//
            var result = DBUtilSingleton.shared.executeQuerySql(sqlSelectAllTableName)
    
            while result.next(){
                treeNode.append(result.stringForColumn("name"))
            
            }
            result.close()
            
            //treeNode = NSArray(array: ["aaa","bbb"])
            //treeNode = ["aaa","bbb"]
            tableNameView.setDataSource(self)
            
            setButton()
        }
        else{
            isConnected = false
            
            //弹出警告框
            alertViewPopped(isConnected, message: "请选择数据文件！")
            
        }
    }
    
  
    /*--------------TableView显示数据--------------*/
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int{
        
        return treeNode.count
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!{

        //return treeNode.objectAtIndex(row)
        return treeNode[row]
    }
    /*--------------TableView显示数据--------------*/
    
    
    //选择TableView中某条数据触发事件
    @IBAction func selectATable(sender: NSTableView) {
        
        var selectedTableIndex = tableNameView.selectedRow
        var selectedTableName = ""
        if (selectedTableIndex > -1) {
            isTableSelected = true
            isRowSelected = false
            tableName = treeNode[selectedTableIndex]
            showTableHeadInfo(tableName)   //显示数据表头
            showTableDetailInfo(tableName) //显示数据表详细内容
            setButton()
        }
    }
    
    //显示数据表头
    func showTableHeadInfo(tableName: String) {
        
        lableTableName.stringValue = tableName
        
        //先清除
        tableHeads.removeAllObjects()
        arrayController.rearrangeObjects()
              
        //后添加
        var sqlSelectTableHead = "PRAGMA table_info(\(tableName))"//
        var result = DBUtilSingleton.shared.executeQuerySql(sqlSelectTableHead)
        
        columnCount = 0
        while result.next(){
            var tableHead: TableHead = TableHead()
            tableHead.columnName = result.stringForColumn("name")
            arrayController.addObject(tableHead)
            columnCount++
        }
        result.close()
    }
    
    //创建Item View所有控件
    func createItemView(){
        
        //选择箭头按钮 tooltip为index
        var selectButton: NSButton = NSButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        selectButton.bezelStyle = NSBezelStyle.DisclosureBezelStyle
        selectButton.title = ""
        selectButton.target = self
        selectButton.bind("toolTip", toObject: tableInfoCollectionViewItem, withKeyPath: "representedObject.column\(0)", options: nil)
        selectButton.action = "selectOneItem:"
        tableInfoView.addSubview(selectButton)

        //10个输入框
        //for var i=0; i<Int(result.columnCount()); i++
        for var i=1; i<TableInfo.numberOfColumn; i++
        {
            var inputTextField: NSTextField = NSTextField(frame: CGRect(x: (i-2)*TableInfo.widthOfColumn+20, y: 0, width: TableInfo.widthOfColumn, height: TableInfo.heightOfColumn))
            if (i == 1){
                inputTextField.hidden = true //隐藏input 值为rowid
            }else{
                inputTextField.hidden = false
                inputTextField.bordered = false
                inputTextField.drawsBackground = false
                (inputTextField.cell() as NSCell).wraps = false
                (inputTextField.cell() as NSCell).scrollable = true
            }
            inputTextField.bind("value", toObject: tableInfoCollectionViewItem, withKeyPath: "representedObject.column\(i)", options: nil)
            tableInfoView.addSubview(inputTextField)
        }
    }
    
    //显示数据表详细内容
    func showTableDetailInfo(tableName: String) {
        
        currentIndex = 0
        currentRowId = 0
        
        //先清除
        tableInfos.removeAllObjects()
        infoArrayController.rearrangeObjects()
        tableInfoView.subviews.removeAll(keepCapacity: false)
  
        //查询记录总数
        var sqlSelectRowsCount = "select count(*) from \(tableName)"
        var resultRowsCount = DBUtilSingleton.shared.executeQuerySql(sqlSelectRowsCount)
        resultRowsCount.next()
        rowsCount = resultRowsCount.intForColumnIndex(0)
        resultRowsCount.close()
        
        createItemView() //创建Item View所有控件
        //后添加
        if(rowsCount>0){
        
            var cIndex: Int32 //列索引
            var cValue: String //列值
            var rIndex: Int32 = 0 //行索引
            var itemDetail: TableInfo

            var sqlSelectTableInfo = "select rowid,* from \(tableName)"//
            var result = DBUtilSingleton.shared.executeQuerySql(sqlSelectTableInfo)
            
            while result.next(){ //遍历行
                cIndex = 0
                itemDetail = TableInfo()
            
                itemDetail.setColumn(0, columnValue: String(rIndex)) //第一列值为行索引
                
                while cIndex<result.columnCount() { //遍历列

                    if (!result.columnIndexIsNull(cIndex)){
                        cValue = result.stringForColumnIndex(cIndex)
                    }else{
                        cValue = ""
                    }

                    itemDetail.setColumn(cIndex+1, columnValue: cValue) //设置列
                    cIndex++
                }
            
                infoArrayController.addObject(itemDetail) //添加对象至Array Controller
                rIndex++
            }
            result.close()
            
        }
    }
    
    //选择记录
    @IBAction func selectOneItem(sender: NSButton) {
       
        isRowSelected = true
        
        //先取消之前选择的记录
        var selectedViewItem: MyItemView = MyItemView()
        selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
        selectedViewItem.setSelected(false)
        
        //再设定现在选择的记录
        currentIndex = Int(sender.toolTip!.toInt()!) //Index of ArrayController
        infoArrayController.setSelectionIndex(currentIndex)
        var selectedItemDetail: TableInfo = TableInfo()
        selectedItemDetail = tableInfos[currentIndex] as TableInfo
        currentRowId = selectedItemDetail.column1.toInt()! //RowId
        selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
        selectedViewItem.setSelected(true)

        setButton()
    }
    
    //弹出相应警告对话框
    func alertViewPopped(flag: Bool, message: String) -> Bool{
    
        if(flag){
            return true
        }else{
            //弹出警告框
            var alertView:NSAlert = NSAlert()
            alertView.informativeText = "警告"
            alertView.messageText = message
            alertView.addButtonWithTitle("确定")
            alertView.alertStyle = NSAlertStyle.CriticalAlertStyle
            alertView.runModal()
            
            return false
        }
    }
   
    //添加记录
    @IBAction func addAction(sender: NSButton) {

        currentAction = actionTypes.Add
        
        //判断数据文件是否已连接 是否已选择表
        //if (alertViewPopped(isConnected, message: "请连接数据文件！") && alertViewPopped(isTableSelected, message: "请选择数据表！")){
         
            var itemDetail: TableInfo = TableInfo()
            itemDetail.column0 = String(rowsCount) //Index of ArrayController
            infoArrayController.addObject(itemDetail)
            
            //先取消之前选择的记录
            var selectedViewItem: MyItemView = MyItemView()
            selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
            selectedViewItem.setSelected(false)
            
            //再设定现在选择的记录
            currentIndex = Int(rowsCount)
            infoArrayController.setSelectionIndex(currentIndex)
            selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
            selectedViewItem.setSelected(true)
            
        //}
        
        deleteButton.enabled = false //添加时不可删除
    }
    
    
    //删除操作
    @IBAction func deleteAction(sender: NSButton) {
        
        currentAction = actionTypes.Delete
        
        //判断数据文件是否已连接 是否已选择表 是否已选择行
        //if (alertViewPopped(isConnected, message: "请连接数据文件！") && alertViewPopped(isTableSelected, message: "请选择数据表！") && alertViewPopped(isRowSelected, message: "请选择一行数据！")){
            
            //弹出删除确认
            var alertView:NSAlert = NSAlert()
            alertView.informativeText = "确认"
            alertView.messageText = "确定删除该记录吗？"
            alertView.addButtonWithTitle("确定")
            alertView.addButtonWithTitle("取消")
            alertView.alertStyle = NSAlertStyle.WarningAlertStyle
            
            if (alertView.runModal() == NSAlertFirstButtonReturn){ //确认删除
                
                var strSql = "delete from \(tableName) where rowid=\(currentRowId)"
                println(strSql)
                var result = DBUtilSingleton.shared.executeUpdateSql(strSql)
                if (result != nil)
                {
                    showTableDetailInfo(tableName) //刷新显示
                    isRowSelected = false
                    setButton()
                }
            }
        //}
        
        currentAction = actionTypes.None
    }
    
    //提交操作
    @IBAction func submitAction(sender: NSButton) {
        
        var selectedViewItem: MyItemView = MyItemView()
        selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
        
        var strSql = ""
        
        if (currentAction == actionTypes.Add){ //添加操作
            
            strSql = "insert into \(tableName) values ("
            var strValue = ""
            var isAllEmpty = true //输入框是否全为空
            for var i=2; i<=Int(columnCount+1); i++  //从第2个输入框开始
            {
                var inputTextField: NSTextField = selectedViewItem.subviews[i] as NSTextField
                var strInput = inputTextField.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if (!strInput.isEmpty){
                    isAllEmpty &= false
                    strValue += "\(strInput),"
                }else{
                    isAllEmpty &= true
                    strValue += "\"\","
                }
            }
            
            if (!isAllEmpty){
                strSql += strValue.substringToIndex(advance(strValue.startIndex, countElements(strValue)-1)) + ")" //去掉最后一个,再加上)
                var result = DBUtilSingleton.shared.executeUpdateSql(strSql)
                if (result != nil)
                {
                  
                    //var insertedItemDetail: TableInfo = TableInfo()
                    //insertedItemDetail = tableInfos[currentIndex] as TableInfo
                    showTableDetailInfo(tableName) //刷新显示
                }
            }else{
                undoAction() //取消操作
            }
            
            isRowSelected = false
            setButton()
        }
        
        currentAction = actionTypes.None
    }
    
    //取消操作
    @IBAction func cancelAction(sender: NSButton) {
        
        if (currentAction == actionTypes.Add){
            undoAction()
            isRowSelected = false
            setButton()
            currentAction = actionTypes.None
        }
    }
    
    //取消操作
    func undoAction(){
        
        //取消之前选择的记录
        var selectedViewItem: MyItemView = MyItemView()
        selectedViewItem = tableInfoCollectionView.itemAtIndex(currentIndex).view as MyItemView
        selectedViewItem.setSelected(false)
        
        infoArrayController.removeObjectAtArrangedObjectIndex(currentIndex)
        infoArrayController.rearrangeObjects()
        currentIndex = 0
    }
}

