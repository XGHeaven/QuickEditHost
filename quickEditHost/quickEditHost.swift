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
    
    let hostPath = "/etc/hosts"
    
    override func mainViewDidLoad() {
        let hosts = String(data: FileManager().contents(atPath: "/etc/hosts")!, encoding: String.Encoding.utf8)!
        hostText.textStorage?.mutableString.setString(hosts)
        saveButton.target = self
        saveButton.action = #selector(self.saveHost(_:))
    }
    
    @IBAction func saveHost(_ sender: AnyObject) {
        if let newHost = (hostText.textStorage?.mutableString) as? String {
            let hosts = newHost.replacingOccurrences(of: "\n", with: "\\n")
            NSAppleScript(source: "do shell script \"sudo echo -ne '\(hosts)' > /etc/hosts\" with administrator privileges")!.executeAndReturnError(nil)
        }
    }
}
