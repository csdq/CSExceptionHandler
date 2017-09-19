//
//  ViewController.m
//  TestApp
//
//  Created by csdq on 2016/8/2.
//  Copyright © 2016年 CSDQ. All rights reserved.
//

#import "ViewController.h"
#import "CSLogger.h"
@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CSLogDebug(@"CSDebug Test %@",@"Arguments");
    CSLogError(@"Error: %@ %d %@",@"测试数据",111,[NSDate date]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:kCSNotificationExceptionRaise object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //
        NSString *str1 = nil;
        NSArray *arr = @[str1];
//        str1 = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSArray *arr2 = @[str1];
            [((NSMutableArray *)arr) removeAllObjects];
        });
    });

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSString *str1 = nil;
//    NSArray *arr = @[str1];
}

- (void)showAlert:(NSNotification *)noti{
    CSLogDebug(@"Thread:%@",[NSThread currentThread]);
    NSString *info = [noti.userInfo description];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"crash" message:info preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CSLogDebug(@"process crash");
        [CSLogger exceptionProcessCompleted];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
