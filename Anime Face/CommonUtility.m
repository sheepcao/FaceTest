//
//  CommonUtility.m
//  ActiveWorld
//
//  Created by Eric Cao on 10/30/14.
//  Copyright (c) 2014 Eric Cao/Mady Kou. All rights reserved.
//


#import "CommonUtility.h"

@implementation CommonUtility

@synthesize myAudioPlayer;

+(CommonUtility *)sharedCommonUtility
{
    static CommonUtility *singleton;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        singleton = [[CommonUtility alloc]init];
    });
    return singleton;
}

+ (BOOL)isSystemLangChinese
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    
    if([currentLang compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLang compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }else
    {
        return NO;
    }
}

//+(void)tapSound
//{
//    SystemSoundID soundTap;
//    
//    CFBundleRef CNbundle=CFBundleGetMainBundle();
//    
//    CFURLRef soundfileurl=CFBundleCopyResourceURL(CNbundle,(__bridge CFStringRef)@"tapSound",CFSTR("wav"),NULL);
//    //创建system sound 对象
//    AudioServicesCreateSystemSoundID(soundfileurl, &soundTap);
//    AudioServicesPlaySystemSound(soundTap);
//}

+(BOOL)isSystemVersionLessThan7{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    } else {
        return NO;
    }
}

+(void)tapSound:(NSString *)name withType:(NSString *)type
{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    
    NSError *error;
    
    NSData *data =[NSData dataWithContentsOfURL:fileURL];

    [CommonUtility sharedCommonUtility].myAudioPlayer  = [[AVAudioPlayer alloc] initWithData:data error:nil];

//    [CommonUtility sharedCommonUtility].myAudioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    NSLog(@"error is : %@",error);
    [CommonUtility sharedCommonUtility].myAudioPlayer.volume = 1.0f;
    [[CommonUtility sharedCommonUtility].myAudioPlayer play];
    
}

+ (BOOL)myContainsStringFrom:(NSString*)str for:(NSString*)other {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}


+ (void)coinsChange:(int)coinAmount
{

    NSString *currentCoinsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    int currentCoins = [currentCoinsString intValue];
    
    int afterCalculate = currentCoins + coinAmount;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",afterCalculate] forKey:@"diamond"];
    
}

+ (int)fetchCoinAmount
{
    NSString *currentCoinsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    int currentCoins = [currentCoinsString intValue];
    return currentCoins;
}



-(void)getCoinsTapped
{
    [CommonUtility coinsChange:1000];
    
}

@end
