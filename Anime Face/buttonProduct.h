//
//  buttonProduct.h
//  Anime Face
//
//  Created by Eric Cao on 4/27/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "elemntButton.h"

@interface buttonProduct : elemntButton

@property int price;
@property (nonatomic, strong) NSString *titleName;
@property int stars;
@property int colorNum;
@property int sex;//1:boy,1000:girl

@end
