//
//  TimedNotificationView.swift
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-10.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

import Cocoa

class TimedNotificationView: NSTableCellView {
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var bundleLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    private var hasAwaken = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        hasAwaken = true
    }
    
    override func prepareForReuse() {
        notification = nil
    }
    
    var notification: TimedNotification? {
        didSet {
            guard hasAwaken else { return }
            setupView()
        }
    }
    
    private func setupView() {
        if let notification = notification {
            titleLabel.stringValue = "\(notification.start)s: \(notification.notification.title)"
        } else {
            titleLabel.stringValue = "-.-s: Notification Title"
        }
        contentLabel.stringValue = notification?.notification.content ?? "Notification Content"
        bundleLabel.stringValue = notification?.notification.bundleIdentifier ?? "Bundle Identifier"
    }
}
