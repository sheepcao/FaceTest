//
//  ViewController.h
//  Anime Face
//
//  Created by Eric Cao on 3/26/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "ios-ntp.h"
#import "buyOneViewController.h"

@interface ViewController : UIViewController<NetAssociationDelegate,closeBuyViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (strong,nonatomic) NSDictionary *GameDatas;
@property (weak, nonatomic) IBOutlet UIImageView *freeImage;
@property (weak, nonatomic) IBOutlet UIButton *oneBuy;

@property (strong,nonatomic) UIView *buyDiamondView;
@property (strong,nonatomic) buyOneViewController *myBuyOneController;

- (IBAction)getReward:(id)sender;
- (IBAction)store:(id)sender;

- (IBAction)enterGame:(UIButton *)sender;
- (IBAction)oneBuyClick:(id)sender;
@end

