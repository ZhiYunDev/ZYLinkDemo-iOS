//
//  AppDelegate.m
//  FimicSDK
//
//  Created by Liao GJ on 2019/8/5.
//  Copyright © 2019 Liao GJ. All rights reserved.
//

#import "AppDelegate.h"
#import <ZYDeviceSDK/ZYDeviceSDK.h>

//#define kPrivatesecretKey @"-----BEGIN PRIVATE KEY-----MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCogpIMV1c139qkHHN7TBoXT1EiaeRquOwqus1P88Un4Hco3QttsTZahBXQucRvlKw82TtBpYadlpkgeGqZWEV19WHDhdWk9iYCBSLht1zh8cB8MpLrDnrR++cBdN4Ys0b0JstNwmGdZTT+qSoZ+DzG+110L8wI6lBQjvorcm3VL78NeyoVqkhi32zpEumRnAkl//pFLw9ELg5KVG4BQtCgInCbLqKXYj32USnpvg2YiLwzNEy8yoz9jMs6hQJkUaQYm5jYHgOze5vGTVGnm91y0PDObANPZ9Vcs3tEiP6fzKFu8YUKdXefdEYUwWSl0fYMKsD3aF1MeZy0mz6sf9VXAgMBAAECggEATKx8v9jN+dmNpra7ZRLPnGOey0XbhSP3ccnlucd1ohtknNdXZ+YGkVEgjAS6+PpxFI7Tg59JjVMFAd1Iw9WCZZXtkgXHnHPT/39Oy92fCb/ykZCBgSrpf7pa9jKzDBIm6tjsEMmtmOyAHI/kdESbgv7FGyTUdgoH2V/1POeoSiPcn1d5gWd+j66EIw5AlIOt8QNJFLzoIjncf9q5aMfkulpDHOZtuT+jOIAkPmm22zRPEroqgiFU02iCVNgKmgMbFOUmkX6PMAu2SoL2wyR/jaJd36HPEG8YP6B9cmuY6KITB+t7yoEFDlQTWM3nrHw+we1DEFvYtrkOzEFwCoZhIQKBgQDvgyYGQjcmL79tDidcfqWn/WQyAwP5rEyvZtgSMcX+gj2Uv8sn7pifbiIDYysPWQj/i4W0EZQDG2/G0WvQu+8cixotYmk8ENXOFpCC4tRk79H9jb2Nf2TkBY7zXIfjYYmG0F9uXku24FYj8JgglgQkWMlH9dLcuf6quUCqaMUW3QKBgQC0HCvJvwsnfrslcXpNjowuXWCqjgHEQDHfglirT3WP7O9JEDlA5z08Y4yvPj0ZeKWX/SReqsScCtzbOdyFZNMecJ/HxpDSFiPyPSLjQE3i4HOAk4uMWrCOhc22NIDjk73V9Ti9cReo6640/Gt30zIYuu9sUjAWwCLrnied8tbnwwKBgD4zlSBy+deU9uXfkyFWUrc5+1dxqQqiUJgM4Xh4LK9YK54B4UTRlhlxhKvUiU5HFSsolOSa3BGignjj0lg3NnX3OiknMaVDygLnoUgcmIROM/7hXKTuvMjrGKDjGvdWUV0NqHsFSiyIPla/GQL9cr3twPhLQyPHufekfMLEysqRAoGADYpcpGMvdH2rlioM1s3TrhypCsl4SofE+Be1kNN9dB+M8cI9e6qmyOZ3Cim0sDiIwn9uf4t5En4iknysHn8w/AXdjUhZVOIDO8/q0ojgEiFrrYvqHtgmk+BtUbhqxDE0QWSZKmzZKYLmaudbMPv4tTFAlLUtFljFh08xjUdXbr8CgYEAx8CHukPJqGQDI0h3lZSoSQ36uNzq3FQXMMRVNQ5ZpgCVInMWZJoWxtFXKNx5D3/91VrhyCyHCILIIK5QKyBnoIOY640ml/DUrlmzvu5PzJ2czXETzVDzVC/XHAwy39Q2ZZ1HMQrWBEqOA2D/nBxTnQ+s1dDMw9ht0WFrLC59X60=-----END PRIVATE KEY-----"
//
//#define kCertificate @"eyJhdXRob3JpemF0aW9uIjoiTHNDQXJBbGlySTJBVTh4ajVncE4xWFFmU2hJS0lFaXFQMlNMazlvRnRKd2p4M0ZCUDd3RlEvZDZlelJUbkFFQlI4NVM5WTVWZitpVnNZVHVtMDh4OHlQc0lzRGpONTNkc0djcEkyR1Z6U0RsQUNiYWt3SWp6aEtkM0JDUmkxUFV2blpOWVh3NU0rUS9Mb0taR2xLOTYwcDNOQ1h6WVNCdFVLMFBZeVVMVmxjMlBHUm1taFZybDdod0hQblArMFltVXNlcWplbVVpQWZFeHpaaXAxYXNnUHRVVGpUUFplMm16RDcycWpEUldhZkdSYlliNUlYMXZUNDQxaWQ5R0FVRE5hNE1QV0RGNlZ5dEhBend6cnBHb3ZGaVJCVnkreXh0TXpIc0RKd1lYUXNkRGlFREpBZS9IM3J4YVpWNzFiNUsxQmdRbENrZUFGSnhQSjVNQTlYU3lBPT0iLCJzaWduYXR1cmUiOiJkeXEyYlRkdmRCYys1T1hhZzU4M2h1VlloUy96aVJuVjdOblI2NG9xOExjVFplZ3hkVHN6NG95b2FFdWxuQk5tdDBvWlRQU01wOU5QTXY5Tm1EYkhnaTllUXAxNlk4ZTR4ejVpR1FBT1NVeXQ3MXRFOE5aNmprdnZEbFJlZWVCalFxeGlvVDMwUlViRWphRnQwWjZiM2J4NzJqZUpBNmk3WUlvTFZzZFhpTXVSck4zdFRSQ0plUm1uSlh1S1ZmUDUyNUlFb2JyK0h3Tko3ZTVValJpb0t2Vm1VNmJjbVZ1dkNGWXZkbnh0bVdaRDBpZnB4cVJWcDJMYjJpVUVzRkZLdjVjQ3RoOFFoNGlMVzhoV3BtaklJdlU0QXNrQ2VyUGllMVJ1WmYxK1E4OVplQ1BwZVVkR3NwaCtTZ0pEemNUTytGRHBmV1lKWU9uR3FIcTdxSzFkeEE9PSJ9"
//
//
//#define kAppID @"6d84938d"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [ZYDeviceManager setAppId:kAppID  secretKey:kPrivatesecretKey];
//    [ZYDeviceManager validCertificate:kCertificate];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"json"];
    NSError *error;
    [ZYDeviceManager setCertPath:path error:&error];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
