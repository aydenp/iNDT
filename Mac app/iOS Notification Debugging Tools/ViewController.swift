//
//  ViewController.swift
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-10.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

class ViewController: NSViewController {
    @IBOutlet weak var queueTableView: NSTableView!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var contentField: NSTextView!
    @IBOutlet weak var bundleField: NSTextField!
    @IBOutlet weak var timeSpoofCheckbox: NSButton!
    @IBOutlet weak var spoofCarrierNameCheckbox: NSButton!
    @IBOutlet weak var carrierNameField: NSTextField!
    private var session: MCSession!, browserController: MCBrowserViewController?
    private let peer = MCPeerID(displayName: Host.current().localizedName ?? "A Fucking Mac")
    fileprivate static let serviceType = "notif-debug"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.object(forKey: "TimedNotifications") as? Data, let notifications = try? PropertyListDecoder().decode([TimedNotification].self, from: data) {
            timedNotifications = notifications
        }
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        showBrowserViewController()
    }
    
    var timedNotifications: [TimedNotification] = [] {
        didSet {
            queueTableView.reloadData()
            guard let data = try? PropertyListEncoder().encode(timedNotifications) else { return }
            UserDefaults.standard.set(data, forKey: "TimedNotifications")
        }
    }
    
    func getTypedNotification() -> TypedNotification {
        return TypedNotification(bundleIdentifier: bundleField.stringValue, title: titleField.stringValue, content: contentField.string)
    }

    @IBAction func sendNotificationClicked(_ sender: Any) {
        let notif = getTypedNotification()
        guard let data = try? JSONEncoder().encode(NotificationMessage(notification: notif)) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    @IBAction func addToQueueClicked(_ sender: Any) {
        let notif = getTypedNotification()
        prompt(title: "How long until this notification is displayed?", defaultValue: timedNotifications.count > 0 ? "0.5" : "0", placeholder: "Delay in seconds") { (intervalStr) in
            guard let intervalStr = intervalStr, let interval = TimeInterval(intervalStr) else { return }
            let start = (self.timedNotifications.last?.start ?? 0) + interval
            self.timedNotifications.append(TimedNotification(start: start, notification: notif))
        }
    }
    
    @IBAction func sendQueueClicked(_ sender: Any) {
        guard let data = try? JSONEncoder().encode(NotificationMessage(notifications: timedNotifications)) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    @IBAction func clearQueueClicked(_ sender: Any) {
        timedNotifications = []
    }
    
    @IBAction func respringClicked(_ sender: Any) {
        triggerAction(named: "respring")
    }
    
    @IBAction func clearAllClicked(_ sender: Any) {
        triggerAction(named: "clearAll")
    }
    
    @IBAction func timeSpoofChanged(_ sender: Any) {
        sendBoolSetting(named: "spoofsTime", changedTo: timeSpoofCheckbox.state == .on)
    }
    
    @IBAction func carrierSpoofChanged(_ sender: Any) {
        sendBoolSetting(named: "spoofsCarrier", changedTo: spoofCarrierNameCheckbox.state == .on)
    }
    
    @IBAction func loadListClicked(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: view.window!) { (response) in
            guard response == .OK, let url = panel.urls.first, let data = try? Data(contentsOf: url), let timedNotifications = try? PropertyListDecoder().decode([TimedNotification].self, from: data) else { return }
            self.timedNotifications = timedNotifications
        }
    }
    
    @IBAction func saveListClicked(_ sender: Any) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["plist"]
        panel.beginSheetModal(for: view.window!) { (response) in
            guard response == .OK, let url = panel.url, let data = try? PropertyListEncoder().encode(self.timedNotifications) else { return }
            try? data.write(to: url)
        }
    }
    
    @IBAction func spoofCarrierNameChanged(_ sender: Any) {
        spoofCarrierNameCheckbox.state = .on
        sendBoolSetting(named: "spoofsCarrier", changedTo: true)
        sendStringSetting(named: "carrierName", changedTo: carrierNameField.stringValue)
    }
    
    func setting(named name: String, changedTo value: String) {
        switch name {
        case "spoofsTime": timeSpoofCheckbox.state = value == "1" ? .on : .off
        case "spoofsCarrier": spoofCarrierNameCheckbox.state = value == "1" ? .on : .off
        case "carrierName": carrierNameField.stringValue = value
        default: break
        }
    }
    
    func sendStringSetting(named name: String, changedTo value: String) {
        guard let data = try? JSONEncoder().encode(SettingMessage(name: name, value: value)) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    func sendBoolSetting(named name: String, changedTo value: Bool) {
        sendStringSetting(named: name, changedTo: value ? "1" : "0")
    }
    
    func triggerAction(named name: String) {
        guard let data = try? JSONEncoder().encode(ActionMessage(action: name)) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    private func showBrowserViewController() {
        browserController = MCBrowserViewController(serviceType: ViewController.serviceType, session: session)
        browserController!.maximumNumberOfPeers = 1
        browserController!.delegate = self
        presentViewControllerAsSheet(browserController!)
    }
    
    func prompt(title: String, defaultValue: String = "", placeholder: String? = nil, completion: @escaping (String?) -> Void) {
        let alert = NSAlert()
        alert.messageText = title
        
        alert.addButton(withTitle: "Add to Queue")
        alert.buttons.last?.keyEquivalent = "\r"
        alert.addButton(withTitle: "Cancel")
        alert.buttons.last?.keyEquivalent = "\u{1b}"
        
        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        input.stringValue = defaultValue
        input.placeholderString = placeholder
        alert.accessoryView = input
        
        alert.beginSheetModal(for: view.window!) { (response) in
            completion(response ==
                .alertFirstButtonReturn ? input.stringValue : nil)
        }
    }
    
    var titleAddition: String? {
        didSet {
            view.window?.title = "\(titleAddition != nil ? "\(titleAddition!) - " : "")iOS Notification Debugging Tools"
        }
    }
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(nil)
        browserController = nil
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        view.window?.close()
    }
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(SettingMessage.self, from: data) else { return }
        DispatchQueue.main.async {
            message.settings.forEach { self.setting(named: $0.key, changedTo: $0.value) }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.browserController?.dismiss(nil)
                self.browserController = nil
                self.titleAddition = "Connected to \(peerID.displayName)"
            case .connecting:
                self.titleAddition = "Connecting to \(peerID.displayName)…"
            case .notConnected:
                if self.browserController?.presenting == nil {
                    self.showBrowserViewController()
                }
                self.titleAddition = nil
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return timedNotifications.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Row"), owner: self) as! TimedNotificationView
        view.notification = timedNotifications[row]
        return view
    }
}

extension ViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertTab(_:)) {
            textView.window?.selectNextKeyView(nil)
            return true
        }
        return false
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            sendNotificationClicked(control)
            return true
        }
        return false
    }
}
