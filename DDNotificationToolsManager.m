//
//  DDNotificationToolsManager.m
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-11.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

#import "DDNotificationToolsManager.h"

#define kServiceType @"notif-debug"
@implementation DDNotificationToolsManager {
    MCPeerID *peer;
    MCSession *currentSession;
    MCNearbyServiceAdvertiser *serviceAdvertiser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        peer = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        
        serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peer discoveryInfo:nil serviceType:kServiceType];
        serviceAdvertiser.delegate = self;
        [self startAdvertising];
    }
    return self;
}

- (void)startAdvertising {
    [serviceAdvertiser startAdvertisingPeer];
}

- (void)dealloc {
    [serviceAdvertiser stopAdvertisingPeer];
}

// MARK: - Nearby Service Advertiser Delegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"An error occurred trying to start advertising peer. Trying again in 5 seconds...");
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startAdvertising) userInfo:nil repeats:NO];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nullable))invitationHandler {
    NSLog(@"Received invitation from peer. Auto-accepting...");
    
    currentSession = [[MCSession alloc] initWithPeer:peer securityIdentity:nil encryptionPreference:MCEncryptionNone];
    currentSession.delegate = self;
    invitationHandler(YES, currentSession);
}

// MARK: - Session Delegate

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!json || error) return;
        NSString *type = json[@"type"];
        if (!type) return;
        if ([type isEqualToString:@"notifications"]) {
            NSArray *notifications = json[@"notifications"];
            if (!notifications) return;
            [self.delegate receivedNotifications:notifications];
        } else if ([type isEqualToString:@"settings"]) {
            NSDictionary *settings = json[@"settings"];
            if (!settings) return;
            [settings enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.delegate settingNamed:key changedTo:obj];
            }];
        } else if ([type isEqualToString:@"action"]) {
            NSString *action = json[@"action"];
            if (!action) return;
            [self.delegate triggeredActionNamed:action];
        }
    });
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            if (self.delegate && [self.delegate respondsToSelector:@selector(getConnectedPayload)]) {
                NSDictionary *payload = [self.delegate getConnectedPayload];
                NSError *error;
                NSData *data = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&error];
                if (!data || error) break;
                [session sendData:data toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
            }
            break;
        case MCSessionStateConnecting:
            [serviceAdvertiser stopAdvertisingPeer];
            break;
        case MCSessionStateNotConnected:
            currentSession = nil;
            [self startAdvertising];
            break;
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {}

@end
