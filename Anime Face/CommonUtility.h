//
//  CommonUtility.h
//  ActiveWorld
//
//  Created by Eric Cao on 10/30/14.
//  Copyright (c) 2014 Eric Cao/Mady Kou. All rights reserved.
//




#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface CommonUtility : NSObject
{
    AVAudioPlayer *myAudioPlayer;
}

@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;

+ (CommonUtility *)sharedCommonUtility;
+ (BOOL)isSystemLangChinese;
+ (void)tapSound;
+ (void)tapSound:(NSString *)name withType:(NSString *)type;
+ (BOOL)isSystemVersionLessThan7;


+ (void)coinsChange:(int)coinAmount;
+ (int)fetchCoinAmount;


@end
