//
//  quickEditHost.swift
//  quickEditHost
//
//  Created by XGHeaven on 19/10/2016.
//  Copyright © 2016 XGHeaven. All rights reserved.
//

import Cocoa
import PreferencePanes

class quickEditHost: NSPreferencePane {

    @IBOutlet var hostText: NSTextView!
    
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var statusLabel: NSTextField!
    
    enum ActionStatus {
        case None
        case SaveSuccess
        case SaveFailed
        case HostEdited
        case HostLoaded
    }
    
    let hostPath = "/etc/hosts"
    
    override func mainViewDidLoad() {
        let hosts = String(data: FileManager().contents(atPath: "/etc/hosts")!, encoding: String.Encoding.utf8)!
        hostText.textStorage?.mutableString.setString(hosts)
        saveButton.target = self
        saveButton.action = #selector(self.saveHost(_:))
        changeStatus(.HostLoaded)
    }
    
    @IBAction func saveHost(_ sender: AnyObject) {
        var errInfo:NSDictionary?
        if let newHost:String = ((hostText.textStorage?.mutableString)! as NSString) as String? {
            let hosts = newHost.replacingOccurrences(of: "\n", with: "\\n")
            NSAppleScript(source: "do shell script \"sudo echo -n '\(hosts)' > /etc/hosts\" with administrator privileges")!
                .executeAndReturnError(&errInfo)
            if errInfo != nil {
                changeStatus(.SaveFailed)
            } else {
                changeStatus(.SaveSuccess)
            }
        }
    }
    
    func changeStatus(_ status:ActionStatus) {
        switch status {
        case .None:
            statusLabel.stringValue = ""
        case .SaveSuccess:
            statusLabel.stringValue = "✅ Save Success"
        case .SaveFailed:
            statusLabel.stringValue = "❌ Save Failed"
        case .HostEdited:
            statusLabel.stringValue = "Host Edited"
        case .HostLoaded:
            statusLabel.stringValue = "Host Loaded"
        }
    }
}
