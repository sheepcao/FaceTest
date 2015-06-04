//
//  storeViewController.h
//  Anime Face
//
//  Created by Eric Cao on 4/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "ViewController.h"
#import "elemntButton.h"
#import "buyingViewController.h"

@interface storeViewController : UIViewController<closeBuyViewDelegate>

@property (weak,nonatomic) id<refreshProductsDelegates>delegateRefresh;

@property (weak, nonatomic) IBOutlet UIScrollView *catalogScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *productListScorll;

@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UIImageView *backHairImage;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImage;

@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *heart1;
@property (weak, nonatomic) IBOutlet UIImageView *heart2;
@property (weak, nonatomic) IBOutlet UIImageView *heart3;
@property (weak, nonatomic) IBOutlet UIImageView *heart4;
@property (weak, nonatomic) IBOutlet UIImageView *heart5;

@property (weak, nonatomic) IBOutletCollection(elemntButton) NSArray *colorButtons;

@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;


@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (strong,nonatomic) NSDictionary *GameData;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonDistanceV1;



@property (strong,nonatomic) buyingViewController *myBuyController;
@property (strong,nonatomic) UIView *buyView;

@property (strong,nonatomic) UITableView *itemsToBuy;
@property (nonatomic,strong) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
@property (weak, nonatomic) IBOutlet UIView *loadingBuy;

- (IBAction)backTap:(id)sender;
- (IBAction)goLuckyHouse:(id)sender;
- (IBAction)addDiamond:(id)sender;

//- (IBAction)colorBtnTapped:(elemntButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *buyAction;
- (IBAction)buyProduct:(id)sender;

@end
