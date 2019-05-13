//
//  ViewController.swift
//  todolist
//
//  Created by Ledesma, Alejandra on 4/29/19.
//  Copyright © 2019 Ledesma, Alejandra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getToDoItems()
    }
    
    func getToDoItems() {
        // Get ToDo items from Core Data
        if let context = ((NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
            do {
                // set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(toDoItems.count)
            } catch {}
        }
        // Update the table
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = ((NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                if importantCheckBox.state.rawValue == 0 {
                    // Not important
                    toDoItem.important = false
                } else{
                    // Important
                    toDoItem.important = true
                }
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckBox.state = NSControl.StateValue(rawValue: 0)
                
                getToDoItems()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        
        if let context = ((NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
            do {
                context.delete(toDoItem)
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                getToDoItems()
                
                deleteButton.isHidden = true
            }
        }
    }
    
    
    // MARK: - TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        
        if tableColumn?.identifier.rawValue == "importantColumn" {
            
            // IMPORTANT
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView{
                
                if toDoItem.important {
                    cell.textField?.stringValue = "📌"
                } else {
                    cell.textField?.stringValue = "💙"
                }
                
                //cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        } else {
            // TODO COLUMN
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoItems"), owner: self) as? NSTableCellView{
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}

