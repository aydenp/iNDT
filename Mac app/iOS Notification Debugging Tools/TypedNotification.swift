//
//  Notification.swift
//  iNDT Test
//
//  Created by AppleBetas on 2018-03-10.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

import Foundation

struct TypedNotification: Codable, CustomStringConvertible {
    let bundleIdentifier: String, title: String, content: String
    
    static func from(data: [String: String]) -> TypedNotification? {
        guard let bundleIdentifier = data["bundleIdentifier"], let title = data["title"], let content = data["content"] else { return nil }
        return TypedNotification(bundleIdentifier: bundleIdentifier, title: title, content: content)
    }
    
    var description: String {
        return "Title: \(title), Message: \(content), Bundle ID: \(bundleIdentifier)"
    }
}

struct TimedNotification: Codable, CustomStringConvertible {
    let start: TimeInterval, notification: TypedNotification
    
    static func from(data: [String: AnyObject]) -> TimedNotification? {
        guard let start = data["start"] as? TimeInterval, let notifData = data["notification"] as? [String: String], let notif = TypedNotification.from(data: notifData) else { return nil }
        return TimedNotification(start: start, notification: notif)
    }
    
    var description: String {
        return "\(start)s: \(notification)"
    }
}
