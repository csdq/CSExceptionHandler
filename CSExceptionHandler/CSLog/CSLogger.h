//
//  CSLog.h
//  CSLog
//
//  Created by csdq on 2016/8/2.
//  Copyright © 2016年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCSNotificationExceptionRaise  @"kCSNotificationExceptionRaise"
//控制台输出 仅DEBUG模式启用
#ifdef DEBUG
#define CSLogDebug(format, ...) do {\
fprintf(stderr, "-----------------------------------------\n");             \
fprintf(stderr, "File: %s / Func: %s / Line: %d\n",                         \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__func__, __LINE__);                                                        \
NSLog((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-----------------------------------------\n\n");           \
} while (0)
#else
#define CSLogDebug(format, ...) nil
#endif
//错误信息 记录到文件
#define CSLogError(format,...) do {\
NSMutableString *errorInfo = [NSMutableString stringWithFormat:@"-----------------------------------------\nType Error\nFile: %s / Func: %s / Line: %d\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__, __LINE__];\
[errorInfo appendString:[NSString stringWithFormat:(format),##__VA_ARGS__]];\
[errorInfo appendString:@"\n-----------------------------------------\n\n"];\
[CSLogger appendErrorLog:errorInfo];\
} while (0)

//
//extern void CSLogError(NSString *format,...);//错误信息 记录到文件
//extern void CSLogDebug(NSString *format,...);//控制台输出 仅DEBUG模式启用

@interface CSLogger : NSObject
@property (nonatomic , strong) NSString *exceptionFilePath;//default /Library/Caches/AppException.log
@property (nonatomic , strong) NSString *errorFilePath;//default /Library/Caches/AppError.log
@property (assign) BOOL exceptionWriteToFile;//default YES
@property (assign) BOOL errorWriteToFile;//default YES
//异常外部处理完成
@property (nonatomic , strong) NSNumber *finished;
//追加到错误日志
+ (void)appendErrorLog:(NSString *)log;
//追加到异常日志
+ (void)appendExceptionLog:(NSString *)log;
//设置捕捉异常
+ (void)setCatchAppException;
//取消设置捕捉异常
+ (void)unsetCatchAppException;
//自己处理完 后调用
+ (void)exceptionProcessCompleted;
+ (instancetype)sharedInstance;
@end
