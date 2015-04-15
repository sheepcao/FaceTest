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
@property (weak, nonatomic) IBOutlet APLPlacardView *backHairImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *bodyImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *faceFrameView;
@property (weak, nonatomic) IBOutlet APLPlacardView *faceImage;
@property (weak, nonatomic) IBOutlet APLPlacardView *eyebrowView;
@property (weak, nonatomic) IBOutlet APLPlacardView *eyeView;
@property (weak, nonatomic) IBOutlet APLPlacardView *mouthView;
@property (weak, nonatomic) IBOutlet APLPlacardView *noseView;
@property (weak, nonatomic) IBOutlet APLPlacardView *mustacheView;
@property (weak, nonatomic) IBOutlet APLPlacardView *clothingView;
@property (weak, nonatomic) IBOutlet APLPlacardView *glassesView;
@property (weak, nonatomic) IBOutlet APLPlacardView *frontHairView;
@property (weak, nonatomic) IBOutlet APLPlacardView *hatView;
@property (weak, nonatomic) IBOutlet APLPlacardView *gestureView;
@property (weak, nonatomic) IBOutlet APLPlacardView *petView;
@property (weak, nonatomic) IBOutlet UIImageView *toptextView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomtextView;
@property (weak, nonatomic) IBOutlet APLPlacardView *moodView;

@property (weak, nonatomic) IBOutlet UIImageView *loadingView;
@property (strong, nonatomic) IBOutlet UIView *loadPage;

- (IBAction)backTapp:(id)sender;
- (IBAction)storeTap:(id)sender;
- (IBAction)luckyHouseTap:(id)sender;
- (IBAction)saveAndShare:(id)sender;


@property (strong,nonatomic) NSDictionary *GameData;
@property int sex;//1:male  1000:female


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveMeViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveMeViewTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewTrailing;

@end
