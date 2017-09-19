//
//  CSLog.m
//  CSLog
//
//  Created by csdq on 2016/8/2.
//  Copyright © 2016年 CSDQ. All rights reserved.
//

#import "CSLogger.h"
#import <UIKit/UIKit.h>
#import "CSDeviceInfo.h"
#import <sys/signal.h>
#import <execinfo.h>

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
//Log 方法
//void CSLogDebug(NSString *format, ...);
//void CSLogError(NSString *format, ...);
//捕获信号回调
static NSException *_exception;
void SignalHandler(int signo);
//异常处理回调
void exceptionHandler(NSException *exception);
@interface CSLogger()
+ (NSArray *)backtrace;
@end
static CSLogger *_instance;

@implementation CSLogger
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.errorWriteToFile = YES;
        self.exceptionWriteToFile = YES;
    }
    return self;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self class] new];
        }
    });
    return _instance;
}

- (NSString *)exceptionFilePath{
    if(_exceptionFilePath == nil){
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _exceptionFilePath = [cachesDirectory stringByAppendingPathComponent:@"AppException.log"];
    }
    return _exceptionFilePath;
}

- (NSString *)errorFilePath{
    if(_errorFilePath == nil){
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _errorFilePath = [cachesDirectory stringByAppendingPathComponent:@"AppError.log"];
    }
    return _errorFilePath;
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);

    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


+ (void)setCatchAppException{
    NSSetUncaughtExceptionHandler(&exceptionHandler);
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, SignalHandler);
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, SignalHandler);
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, SignalHandler);
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, SignalHandler);
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, SignalHandler);
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, SignalHandler);
}

+ (void)unsetCatchAppException{
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

+ (void)appendErrorLog:(NSString *)log{
    NSString *logStr = [log stringByReplacingOccurrencesOfString:@"}" withString:@"}\nEOF\n" options:NSCaseInsensitiveSearch range:NSMakeRange(log.length-3, 3)];
    logStr = [logStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if([CSLogger sharedInstance].errorWriteToFile){
        if([[NSFileManager defaultManager] fileExistsAtPath:[CSLogger sharedInstance].errorFilePath]){
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[CSLogger sharedInstance].errorFilePath];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
        }else{
            [logStr writeToFile:[CSLogger sharedInstance].errorFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

+ (void)appendExceptionLog:(NSString *)log{
     NSString *logStr = [log stringByReplacingOccurrencesOfString:@"}" withString:@"}\nEOF\n" options:NSCaseInsensitiveSearch range:NSMakeRange(log.length-3, 3)];
    logStr = [logStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if([CSLogger sharedInstance].exceptionFilePath){
        if([[NSFileManager defaultManager] fileExistsAtPath:[CSLogger sharedInstance].exceptionFilePath]){
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[CSLogger sharedInstance].exceptionFilePath];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
        }else{
         [logStr writeToFile:[CSLogger sharedInstance].exceptionFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

+ (void)exceptionProcessCompleted{
    [self unsetCatchAppException];
    @throw _exception;
}
@end

//void CSLogDebug(NSString *format, ...){
//#if DEBUG
//    fprintf(stderr, "-----------------------------------------\n");
//    fprintf(stderr, "Type DEBUG\n");
//    fprintf(stderr, "File: %s / Func: %s / Line: %d\n",
//            [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],
//            __func__, __LINE__);
//    va_list args;
//    va_start(args, format);
//    fprintf(stderr,"%s",[[[NSString alloc] initWithFormat:format arguments:args] UTF8String]);
//    va_end(args);
//    fprintf(stderr, "\n-----------------------------------------\n\n");
//#endif
//}

//void CSLogError(NSString *format, ...){
//    NSMutableString *errorInfo = [NSMutableString stringWithFormat:@"-----------------------------------------\nType Error\nFile: %s / Func: %s / Line: %d\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__, __LINE__];
//    va_list args;
//    va_start(args, format);
//    [errorInfo appendString:[[NSString alloc] initWithFormat:format arguments:args]];
//    va_end(args);
//    [errorInfo appendString:@"\n-----------------------------------------\n\n"];
//    if([CSLogger sharedInstance].errorWriteToFile){
//        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[CSLogger sharedInstance].errorFilePath];
//        [fileHandle seekToEndOfFile];
//        [fileHandle writeData:[errorInfo dataUsingEncoding:NSUTF8StringEncoding]];
//        [fileHandle closeFile];
//    }
//}


//捕获信号回调
void SignalHandler(int signo)
{
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signo] forKey:@"signal"];
    [userInfo setObject:[CSLogger backtrace] forKey:@"backtrace"];
    //创建一个OC异常对象
    NSException *ex = [NSException exceptionWithName:@"SignalException"
                                              reason:[NSString stringWithFormat:@"Signal %d was raised.\n",signo]
                                            userInfo:userInfo];
    [ex raise];
}
//异常处理回调
void exceptionHandler(NSException *exception){
    _exception = exception;
    [CSLogger sharedInstance].finished = @(NO);
    NSDictionary *userInfo = exception.userInfo;
    NSArray *stackArray = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:[[CSDeviceInfo new] deviceInformation]];
    [infoDict setObject:[NSDate date] forKey:@"Date/Time"];
    [infoDict setObject:name==nil?@"":name forKey:@"Exception name"];
    [infoDict setObject:reason==nil?@"":reason forKey:@"Exception reason"];
    [infoDict setObject:stackArray forKey:@"Call stack symbols"];
    [infoDict setObject:userInfo==nil?@"":userInfo forKey:@"User info"];
    [infoDict setObject:[exception callStackReturnAddresses] forKey:@"Call stack return Addresses"];

    NSString *exceptionInfo = [infoDict description];
    if([CSLogger sharedInstance].exceptionWriteToFile){
        [CSLogger appendExceptionLog:exceptionInfo];
    }

    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:exception,@"exp",exceptionInfo,@"info", nil];
    if([[NSThread currentThread] isMainThread]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kCSNotificationExceptionRaise object:nil userInfo:userInfoDict];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCSNotificationExceptionRaise object:nil userInfo:userInfoDict];
        });
    }
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);

    while (![[CSLogger sharedInstance].finished boolValue])
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            if(![mode isEqualToString:(__bridge NSString *)kCFRunLoopCommonModes]){
                CFRunLoopRunInMode((CFStringRef)mode, 0, false);
            }
        }
    }
    CFRelease(allModes);
    [CSLogger exceptionProcessCompleted];
}

