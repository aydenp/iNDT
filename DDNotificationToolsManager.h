//
//  DDNotificationToolsManager.h
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-11.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DDNotificationToolsManagerDelegate.h"

@interface DDNotificationToolsManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property (nonatomic, retain) NSObject <DDNotificationToolsManagerDelegate>*delegate;
@end
