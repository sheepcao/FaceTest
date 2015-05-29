//
//  buyingViewController.h
//  Anime Face
//
//  Created by Eric Cao on 5/29/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "buyCellView.h"


@interface buyingViewController : UIViewController

@property (weak,nonatomic) id<closeBuyViewDelegate> closeDelegate;

@property (weak, nonatomic) IBOutlet UITableView *itemTable;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

- (IBAction)closeIAP:(id)sender;
@end
