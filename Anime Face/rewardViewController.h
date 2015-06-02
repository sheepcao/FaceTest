//
//  rewardViewController.h
//  Anime Face
//
//  Created by Eric Cao on 4/7/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "buyingViewController.h"

@interface rewardViewController : UIViewController<closeBuyViewDelegate>


@property (weak,nonatomic) id<refreshProductsDelegates>delegateRefresh;

@property (weak, nonatomic) IBOutlet UIButton *startReward;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (weak, nonatomic) IBOutlet UIImageView *boxImage;
@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UIImageView *popAnimation;

@property (weak, nonatomic) IBOutlet UIImageView *productCard;

@property (weak, nonatomic) IBOutlet UIImageView *productBought;
@property (weak, nonatomic) IBOutlet UIImageView *backHairImage;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImage;
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UIImageView *spinView;

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *diamondNum;
@property (weak, nonatomic) IBOutlet UIImageView *witch;
@property (strong,nonatomic) NSDictionary *GameData;
@property (weak, nonatomic) IBOutlet UIImageView *freeTag;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *collectionNum;

@property (strong,nonatomic) buyingViewController *myBuyController;
@property (strong,nonatomic) UIView *buyView;


- (IBAction)buyDaimond:(id)sender;

- (IBAction)cardTapped:(id)sender;

- (IBAction)backTapped:(id)sender;

- (IBAction)start:(id)sender;
@end
