#import <UIKit/UIKit.h>

typedef NS_ENUM(int, StatusBarItem) {
  // 0
  // 1
  // 2
  // 3
  SignalStrengthBars = 4,
  SecondarySignalStrengthBars = 5,
  // 6
  // 7
  // 8
  // 9
  // 10
  // 11
  // 12
  BatteryDetail = 13,
  // 14
  // 15
  Bluetooth = 16,
  // 17
  // 18
  // 19
  // 20
  // 21
  // 22
  // 23
  // 24
  // 25
  // 26
  // 27
  // 28
  // 29
  // 30
  // 31
  // 32
  // 33
  // 34
  // 35
  // 36
  // 37
  // 38
  // 39
  // 40
};

typedef NS_ENUM(unsigned int, BatteryState) {
  BatteryStateUnplugged = 0
};

typedef struct {
  bool itemIsEnabled[41];
  char timeString[64];
  char shortTimeString[64];
  char dateString[256];
  int gsmSignalStrengthRaw;
  int secondaryGsmSignalStrengthRaw;
  int gsmSignalStrengthBars;
  int secondaryGsmSignalStrengthBars;
  char serviceString[100];
  char secondaryServiceString[100];
  char serviceCrossfadeString[100];
  char secondaryServiceCrossfadeString[100];
  char serviceImages[2][100];
  char operatorDirectory[1024];
  unsigned int serviceContentType;
  unsigned int secondaryServiceContentType;
  int wifiSignalStrengthRaw;
  int wifiSignalStrengthBars;
  unsigned int dataNetworkType;
  unsigned int secondaryDataNetworkType;
  int batteryCapacity;
  unsigned int batteryState;
  char batteryDetailString[150];
  int bluetoothBatteryCapacity;
  int thermalColor;
  unsigned int thermalSunlightMode : 1;
  unsigned int slowActivity : 1;
  unsigned int syncActivity : 1;
  char activityDisplayId[256];
  unsigned int bluetoothConnected : 1;
  unsigned int displayRawGSMSignal : 1;
  unsigned int displayRawWifiSignal : 1;
  unsigned int locationIconType : 1;
  unsigned int quietModeInactive : 1;
  unsigned int tetheringConnectionCount;
  unsigned int batterySaverModeActive : 1;
  unsigned int deviceIsRTL : 1;
  unsigned int lock : 1;
  char breadcrumbTitle[256];
  char breadcrumbSecondaryTitle[256];
  char personName[100];
  unsigned int electronicTollCollectionAvailable : 1;
  unsigned int wifiLinkWarning : 1;
  unsigned int wifiSearching : 1;
  double backgroundActivityDisplayStartDate;
  unsigned int shouldShowEmergencyOnlyStatus : 1;
  unsigned int secondaryCellularConfigured : 1;
  char primaryServiceBadgeString[100];
  char secondaryServiceBadgeString[100];
} StatusBarRawData;

typedef struct {
  bool overrideItemIsEnabled[41];
  unsigned int overrideTimeString : 1;
  unsigned int overrideDateString : 1;
  unsigned int overrideGsmSignalStrengthRaw : 1;
  unsigned int overrideSecondaryGsmSignalStrengthRaw : 1;
  unsigned int overrideGsmSignalStrengthBars : 1;
  unsigned int overrideSecondaryGsmSignalStrengthBars : 1;
  unsigned int overrideServiceString : 1;
  unsigned int overrideSecondaryServiceString : 1;
  unsigned int overrideServiceImages : 2;
  unsigned int overrideOperatorDirectory : 1;
  unsigned int overrideServiceContentType : 1;
  unsigned int overrideSecondaryServiceContentType : 1;
  unsigned int overrideWifiSignalStrengthRaw : 1;
  unsigned int overrideWifiSignalStrengthBars : 1;
  unsigned int overrideDataNetworkType : 1;
  unsigned int overrideSecondaryDataNetworkType : 1;
  unsigned int disallowsCellularDataNetworkTypes : 1;
  unsigned int overrideBatteryCapacity : 1;
  unsigned int overrideBatteryState : 1;
  unsigned int overrideBatteryDetailString : 1;
  unsigned int overrideBluetoothBatteryCapacity : 1;
  unsigned int overrideThermalColor : 1;
  unsigned int overrideSlowActivity : 1;
  unsigned int overrideActivityDisplayId : 1;
  unsigned int overrideBluetoothConnected : 1;
  unsigned int overrideBreadcrumb : 1;
  unsigned int overrideLock;
  unsigned int overrideDisplayRawGSMSignal : 1;
  unsigned int overrideDisplayRawWifiSignal : 1;
  unsigned int overridePersonName : 1;
  unsigned int overrideWifiLinkWarning : 1;
  unsigned int overrideSecondaryCellularConfigured : 1;
  unsigned int overridePrimaryServiceBadgeString : 1;
  unsigned int overrideSecondaryServiceBadgeString : 1;
  StatusBarRawData values;
} StatusBarOverrideData;

@interface UIStatusBar_Base : UIView
-(void)setLocalDataOverrides:(StatusBarOverrideData *)arg1;
-(void)forceUpdateData:(BOOL)arg1 ;
@end

@interface UIStatusBarServer : NSObject
+ (StatusBarOverrideData *)getStatusBarOverrideData;
@end

@interface UIApplication (Private)
- (UIStatusBar_Base *)statusBar;
@end

@interface SBDateTimeController : NSObject
@property (nonatomic,copy) NSDate * overrideDate;
+ (instancetype)sharedInstance;
@end

@interface TLAlertConfiguration : NSObject
- (id)initWithType:(long long)arg1 ;
@end

@interface NCNotificationSound : NSObject
@end

@interface NCNotificationOptions : NSObject
@property (nonatomic,readonly) BOOL canTurnOnDisplay;
@property (nonatomic,readonly) BOOL canPlaySound;
@end

@interface NCNotificationRequest : NSObject
@property (nonatomic,copy,readonly) NSString * notificationIdentifier;
@property (nonatomic, retain, readonly) NSObject *content;
@property (nonatomic, readonly) NCNotificationOptions * options;
@property (nonatomic, readonly) NCNotificationSound *sound;
+(id)notificationRequestWithSectionId:(id)arg1 notificationId:(id)arg2 threadId:(id)arg3 title:(id)arg4 message:(id)arg5 timestamp:(id)arg6 destinations:(id)arg7;
@end

@interface NCNotificationDispatcher : NSObject
- (void)postNotificationWithRequest:(NCNotificationRequest *)request;
- (void)withdrawNotificationWithRequest:(NCNotificationRequest *)request;
@end

@interface SBNCNotificationDispatcher : NSObject
@property (nonatomic,retain) NCNotificationDispatcher *dispatcher;
@end

@interface SpringBoard : UIApplication
@property (nonatomic,readonly) SBNCNotificationDispatcher * notificationDispatcher;
- (void)_relaunchSpringBoardNow;
@end

@interface NSTimer (iOS10ShitThatTheosCantFind)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                      block:(void (^)(NSTimer *timer))block;
@end;

@interface SBApplication : NSObject
- (NSString *)displayName;
- (NSString *)bundleIdentifier;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)bundleIdentifier;
@end

@interface NCNotificationViewController : UIViewController
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;
@end

@interface NCNotificationListCell : UICollectionViewCell
@property (nonatomic,retain) NCNotificationViewController * contentViewController;
@end

@interface SBSRelaunchAction : NSObject
+ (id)actionWithReason:(id)arg1 options:(unsigned long long)arg2 targetURL:(id)arg3;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)sendActions:(id)arg1 withResult:(/*^block*/id)arg2;
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundle format:(int)format scale:(CGFloat)scale;
@end
