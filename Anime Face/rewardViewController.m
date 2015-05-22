//
//  rewardViewController.m
//  Anime Face
//
//  Created by Eric Cao on 4/7/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "rewardViewController.h"
#import "imageWithName.h"
#import "productNow.h"

@interface rewardViewController ()

@property (nonatomic,strong) NSMutableArray *arrayGif;
@property (nonatomic,strong) NSMutableArray *arrayGifOpenBox;
@property CGFloat baseY;
@property (strong,nonatomic) product *productNow;

//@property (nonatomic,strong) NSArray *imageOptins;

@end

@implementation rewardViewController
@synthesize arrayGif;
@synthesize arrayGifOpenBox;
@synthesize baseY;

bool shouldFinish;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;

    [self.rewardView setHidden:YES];
    shouldFinish = NO;

    arrayGif=[[NSMutableArray array] init];
    arrayGifOpenBox=[[NSMutableArray array] init];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"luckyFinished"] isEqualToString:@"yes"]) {
        
        [self.freeTag setImage:[UIImage imageNamed:@"20diamond"]];
        
    }else
    {
        [self.freeTag setImage:[UIImage imageNamed:@"free"]];
    }
    


    for (int i = 0; i<7; i++) {
        [arrayGifOpenBox addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tanchu%d",i] ofType:@"png"]]];
    }
    

    

    //witch animation
    
    baseY = 0;
    
//    [self animateWitcth];
    
    [self performSelector:@selector(animateWitcth) withObject:nil afterDelay:0.9];
    
    NSString *diamond = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    
    if (diamond) {
        [self.diamondNum setText:diamond];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1000" forKey:@"diamond"];
        [self.diamondNum setText:@"1000"];
        
    }

}



-(void)animateWitcth
{
    
    if (shouldFinish) {
        return;
    }
    
    CGPoint center = self.witch.center;
    CGFloat centerY = center.y;

    
    if (baseY <0.001) {
        baseY = centerY;
    }

    
    
    CGPoint yBig = CGPointMake(center.x,baseY +12);
    CGPoint ySmall = CGPointMake(center.x,baseY-12);

    if (centerY>=baseY) {
        [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.witch setCenter:ySmall];
        } completion:^(BOOL finished) {
           
            [self animateWitcth];
            
        }];

    }else
    {
        [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.witch setCenter:yBig];
        } completion:^(BOOL finished) {
            
            [self animateWitcth];
            
        }];
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buyDaimond:(id)sender {
}

- (IBAction)cardTapped:(id)sender {
    
    [self.rewardView setHidden:YES];
    [self.boxImage setImage:[UIImage imageNamed:@"box-normal.png"]];


}

- (IBAction)backTapped:(id)sender {
    
    shouldFinish = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)start:(UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"luckyFinished"] isEqualToString:@"no"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"luckyFinished"];
        
        [self.freeTag setImage:[UIImage imageNamed:@"20diamond"]];
    
    }else
    {
        [self costDiamond:20];
    }
    


    [CommonUtility tapSound:@"boxOpen" withType:@"mp3"];
    [self.productView stopAnimating];
    [self.productView setHidden:YES];
    
    [self.boxImage setImage:[UIImage imageNamed:@"box-open.png"]];
    if (arrayGifOpenBox.count>0) {
        //设置动画数组
        [self.popAnimation setAnimationImages:arrayGifOpenBox];
        
        //设置动画播放次数
        [self.popAnimation setAnimationRepeatCount:1];
        //设置动画播放时间
        [self.popAnimation setAnimationDuration:0.35];
        //开始动画
        [self.popAnimation startAnimating];
        
        
    }
    [self performSelector:@selector(showCard) withObject:nil afterDelay:0.15 ];
    
}

-(void)showCard
{
    [self.rewardView setHidden:NO];
       [self.productCard setImage:[UIImage imageNamed:@"card"]];
    NSLog(@"frame:%@",self.productName);
    
    int random =  arc4random() % 100;
    NSLog(@"random number :%d",random);
    
    if (random<20) {
        [self getProductFrom:@"productInfo"];
    }else if(random<60)
    {
        [self getProductFrom:@"luckyProducts"];

    }else
    {
        [self getDiamonds];

    }

    
    
    
    [self.productBought setImage:[UIImage imageNamed:self.productNow.productName]];
    [self.productName setText:self.productNow.productTitle];
    


    
}


-(void)getProductFrom:(NSString *)productFrom
{
    NSMutableArray *catalogArray = [[NSMutableArray alloc] init];
    NSMutableArray *catalogKeysArray = [[NSMutableArray alloc] init];
    
    NSArray *keyArray = @[@"宠物",@"背景",@"帽子",@"脸饰",@"心情",@"鼻子",@"眼镜",@"手势",@"嘴巴",@"眼眉",@"眼睛",@"衣服",@"胡子",@"头发",@"脸型"];
    
    
    NSDictionary *luckyProductsDic = [self.GameData objectForKey:productFrom];
    
    for(int i = 0;i<keyArray.count;i++)
    {
        if ([luckyProductsDic objectForKey:keyArray[i]] &&[[luckyProductsDic objectForKey:keyArray[i]] count]>0) {
            [catalogArray addObject:[luckyProductsDic objectForKey:keyArray[i]]];
            [catalogKeysArray addObject:keyArray[i]];
        }
    }
    if(catalogArray.count == 0)
    {
        NSLog(@"no more products...");
        return;
    }
    int selected =  arc4random() % catalogArray.count;
    int selectedElement =  arc4random() % [catalogArray[selected] count];
    NSDictionary *randomProduct = [catalogArray[selected] objectAtIndex:selectedElement];
    
    
    NSString *elementImageName = [randomProduct objectForKey:@"name"];
    int elementPrice =[[randomProduct objectForKey:@"price"] intValue];
    //    int elementStars =[[randomProduct objectForKey:@"star"] intValue];
    //    int elementColors =[[randomProduct objectForKey:@"colorNum"] intValue];
    int elementSex =[[randomProduct objectForKey:@"sex"] intValue];
    NSString *elementTitle = [randomProduct objectForKey:@"title"];
    NSString *isSold = [randomProduct objectForKey:@"isSold"];
    
    self.productNow = [[product alloc] init];
    self.productNow.price = elementPrice;
    self.productNow.sex = elementSex;
    self.productNow.productName = elementImageName;
    self.productNow.productCategory = catalogKeysArray[selected];
    self.productNow.isSold = isSold;
    self.productNow.productTitle = elementTitle;
    self.productNow.productNumber = selectedElement;
    

    [self writeToPurchased];
    if ([productFrom isEqualToString:@"productInfo"]) {
        
        [self modifyItemFromPlist:@"GameData" withCatelog:self.productNow.productCategory andElementNum:self.productNow.productNumber];
    }else
    {
        BOOL hasThisProduct = NO;
        NSArray *luckyDoneArrayOld = [[NSUserDefaults standardUserDefaults] objectForKey:@"luckyDone"];
        NSMutableArray *luckyDoneArray = [NSMutableArray arrayWithArray:luckyDoneArrayOld];
        for (NSString *oneProduct in luckyDoneArray) {
            if ([oneProduct isEqualToString:self.productNow.productName]) {
                hasThisProduct =YES;
                break;
            }
        }
        if (!hasThisProduct) {
            [luckyDoneArray addObject:self.productNow.productName];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:luckyDoneArray forKey:@"luckyDone"];
    }

    self.GameData = [self readDataFromPlist:@"GameData"];
    

    NSString *sexIcon = @"common";
    if (self.productNow.sex == 1) {
        sexIcon = @"male";
    }else if (self.productNow.sex == 1000)
    {
        sexIcon = @"female";
    }
    [self.sexImage setImage:[UIImage imageNamed:sexIcon]];
    


}

-(void)getDiamonds
{
    [self costDiamond:-10];
    self.productNow.productName = @"1";
    self.productNow.productTitle = @"111";
    [self.sexImage setImage:nil];



}

-(void)costDiamond:(int)price
{
    int diamondRemain = [[[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"] intValue];
    NSString *diamondNow =[NSString stringWithFormat:@"%d",diamondRemain - price];
    
    [[NSUserDefaults standardUserDefaults] setObject:diamondNow forKey:@"diamond"];
    
    [self.diamondNum setText:diamondNow];
    
    
}

-(void)writeToPurchased
{
    
    if (self.productNow.sex == 1000) {
        if ([self.productNow.productCategory isEqualToString:@"衣服"] ||[self.productNow.productCategory isEqualToString:@"头发"] ) {
            self.productNow.productCategory = [self.productNow.productCategory stringByAppendingString:@"女"];

        }
        [self doWrite];

    }else if ((self.productNow.sex == 0))
    {
        [self doWrite];
        if ([self.productNow.productCategory isEqualToString:@"衣服"] ||[self.productNow.productCategory isEqualToString:@"头发"] ) {
            self.productNow.productCategory = [self.productNow.productCategory stringByAppendingString:@"女"];
            
            [self doWrite];

        }
    }
    
}

-(void)doWrite
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.productNow.productCategory]) {
        
        
        NSMutableDictionary *purchasedCatelog = [[NSMutableDictionary alloc] init];
        [purchasedCatelog setObject:@"yes" forKey:@"haveNew"];
        
        NSMutableDictionary *purchasedDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:self.productNow.productCategory]];
        
        NSMutableArray *purchasedArray = [NSMutableArray arrayWithArray:[purchasedDic objectForKey:@"purchasedArray"]];
        
        
        NSString *newProductName = [NSString stringWithFormat:@"%@+new",self.productNow.productName];
        [purchasedArray addObject:newProductName];
        [purchasedCatelog setObject:purchasedArray forKey:@"purchasedArray"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:self.productNow.productCategory];
        
        
    }else
    {
        NSMutableDictionary *purchasedCatelog = [[NSMutableDictionary alloc] init];
        [purchasedCatelog setObject:@"yes" forKey:@"haveNew"];
        
        NSMutableArray *purchasedArray = [[NSMutableArray alloc] init];
        
        NSString *newProductName = [NSString stringWithFormat:@"%@+new",self.productNow.productName];
        [purchasedArray addObject:newProductName];
        
        [purchasedCatelog setObject:purchasedArray forKey:@"purchasedArray"];
        
        [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:self.productNow.productCategory];
    }
    
}

-(void)modifyItemFromPlist:(NSString *)plistname withCatelog:(NSString *)catelog andElementNum:(int)elementNum
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath] == YES)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            NSMutableDictionary *allProducts = [infoDict objectForKey:@"productInfo"];
            NSMutableDictionary *productTobeChanged= [[allProducts objectForKey:catelog] objectAtIndex:elementNum];
//            NSString *removeName = [productTobeRemoved objectForKey:@"name"];
            [productTobeChanged setObject:@"yes" forKey:@"isSold"];
            
//            [[allProducts objectForKey:catelog] removeObjectAtIndex:elementNum];
            [infoDict setObject:allProducts forKey:@"productInfo"];
            
//            if ([[productTobeRemoved objectForKey:@"existsAll"] isEqualToString:@"yes"]) {
//                
//                NSMutableDictionary *allStoreProducts = [infoDict objectForKey:@"productInfo"];
//                NSMutableArray *StoreArray = [allStoreProducts objectForKey:catelog];
//                NSMutableArray *StoreArrayTemp = [[allStoreProducts objectForKey:catelog] copy];
//                
//                
//                [StoreArrayTemp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if ([[obj objectForKey:@"name"] isEqualToString:removeName])
//                    {
//                        [StoreArray removeObjectAtIndex:idx];
//                    }
//                }];
//                
//                [infoDict setObject:allStoreProducts forKey:@"productInfo"];
//                
//                [infoDict writeToFile:plistPath atomically:NO];
//
//            }
//            
            
            [infoDict writeToFile:plistPath atomically:NO];

            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:plistPath error:nil];
        }
    }
}

-(NSMutableDictionary *)readDataFromPlist:(NSString *)plistname
{
    //read level data from plist
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSMutableDictionary *levelData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //    NSLog(@"levelData%@",levelData);
    return levelData;
    
}

//-(void)dealloc
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//
//}

@end
