//
//  Messages.swift
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-10.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

import Foundation

struct SettingMessage: Codable {
    let type = "settings"
    let settings: [String: String]
    
    init(settings: [String: String]) {
        self.settings = settings
    }
    
    init(name: String, value: String) {
        self.init(settings: [name: value])
    }
}

struct ActionMessage: Codable {
    let type = "action"
    let action: String
}

struct NotificationMessage: Codable {
    let type = "notifications"
    let notifications: [TimedNotification]
    
    init(notification: TypedNotification) {
        self.notifications = [TimedNotification(start: 0, notification: notification)]
    }
    
    init(notifications: [TimedNotification]) {
        self.notifications = notifications
    }
}
