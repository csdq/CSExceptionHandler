//
//  CSLog.h
//  CSLog
//
//  Created by shitingquan on 2017/3/29.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSLogger : NSObject
void CSLog(NSString *format, ...);
+ (void)setCatchAppException;
+ (instancetype)sharedInstance;
- (void)alertShow;
@end
