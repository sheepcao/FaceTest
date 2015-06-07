//
//  buyOneViewController.h
//  Anime Face
//
//  Created by Eric Cao on 5/29/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"

@interface buyOneViewController : UIViewController
@property (weak,nonatomic) id<closeBuyViewDelegate> closeDelegate;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

- (IBAction)buyOneTap:(id)sender;
- (IBAction)closeBuy:(id)sender;

@end