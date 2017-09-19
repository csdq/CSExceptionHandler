//  See: https://github.com/erica/uidevice-extension
//  CSDeviceInfo.h
//  CSLog
//
//  Created by mr.s on 2017/9/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING             @"iPhone 5"
#define IPHONE_5S_NAMESTRING             @"iPhone 5S"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6_Plus_NAMESTRING             @"iPhone 6 Plus"
#define IPHONE_6S_NAMESTRING             @"iPhone 6S"
#define IPHONE_6S_Plus_NAMESTRING             @"iPhone 6S Plus"
#define IPHONE_SE_NAMESTRING             @"iPhone SE"
#define IPHONE_7_NAMESTRING             @"iPhone 7"
#define IPHONE_7_Plus_NAMESTRING             @"iPhone 7 Plus"
#define IPHONE_8_NAMESTRING             @"iPhone 8"
#define IPHONE_8_Plus_NAMESTRING             @"iPhone 8 Plus"
#define IPHONE_X_NAMESTRING             @"iPhone X"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum {
    UIDeviceUnknown,

    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,

    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    UIDevice5CiPhone,
    UIDevice5SiPhone,
    UIDevice6iPhone,
    UIDevice6PlusiPhone,
    UIDevice6SiPhone,
    UIDevice6SPlusiPhone,
    UIDeviceSEiPhone,
    UIDevice7iPhone,
    UIDevice7PlusiPhone,
    UIDevice8iPhone,
    UIDevice8PlusiPhone,
    UIDeviceXiPhone,

    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,

    UIDevice1GiPad,
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,

    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,

    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,

} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,

} UIDeviceFamily;
@interface CSDeviceInfo : NSObject
- (NSDictionary *)deviceInformation;
@end
