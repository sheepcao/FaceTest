//
//  productNow.h
//  Anime Face
//
//  Created by Eric Cao on 4/28/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface product : NSObject

@property int price;
@property int sex;//1 and 1000
@property (nonatomic,strong) NSString *productName;
@property (nonatomic, strong)NSString *productCategory;
@property int productNumber;


@end
