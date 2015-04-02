//
//  gameViewController.h
//  Anime Face
//
//  Created by Eric Cao on 3/31/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "ViewController.h"
#import "globalVar.h"
#import "APLMoveMeView.h"
//#import "APLPlacardView.h"

@interface gameViewController : ViewController
@property (weak, nonatomic) IBOutlet APLMoveMeView *headImage;
@property (weak, nonatomic) IBOutlet UIScrollView *catalogScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *ListsScroll;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *faceImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *backHairImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *bodyImage;

@property (strong,nonatomic) NSDictionary *GameData;

@end
