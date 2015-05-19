//
//  rewardViewController.h
//  Anime Face
//
//  Created by Eric Cao on 4/7/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"

@interface rewardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startReward;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (strong, nonatomic) IBOutlet UIImageView *boxImage;
@property (strong, nonatomic) IBOutlet UIView *rewardView;
@property (strong, nonatomic) IBOutlet UIImageView *popAnimation;

@property (strong, nonatomic) IBOutlet UIImageView *productCard;

@property (strong, nonatomic) IBOutlet UIImageView *productBought;

- (IBAction)cardTapped:(id)sender;

- (IBAction)backTapped:(id)sender;

- (IBAction)start:(id)sender;
@end
