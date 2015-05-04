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

@interface ViewController : UIViewController<NetAssociationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (strong,nonatomic) NSDictionary *GameDatas;

- (IBAction)getReward:(id)sender;
- (IBAction)store:(id)sender;

- (IBAction)enterGame:(UIButton *)sender;
@end

