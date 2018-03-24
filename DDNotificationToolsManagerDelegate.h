//
//  DDNotificationToolsManagerDelegate.h
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-11.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDNotificationToolsManagerDelegate <NSObject>
@required
- (void)receivedNotifications:(NSArray *)notifications;
- (void)settingNamed:(NSString *)name changedTo:(NSString *)value;
- (void)triggeredActionNamed:(NSString *)name;
@optional
- (NSDictionary *)getConnectedPayload;
@end
