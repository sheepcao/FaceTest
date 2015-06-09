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
@property (strong,nonatomic) UIImageView *flashImage;

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
//    arrayGifOpenBox=[[NSMutableArray array] init];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"luckyFinished"] isEqualToString:@"yes"]) {
        
        [self.freeTag setImage:[UIImage imageNamed:@"20diamond"]];
        
    }else
    {
        [self.freeTag setImage:[UIImage imageNamed:@"free"]];
    }
    


//    for (int i = 0; i<7; i++) {
//        [arrayGifOpenBox addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tanchu%d",i] ofType:@"png"]]];
//    }
    

    [self updateCollectionNum];

    [self spinwithView:self.spinView];
    
    //witch animation
    
    baseY = 0;
    
//    [self animateWitcth];
    
    [self performSelector:@selector(animateWitcth) withObject:nil afterDelay:0.9];
    
    NSString *diamond = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    
    if (diamond) {
        [self.diamondNum setText:diamond];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:StartDiamond forKey:@"diamond"];
        [self.diamondNum setText:StartDiamond];

        
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
    
    if(soundSwitch)
    {
    [CommonUtility tapSound:@"buyDiamond" withType:@"mp3"];
    }
    self.myBuyController = [[buyingViewController alloc] initWithNibName:@"buyingViewController" bundle:nil];
    self.myBuyController.closeDelegate =self;
    
    [self.myBuyController view];
    
    self.buyView = self.myBuyController.view;
    [self.view addSubview:self.buyView];
    
    
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    

    
}




-(BOOL)checkDiamond:(int)price;
{
    int diamondRemain = [[[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"] intValue];
    
    return diamondRemain>=price;
}

-(void)makeDiamondLabel:(NSString *)diamondNum
{
    [self.diamondNum setText:diamondNum];
}

-(void)closingBuy
{
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];
    
    
}


- (IBAction)cardTapped:(id)sender {
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"cardClose" withType:@"mp3"];
    }
    
    [self.rewardView setHidden:YES];
    [self.spinView setHidden:YES];
    [self.boxImage setImage:[UIImage imageNamed:@"box-normal.png"]];


}

- (IBAction)backTapped:(id)sender {
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    shouldFinish = YES;
    [self.delegateRefresh refreshLists];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)start:(UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"luckyFinished"] isEqualToString:@"no"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"luckyFinished"];
        
        [self.freeTag setImage:[UIImage imageNamed:@"20diamond"]];
    
    }else
    {
        if([self checkDiamond:20])
        {
            [self costDiamond:20];

        }else
        {
            UIView *alertBack = [[UIView alloc] initWithFrame:self.view.frame];
            [alertBack setBackgroundColor:[UIColor clearColor]];
            
            
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, SCREEN_HEIGHT+10, 280, 185)];
            alertView.alpha = 0.0f;
            [alertBack addSubview:alertView];
            
            [self.view addSubview:alertBack];
            UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 185)];
            [backImg setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"diamond not enough board" ofType:@"png"]]];
            [alertView addSubview:backImg];
            
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2-90, alertView.frame.size.height-80, 70, 42)];
            [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            [cancelBtn setImage:[UIImage imageNamed:@"cancel-press"] forState:UIControlStateHighlighted];
            [cancelBtn addTarget:self action:@selector(cancelAlert:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2+20, alertView.frame.size.height-80, 70, 42)];
            [sureBtn setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
            [sureBtn setImage:[UIImage imageNamed:@"sure-press"] forState:UIControlStateHighlighted];
            [sureBtn addTarget:self action:@selector(sureAlert:) forControlEvents:UIControlEventTouchUpInside];
            
            [alertView addSubview:sureBtn];
            [alertView addSubview:cancelBtn];
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            
            [alertView setFrame:CGRectMake((SCREEN_WIDTH-280)/2, (SCREEN_HEIGHT-185)/2, 280, 185)];
            alertView.alpha = 1;
            
            [UIView commitAnimations];
            
            
            return;
        }
    }
    


    [CommonUtility tapSound:@"boxOpen" withType:@"mp3"];
    [self.productView stopAnimating];
    [self.productView setHidden:YES];
    
    [self.boxImage setImage:[UIImage imageNamed:@"box-open.png"]];

    self.flashImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"halo"]];
    [self.flashImage setFrame:CGRectMake(self.rewardView.center.x-5, self.rewardView.center.y-5, 10, 10)];
    [self.view addSubview:self.flashImage];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.flashImage setFrame:CGRectMake(self.rewardView.center.x-SCREEN_WIDTH, self.rewardView.center.y-SCREEN_WIDTH, SCREEN_WIDTH*2, SCREEN_WIDTH*2)];
    } completion:^(BOOL finished) {
        
        [self.flashImage removeFromSuperview];
        self.flashImage = nil;
        
        
        [self.spinView setHidden:NO];

        
        
    }];
    [self performSelector:@selector(showCard) withObject:nil afterDelay:0.15 ];
    
}

-(void)cancelAlert:(UIButton *)sender
{
    UIView *theAlertView = [[sender superview] superview];
    
    [theAlertView removeFromSuperview];
    
}

-(void)sureAlert:(UIButton *)sender
{
    UIView *theAlertView = [[sender superview] superview];
    
    [theAlertView removeFromSuperview];

    [self buyDaimond:nil];
    
    
}

-(void)spinwithView:(UIView *)spinningView
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 8.8; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [spinningView.layer addAnimation:rotation forKey:@"Spin"];
}


- (void)spinWithOptions: (UIViewAnimationOptions) options :(UIView *)destRotateView {
    
    CGFloat duration ;
    CGFloat spinAngle ;
    
    
    if(IS_IPAD)
    {
        duration = 0.5f;
        spinAngle = M_PI/8;
        
    }else
    {
        duration = 0.25f;
        spinAngle = M_PI/128;
    }
    
    [UIView animateWithDuration: duration
                          delay: 0.0f
                        options: options
                     animations: ^{
                         destRotateView.transform = CGAffineTransformRotate(destRotateView.transform, spinAngle );
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                                 
                                 [self spinWithOptions:UIViewAnimationOptionTransitionNone :destRotateView];
                                 
                             }
                         
                     }];
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

    
    
    
    [self.productName setText:self.productNow.productTitle];
    
    if ([self.productNow.productCategory isEqualToString:@"头发"] || [self.productNow.productCategory isEqualToString:@"头发女"]) {
        
        [self.faceImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"face0" ofType:@"png"]]];
        [self.bodyImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"body1" ofType:@"png"]]];
        

        NSArray *nameArray = [self.productNow.productName componentsSeparatedByString:@"-"];
        NSString *backImageName = @"";
        NSString *frontImageName = @"";
        if (nameArray.count>1) {
            backImageName = [NSString stringWithFormat:@"%@-%@-0-back",nameArray[0],nameArray[1]];
            frontImageName = [NSString stringWithFormat:@"%@-%@-0-front",nameArray[0],nameArray[1]];
            
        }
        UIImage *frontImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]];
        if (frontImage) {
            [self.productBought setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
        }
        
        UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]];
        if (backImage) {
            
            [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]]];
            //            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            
        }
    }else
    {
        [self.backHairImage setImage:nil];
        [self.faceImage setImage:nil];
        [self.bodyImage setImage:nil];
        [self.productBought setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.productNow.productName ofType:@"png"]]];


    }
    

    [self updateCollectionNum];

    
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
    self.productNow = [[product alloc] init];

    [self costDiamond:-10];
    self.productNow.productName = @"1";
    self.productNow.productTitle = @"111";
    [self.sexImage setImage:nil];



}

-(void)updateCollectionNum
{
    NSArray *luckyDoneArrayOld = [[NSUserDefaults standardUserDefaults] objectForKey:@"luckyDone"];
    NSMutableArray *luckyDoneArray = [NSMutableArray arrayWithArray:luckyDoneArrayOld];
    
    [self.collectionNum setText:[NSString stringWithFormat:@"%lu/30",(unsigned long)luckyDoneArray.count]];
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
    }else
    {
        [self doWrite];

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

        for (NSString *purchasedProduct in purchasedArray) {
            if ([purchasedProduct isEqualToString:newProductName] ||[purchasedProduct isEqualToString:self.productNow.productName] )
            {
                return;
            }
        }
        
        
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
//    NSLog(@"deeeeee");
//
//}

@end
