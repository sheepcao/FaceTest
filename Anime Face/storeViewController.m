//
//  storeViewController.m
//  Anime Face
//
//  Created by Eric Cao on 4/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "storeViewController.h"
#import "buttonProduct.h"
#import "productNow.h"
#import "rewardViewController.h"


@interface storeViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic) NSArray *heartArray;
@property (strong,nonatomic) buttonProduct *defaultButton;
@property (strong,nonatomic) product *productNow;

@end

@implementation storeViewController


int sexSelectedNow;
bool showingDefault;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:@"store"];

    // Do any additional setup after loading the view from its nib.
    
    self.heartArray = @[self.heart1,self.heart2,self.heart3,self.heart4,self.heart5];
    [self.loadingView setHidden:NO];
    [self.view bringSubviewToFront:self.loadingView];
    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupLists) withObject:nil afterDelay:0.9];
    
    NSString *diamond = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    
    if (diamond) {
        [self.diamondLabel setText:diamond];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:StartDiamond forKey:@"diamond"];
        [self.diamondLabel setText:StartDiamond];

    }
    
    if (IS_IPHONE_6P) {
        self.productName.font = [UIFont boldSystemFontOfSize:18.5];
    }
    
    
}

-(void)refreshProducts
{

    for (UIView *subs in [self.productListScorll subviews] ) {
        if ([subs isKindOfClass:[UIScrollView class]]) {
            [subs removeFromSuperview];
        }
        
    }
//    showingDefault = YES;
    [self setupLists];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    showingDefault = YES;
}

-(void)setDefaultView:(buttonProduct *)button
{
    [self elementTapped:button];
    showingDefault = NO;
}

#pragma mark setup Catalog
-(void)setupCatalog
{
    
    [self.catalogScroll setContentSize:CGSizeMake(CATALOG_NUM_STORE*CATALOG_BUTTON_WIDTH, 0)];
    
//    self.catalogScroll.pagingEnabled = YES;

    self.catalogScroll.canCancelContentTouches = YES;
    
    
    NSArray *catalogText = [self.GameData objectForKey:@"catalogStore"];
    
    for (int i = 0 ; i < catalogText.count; i++) {
        UIButton *catalogBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*CATALOG_BUTTON_WIDTH, 0, CATALOG_BUTTON_WIDTH, 40)];
        //        [catalogBtn setTitle:catalogText[i] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:catalogText[i] ofType:@"png"]] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@1",catalogText[i]] ofType:@"png"]] forState:UIControlStateSelected];
        
        
        [catalogBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, 15, 4, 16)];
        
        catalogBtn.tag = i;
        [catalogBtn addTarget:self action:@selector(catalogTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.catalogScroll addSubview:catalogBtn];
        
        if(i==0)
        {
            [catalogBtn setSelected:YES];
        }
        
    }
//    
//    if(IS_IPHONE_4_OR_LESS)
//    {
//
//        
//        [self.buttonDistanceV1 setConstant:3];
//        [self.buttonDistanceV2 setConstant:3];
//        [self.buttonDistanceV3 setConstant:3];
//        
//        [self.view setNeedsUpdateConstraints];
//        [self.view layoutIfNeeded];
//    }
    
    
}

-(void)catalogTapped:(UIButton *)sender
{
    NSLog(@"tag:%ld",(long)sender.tag);

    [self scrollToCatalog:sender.tag];
    [self.productListScorll setContentOffset:CGPointMake(SCREEN_WIDTH * sender.tag, 0)];
    
    for (UIView *onelist in [self.productListScorll subviews]) {
        if ([onelist isKindOfClass:[UIScrollView class]]) {
            for (UIView *btn in [onelist subviews]) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)btn;
                    if (button.isSelected) {
                        [button setSelected:NO];
                    }
                }
            }
        }
    }
 
    
    UIView *superView = [sender superview];
    for (UIView *subView in [superView subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            [subBtn setSelected:NO];
        }
    }
    [sender setSelected:YES];
    
    
    
}
-(void)scrollToCatalog:(NSInteger)BtnTag

{
    [CommonUtility tapSound:@"catalog" withType:@"mp3"];

    
    UIButton * catalogBtn =(UIButton *)[self.catalogScroll viewWithTag:BtnTag];
    [self.catalogScroll setContentOffset:CGPointMake((catalogBtn.center.x - self.catalogScroll.center.x), 0) animated:YES];
    
    
}

#pragma mark setup Lists
-(void)setupLists
{
//    [self.productListScorll setFrame:CGRectMake(0, self.catalogScroll.frame.origin.y+self.catalogScroll.frame.size.height, SCREEN_WIDTH, self.productListScorll.frame.size.height)];
    [self.productListScorll setContentSize:CGSizeMake(CATALOG_NUM_STORE*SCREEN_WIDTH,0)];
    self.productListScorll.canCancelContentTouches = YES;
    self.productListScorll.pagingEnabled = YES;
    self.productListScorll.bounces = NO;
    self.productListScorll.showsHorizontalScrollIndicator = NO;
    self.productListScorll.delegate = self;
    
    NSDictionary *listsText = [self.GameData objectForKey:@"productInfo"];


    int emptyCount = 0;
    
    for (int i = 0 ; i < CATALOG_NUM_STORE; i++) {
        NSArray *listElements = [listsText objectForKey:[[self.GameData objectForKey:@"catalogStore"] objectAtIndex:i]];
        
        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.productListScorll.frame.size.height)];
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,10+(1+listElements.count/3)*(ELEMENT_WIDTH/1.2))];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;
        
        
        
        [self.productListScorll addSubview:oneList];
        
        
        
        if (listElements.count == 0) {
           //to be empty ....
            emptyCount ++;
        }
        
        
        for (int j = 0 ; j<listElements.count; j++) {
            
            NSString *elementImageName = [listElements[j] objectForKey:@"name"];
            int elementPrice =[[listElements[j] objectForKey:@"price"] intValue];
            int elementStars =[[listElements[j] objectForKey:@"star"] intValue];
            int elementColors =[[listElements[j] objectForKey:@"colorNum"] intValue];
            int elementSex =[[listElements[j] objectForKey:@"sex"] intValue];
            NSString *elementTitle = [listElements[j] objectForKey:@"title"];
            NSString *isSold = [listElements[j] objectForKey:@"isSold"];




            
            buttonProduct *element = [[buttonProduct alloc] initWithFrame:CGRectMake(0+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            
            CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
            
            [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];
            
            [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-yulan",elementImageName] ofType:@"png"]] forState:UIControlStateNormal];
            element.imageName = elementImageName;
            element.imageLevel =[NSNumber numberWithInt:i];
            element.price = elementPrice;
            element.sex = elementSex;
            element.titleName = elementTitle;
            element.isSold = isSold;
            element.producrNum = j;
            element.catelogName =[[self.GameData objectForKey:@"catalogStore"] objectAtIndex:i];
            
            
            if (i == 0)//hair list
            {
                element.colorNum = elementColors;
            }
        
            element.stars = elementStars;
            
            
            if (showingDefault) {
                [self setDefaultView:element];
            }
            
            [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
            [element setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]] forState:UIControlStateNormal];
            [element setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame selected" ofType:@"png"]] forState:UIControlStateSelected];
            
            
            if([element.isSold isEqualToString:@"yes"])
            {
                UIImageView *isSoldImg = [[UIImageView alloc] initWithFrame:CGRectMake(ELEMENT_WIDTH/5, element.frame.size.height/2-ELEMENT_WIDTH*3*11/208, ELEMENT_WIDTH*3/5, ELEMENT_WIDTH*3*22/208)];
                [isSoldImg setImage:[UIImage imageNamed:@"sold out"]];
                [element addSubview:isSoldImg];
            }
            
//            if (j == 0) {
//                
//                [element setSelected:YES];
//            }
            
            NSLog(@"button:%@",element);
            [oneList addSubview:element];
            
        }
        
    }
    
    if (emptyCount == CATALOG_NUM_STORE) {
        [self.productImage setImage: nil];
        [self.faceImage setImage: nil];
        [self.bodyImage setImage: nil];

        [self.backHairImage setImage: nil];
    }
    
//    if (showingDefault) {
//        [self setDefaultView:self.defaultButton];
//    }

    
    [self.loadingView setHidden:YES];
    
}
-(void)elementTapped:(buttonProduct *)sender
{
    NSLog(@"element:%@",sender.imageLevel);
    
    UIView *superView = [sender superview];
    for (UIButton *subBtn in [superView subviews]) {
        [subBtn setSelected:NO];
    }
    [sender setSelected:YES];
    
    [self.priceLabel setText:[NSString stringWithFormat:@"%d",sender.price]];
    
//    [self drawStars:sender.stars];

    sexSelectedNow = sender.sex;
    
    self.productNow = [[product alloc] init];
    self.productNow.price = sender.price;
    self.productNow.sex = sender.sex;
    self.productNow.productName = sender.imageName;
    self.productNow.productCategory = sender.catelogName;
    self.productNow.productNumber = sender.producrNum;
    self.productNow.isSold = sender.isSold;
    self.productNow.productTitle = sender.titleName;

    
    [self.productName setText:sender.titleName];

    if ([sender.imageLevel intValue]==0) {
        
//        if (!self.starView.isHidden) {
//            [self.starView setHidden:YES];
//        }
        //not decide color ...
//        if (self.colorView.isHidden) {
//            [self.colorView setHidden:NO];
//        }
        
        [self.faceImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"face0" ofType:@"png"]]];
        [self.bodyImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shop body" ofType:@"png"]]];

        NSArray *nameArray = [sender.imageName componentsSeparatedByString:@"-"];
        NSString *backImageName = @"";
        NSString *frontImageName = @"";
        if (nameArray.count>1) {
            backImageName = [NSString stringWithFormat:@"%@-%@-%d-back",nameArray[0],nameArray[1],sender.colorNum];
            frontImageName = [NSString stringWithFormat:@"%@-%@-%d-front",nameArray[0],nameArray[1],sender.colorNum];
            
        }
        
        UIImage *frontImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]];
        if (frontImage) {
            [self.productImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
        }
        
        
        UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]];
        if (backImage) {
            
            [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]]];
            //            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            
        }
        
//        [self drawColors:sender.colorNum withImageName:sender.imageName];

        
    }else
    {
//        if (self.starView.isHidden) {
//            [self.starView setHidden:NO];
//        }
        if (!self.colorView.isHidden) {
            [self.colorView setHidden:YES];
        }
        
        [self.backHairImage setImage:nil];
        [self.faceImage setImage:nil];
        [self.bodyImage setImage:nil];

//        NSArray *nameArray = [sender.imageName componentsSeparatedByString:@"-"];
//        NSString *backImageName = @"";
//        NSString *frontImageName = @"";
//        if (nameArray.count>1) {
//            backImageName = [NSString stringWithFormat:@"%@-%@-0-back",nameArray[0],nameArray[1]];
//            frontImageName = [NSString stringWithFormat:@"%@-%@-0-front",nameArray[0],nameArray[1]];
//            
//        }
//        
//        if (frontImageName) {
//            [self.productImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
//        }

        NSString *frontImageName = sender.imageName;
        [self.productImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
    }
    
    if (sender.stars>0) {
        [self.hotImage setHidden:NO];
    }else
    {
        [self.hotImage setHidden:YES];

    }
    
    if ([sender.isSold isEqualToString:@"yes"]) {
        [self.buyAction setImage:[UIImage imageNamed:@"sold out1"] forState:UIControlStateNormal];
        [self.buyAction setEnabled:NO];

    }else
    {
        [self.buyAction setEnabled:YES];
        [self.buyAction setImage:[UIImage imageNamed:@"purchase-normal"] forState:UIControlStateNormal];
        [self.buyAction setImage:[UIImage imageNamed:@"purchase-pressl"] forState:UIControlStateHighlighted];
    }
    
    if(sender.sex == 1)
    {
        [self.sexImage setImage:[UIImage imageNamed:@"male"]];
    }else if(sender.sex == 0)
    {
        [self.sexImage setImage:[UIImage imageNamed:@"common"]];

    }else if(sender.sex == 1000)
    {
        [self.sexImage setImage:[UIImage imageNamed:@"female"]];
    }
    
    
}

-(void)drawStars:(int)starNum
{
    for (int i = 0; i<starNum; i++) {
        [self.heartArray[i] setHidden:NO];
    }
    for (int i = starNum; i<5; i++) {
        [self.heartArray[i] setHidden:YES];

    }
}

-(void)drawColors:(int)starNum withImageName:(NSString *)imageName
{
    for (int i = 0; i<starNum; i++) {
        [self.colorButtons[i] setHidden:NO];
        elemntButton *btn = self.colorButtons[i];
        btn.imageName = imageName;
        
    }
    for (int i = starNum; i<7; i++) {
        [self.colorButtons[i] setHidden:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.productListScorll ){
        CGFloat pageWidth = SCREEN_WIDTH;
        [scrollView setContentOffset:CGPointMake((pageWidth * (int)(scrollView.contentOffset.x / pageWidth)), 0)];
        int page = (int)(scrollView.contentOffset.x / pageWidth);
        
        [self scrollToCatalog:page];
        
    }
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backTap:(id)sender {
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    [self.delegateRefresh refreshLists];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)goLuckyHouse:(id)sender {
    
    rewardViewController *myReward = [[rewardViewController alloc] initWithNibName:@"rewardViewController" bundle:nil];
    [self.navigationController pushViewController:myReward animated:YES];
    
}

- (IBAction)addDiamond:(id)sender {
//
    [CommonUtility tapSound:@"buyDiamond" withType:@"mp3"];

    
        self.myBuyController = [[buyingViewController alloc] initWithNibName:@"buyingViewController" bundle:nil];
        self.myBuyController.closeDelegate =self;
    
        [self.myBuyController view];

        self.buyView = self.myBuyController.view;
        [self.view addSubview:self.buyView];

    
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    

    
}

//- (IBAction)colorBtnTapped:(elemntButton *)sender {
//    
//    NSString *frontImageName = [NSString stringWithFormat:@"%@-%ld-front",sender.imageName,(long)sender.tag];
//    [self.productImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
//    
//    
//    
//    NSString *backImageName = [NSString stringWithFormat:@"%@-%ld-back",sender.imageName,(long)sender.tag];
//    UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]];
//    if (backImage) {
//        
//        [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]]];
//    }else
//    {
//        [self.backHairImage setImage:nil];
//        
//    }
//    
//    
//}
- (IBAction)buyProduct:(id)sender {
    
    [MobClick event:@"bugProduct"];

    
    if (!self.productNow) {
        return;
    }
    
    if ([self checkDiamond:self.productNow.price]) {
        
        [self writeToPurchased];
        
        [self modifyItemFromPlist:@"GameData" withCatelog:self.productNow.productCategory andElementNum:self.productNow.productNumber];

//        [self deleteItemFromPlist:@"GameData" withCatelog:self.productNow.productCategory andElementNum:self.productNow.productNumber];
        self.GameData = [self readDataFromPlist:@"GameData"];
        [self costDiamond:self.productNow.price];
        
        [self.buyAction setImage:[UIImage imageNamed:@"sold out1"] forState:UIControlStateNormal];
        [self.buyAction setEnabled:NO];


        [self refreshProducts];
        
        [CommonUtility tapSound:@"buySuccess" withType:@"wav"];

        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"success!" message:@"购买成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [success show];

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
        
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2-120, alertView.frame.size.height-80, 100, 35)];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel-press"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelAlert:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(alertView.frame.size.width/2+20, alertView.frame.size.height-80, 100, 35)];
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
        
        
        
    }
    
    
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
    
    [self addDiamond:nil];
    
    
}

-(void)makeDiamondLabel:(NSString *)diamondNum
{
    [self.diamondLabel setText:diamondNum];
}

-(void)closingBuy
{
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];
    

}



-(void)costDiamond:(int)price
{
    int diamondRemain = [[[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"] intValue];
    NSString *diamondNow =[NSString stringWithFormat:@"%d",diamondRemain - price];
    
    [[NSUserDefaults standardUserDefaults] setObject:diamondNow forKey:@"diamond"];
    
    [self.diamondLabel setText:diamondNow];
    
    
}

-(BOOL)checkDiamond:(int)price;
{
    int diamondRemain = [[[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"] intValue];
    
    return diamondRemain>=price;
}

//eric: purchased product is a dic with two keys:haveNew(@"yes" or @"no") and purchasedArray(NSMutableArray).
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
    
//    if (self.productNow.sex == 1000) {
//        if ([self.productNow.productCategory isEqualToString:@"衣服"] ||[self.productNow.productCategory isEqualToString:@"头发"] ) {
//            self.productNow.productCategory = [self.productNow.productCategory stringByAppendingString:@"女"];
//        }
//    }else if ((self.productNow.sex == 0))
//    {
//        [self doWrite];
//        if ([self.productNow.productCategory isEqualToString:@"衣服"] ||[self.productNow.productCategory isEqualToString:@"头发"] ) {
//            self.productNow.productCategory = [self.productNow.productCategory stringByAppendingString:@"女"];
//        }
//    }
//    [self doWrite];

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

-(void)deleteItemFromPlist:(NSString *)plistname withCatelog:(NSString *)catelog andElementNum:(int)elementNum
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
//            NSMutableDictionary *productTobeRemoved = [[allProducts objectForKey:catelog] objectAtIndex:elementNum];
//            NSString *removeName = [productTobeRemoved objectForKey:@"name"];
            
            [[allProducts objectForKey:catelog] removeObjectAtIndex:elementNum];
            [infoDict setObject:allProducts forKey:@"productInfo"];
//            
//            if ([[productTobeRemoved objectForKey:@"existsAll"] isEqualToString:@"yes"]) {
//                
//                NSMutableDictionary *allLuckyProducts = [infoDict objectForKey:@"luckyProducts"];
//                NSMutableArray *luckyArray = [allLuckyProducts objectForKey:catelog];
//                NSMutableArray *luckyArrayTemp = [[allLuckyProducts objectForKey:catelog] copy];
//                
//                
//                [luckyArrayTemp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if ([[obj objectForKey:@"name"] isEqualToString:removeName])
//                    {
//                        [luckyArray removeObjectAtIndex:idx];
//                    }
//                }];
//                
//                [infoDict setObject:allLuckyProducts forKey:@"luckyProducts"];
//                
//                
//            }
//           
            [infoDict writeToFile:plistPath atomically:NO];
            
            
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:plistPath error:nil];
        }
    }
}
-(void)modifyItemFromPlist:(NSString *)plistname withCatelog:(NSString *)catelog andElementNum:(int)elementNum
{
    if ([catelog isEqualToString:@"头发女"])
    {
        catelog = @"头发";
    }
    if ([catelog isEqualToString:@"衣服女"])
    {
        catelog = @"衣服";
    }
    
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
@end
