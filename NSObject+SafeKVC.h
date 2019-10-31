//
//  NSObject+SafeKVC.h
//
//  Created by AppleBetas on 2018-06-15.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeKVC)
- (void)safelySetValue:(id)value forKey:(NSString *)key;
- (id)safeValueForKey:(NSString *)key;
@end
