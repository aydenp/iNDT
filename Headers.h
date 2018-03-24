#import <UIKit/UIKit.h>

typedef struct {
    BOOL itemIsEnabled[35];
    char timeString[64];
    char shortTimeString[64];
    int gsmSignalStrengthRaw;
    int gsmSignalStrengthBars;
    char serviceString[100];
    char serviceCrossfadeString[100];
    char serviceImages[2][100];
    char operatorDirectory[1024];
    unsigned serviceContentType;
    int wifiSignalStrengthRaw;
    int wifiSignalStrengthBars;
    unsigned dataNetworkType;
    int batteryCapacity;
    unsigned batteryState;
    char batteryDetailString[150];
    int bluetoothBatteryCapacity;
    int thermalColor;
    unsigned thermalSunlightMode : 1;
    unsigned slowActivity : 1;
    unsigned syncActivity : 1;
    char activityDisplayId[256];
    unsigned bluetoothConnected : 1;
    unsigned displayRawGSMSignal : 1;
    unsigned displayRawWifiSignal : 1;
    unsigned locationIconType : 1;
    unsigned quietModeInactive : 1;
    unsigned tetheringConnectionCount;
    unsigned batterySaverModeActive : 1;
    unsigned deviceIsRTL : 1;
    unsigned lock : 1;
    char breadcrumbTitle[256];
    char breadcrumbSecondaryTitle[256];
    char personName[100];
    unsigned electronicTollCollectionAvailable : 1;
    unsigned wifiLinkWarning : 1;
    unsigned wifiSearching : 1;
    double backgroundActivityDisplayStartDate;
    unsigned shouldShowEmergencyOnlyStatus : 1;
} SCD_Struct_UI61;

typedef struct {
    BOOL overrideItemIsEnabled[35];
    unsigned overrideTimeString : 1;
    unsigned field3 : 1;
    unsigned field4 : 1;
    unsigned overrideServiceString : 1;
    unsigned field6 : 2;
    unsigned field7 : 1;
    unsigned field8 : 1;
    unsigned field9 : 1;
    unsigned field10 : 1;
    unsigned field11 : 1;
    unsigned field12 : 1;
    unsigned field13 : 1;
    unsigned field14 : 1;
    unsigned field15 : 1;
    unsigned field16 : 1;
    unsigned field17 : 1;
    unsigned field18 : 1;
    unsigned field19 : 1;
    unsigned field20 : 1;
    unsigned field21 : 1;
    unsigned field22;
    unsigned field23 : 1;
    unsigned field24 : 1;
    unsigned field25 : 1;
    unsigned field26 : 1;
    SCD_Struct_UI61 values;
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
@end

@interface SBApplicationIcon : NSObject
-(instancetype)initWithApplication:(SBApplication *)application;
-(UIImage *)getUnmaskedIconImage:(int)type;
- (UIImage *)generateIconImage:(int)type;
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
