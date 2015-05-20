//
//  AppDelegate.m
//  Anime Face
//
//  Created by Eric Cao on 3/26/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self setShareIDs];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

-(void)setShareIDs
{
    [ShareSDK registerApp:@"730881ade8b1"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"2305374668"
                               appSecret:@"789bf7b6c8c34f97cf98c70f037b8fa3"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];

    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2305374668"
                                appSecret:@"789bf7b6c8c34f97cf98c70f037b8fa3"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104652926"
                           appSecret:@"7EIO3RDSXnhYY7jN"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104652926"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx0f49518adaee1d8d"
                           wechatCls:[WXApi class]];
    
    
    [ShareSDK connectWeChatWithAppId:@"wx0f49518adaee1d8d"   //微信APPID
                           appSecret:@"08efd4c2f1ec37e953f1eccb7a712eb6"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"1587440558181010"
                              appSecret:@"81a6e951927f0dc14727c622c45f562b"];
    
    
}
@end
