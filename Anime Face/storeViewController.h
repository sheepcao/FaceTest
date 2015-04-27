//
//  storeViewController.h
//  Anime Face
//
//  Created by Eric Cao on 4/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "ViewController.h"

@interface storeViewController : ViewController
@property (strong, nonatomic) IBOutlet UIScrollView *catalogScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *productListScorll;

@property (strong, nonatomic) IBOutlet UIImageView *faceImage;
@property (strong, nonatomic) IBOutlet UIImageView *backHairImage;

@property (strong, nonatomic) IBOutlet UIImageView *productImage;

@property (strong, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIImageView *heart1;
@property (strong, nonatomic) IBOutlet UIImageView *heart2;
@property (strong, nonatomic) IBOutlet UIImageView *heart3;
@property (strong, nonatomic) IBOutlet UIImageView *heart4;
@property (strong, nonatomic) IBOutlet UIImageView *heart5;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;



@property (strong, nonatomic) IBOutlet UIView *loadingView;

@property (strong,nonatomic) NSDictionary *GameData;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV1;


- (IBAction)backTap:(id)sender;
- (IBAction)goLuckyHouse:(id)sender;
- (IBAction)addDiamond:(id)sender;

- (IBAction)colorBtnTapped:(UIButton *)sender;

@end
