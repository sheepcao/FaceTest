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
        [[NSUserDefaults standardUserDefaults] setObject:@"1000" forKey:@"diamond"];
        [self.diamondLabel setText:@"1000"];

    }
    
    
}

-(void)refreshProducts
{

    for (UIView *subs in [self.productListScorll subviews] ) {
        if ([subs isKindOfClass:[UIScrollView class]]) {
            [subs removeFromSuperview];
        }
        
    }
    showingDefault = YES;
    [self setupLists];
}


-(void)viewDidAppear:(BOOL)animated
{
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
    
    [self.catalogScroll setContentSize:CGSizeMake(CATALOG_NUM_STORE*CATALOG_BUTTON_WIDTH, 40)];
    
    
    self.catalogScroll.canCancelContentTouches = YES;
    
    
    NSArray *catalogText = [self.GameData objectForKey:@"catalogStore"];
    
    for (int i = 0 ; i < catalogText.count; i++) {
        UIButton *catalogBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*CATALOG_BUTTON_WIDTH, 0, CATALOG_BUTTON_WIDTH, 40)];
        //        [catalogBtn setTitle:catalogText[i] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageNamed:catalogText[i]] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",catalogText[i]]] forState:UIControlStateSelected];
        
        
        [catalogBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 15, 3, 16)];
        
        catalogBtn.tag = i;
        [catalogBtn addTarget:self action:@selector(catalogTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.catalogScroll addSubview:catalogBtn];
        
        if(i==0)
        {
            [catalogBtn setSelected:YES];
        }
        
    }
//    
    if(IS_IPHONE_4_OR_LESS)
    {

        
        [self.buttonDistanceV1 setConstant:3];
        [self.buttonDistanceV2 setConstant:3];
        [self.buttonDistanceV3 setConstant:3];
        
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    }
    
    
}

-(void)catalogTapped:(UIButton *)sender
{
    NSLog(@"tag:%ld",(long)sender.tag);

    [self scrollToCatalog:sender.tag];
    [self.productListScorll setContentOffset:CGPointMake(SCREEN_WIDTH * sender.tag, 0)];
    
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
    UIButton * catalogBtn =(UIButton *)[self.catalogScroll viewWithTag:BtnTag];
    [self.catalogScroll setContentOffset:CGPointMake((catalogBtn.center.x - self.catalogScroll.center.x), 0) animated:YES];
}

#pragma mark setup Lists
-(void)setupLists
{
//    [self.productListScorll setFrame:CGRectMake(0, self.catalogScroll.frame.origin.y+self.catalogScroll.frame.size.height, SCREEN_WIDTH, self.productListScorll.frame.size.height)];
    [self.productListScorll setContentSize:CGSizeMake(CATALOG_NUM_STORE*SCREEN_WIDTH,self.productListScorll.frame.size.height)];
    self.productListScorll.canCancelContentTouches = YES;
    self.productListScorll.pagingEnabled = YES;
    self.productListScorll.bounces = NO;
    self.productListScorll.showsHorizontalScrollIndicator = NO;
    self.productListScorll.delegate = self;
    
    NSDictionary *listsText = [self.GameData objectForKey:@"productInfo"];
    
    
    for (int i = 0 ; i < CATALOG_NUM_STORE; i++) {
        NSArray *listElements = [listsText objectForKey:[[self.GameData objectForKey:@"catalogStore"] objectAtIndex:i]];
        
        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.productListScorll.frame.size.height)];
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(1+listElements.count/3)*(ELEMENT_WIDTH/1.2))];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;
        
        
        
        [self.productListScorll addSubview:oneList];
        
        
        
        if (listElements.count == 0) {
           //to be empty ....
        }
        
        
        for (int j = 0 ; j<listElements.count; j++) {
            
            NSString *elementImageName = [listElements[j] objectForKey:@"name"];
            int elementPrice =[[listElements[j] objectForKey:@"price"] intValue];
            int elementStars =[[listElements[j] objectForKey:@"star"] intValue];
            int elementColors =[[listElements[j] objectForKey:@"colorNum"] intValue];
            int elementSex =[[listElements[j] objectForKey:@"sex"] intValue];
            NSString *elementTitle = [listElements[j] objectForKey:@"title"];



            
            buttonProduct *element = [[buttonProduct alloc] initWithFrame:CGRectMake(0+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            
            CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
            
            [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];
            
            [element setImage:[UIImage imageNamed:elementImageName] forState:UIControlStateNormal];
            element.imageName = elementImageName;
            element.imageLevel =[NSNumber numberWithInt:i];
            element.price = elementPrice;
            element.sex = elementSex;
            element.titleName = elementTitle;
            element.producrNum = j;
            element.catelogName =[[self.GameData objectForKey:@"catalogStore"] objectAtIndex:i];
            
            
            if (i == 0)//hair list
            {
                element.colorNum = elementColors;
            }else
            {
                element.stars = elementStars;
            }
            
            if (showingDefault) {
                [self setDefaultView:element];
            }
            
            [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
            [element setBackgroundImage: [UIImage imageNamed:@"fame1"] forState:UIControlStateNormal];
            [element setBackgroundImage:[UIImage imageNamed:@"fame-choosed1"] forState:UIControlStateSelected];
            
            
            if (j == 0) {
                
                [element setSelected:YES];
            }
            
            NSLog(@"button:%@",element);
            [oneList addSubview:element];
            
        }
        
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
    
    [self drawStars:sender.stars];

    sexSelectedNow = sender.sex;
    
    self.productNow = [[product alloc] init];
    self.productNow.price = sender.price;
    self.productNow.sex = sender.sex;
    self.productNow.productName = sender.imageName;
    self.productNow.productCategory = sender.catelogName;
    self.productNow.productNumber = sender.producrNum;
    

    if ([sender.imageLevel intValue]==0) {
        
        if (!self.starView.isHidden) {
            [self.starView setHidden:YES];
        }
        if (self.colorView.isHidden) {
            [self.colorView setHidden:NO];
        }
        
        [self.faceImage setImage:[UIImage imageNamed:@"face0"]];
        
        NSString *frontImageName = [NSString stringWithFormat:@"%@-0-front",sender.imageName];
        [self.productImage setImage:[UIImage imageNamed:frontImageName]];
        
        
        
        NSString *backImageName = [NSString stringWithFormat:@"%@-0-back",sender.imageName];
        UIImage *backImage = [UIImage imageNamed:backImageName];
        if (backImage) {
            
            [self.backHairImage setImage:[UIImage imageNamed:backImageName]];
            //            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            
        }
        
        [self drawColors:sender.colorNum withImageName:sender.imageName];

        
    }else
    {
        if (self.starView.isHidden) {
            [self.starView setHidden:NO];
        }
        if (!self.colorView.isHidden) {
            [self.colorView setHidden:YES];
        }
        
        [self.backHairImage setImage:nil];
        [self.faceImage setImage:nil];
        
        NSString *frontImageName = sender.imageName;
        [self.productImage setImage:[UIImage imageNamed:frontImageName]];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goLuckyHouse:(id)sender {
}

- (IBAction)addDiamond:(id)sender {
}

- (IBAction)colorBtnTapped:(elemntButton *)sender {
    
    NSString *frontImageName = [NSString stringWithFormat:@"%@-%d-front",sender.imageName,sender.tag];
    [self.productImage setImage:[UIImage imageNamed:frontImageName]];
    
    
    
    NSString *backImageName = [NSString stringWithFormat:@"%@-%d-back",sender.imageName,sender.tag];
    UIImage *backImage = [UIImage imageNamed:backImageName];
    if (backImage) {
        
        [self.backHairImage setImage:[UIImage imageNamed:backImageName]];
    }else
    {
        [self.backHairImage setImage:nil];
        
    }
    
    
}
- (IBAction)buyProduct:(id)sender {
    if (!self.productNow) {
        return;
    }
    
    if ([self checkDiamond:self.productNow.price]) {
        
        [self writeToPurchased];
        [self deleteItemFromPlist:@"GameData" withCatelog:self.productNow.productCategory andElementNum:self.productNow.productNumber];
        self.GameData = [self readDataFromPlist:@"GameData"];
        [self costDiamond:self.productNow.price];
        
        
        [self refreshProducts];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"success!" message:@"购买成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [success show];

    }else
    {
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, SCREEN_HEIGHT+10, 280, 185)];
        alertView.alpha = 0.0f;
        UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 185)];
        [backImg setImage:[UIImage imageNamed:@"diamond not enough board"]];
        [alertView addSubview:backImg];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        [alertView setFrame:CGRectMake((SCREEN_WIDTH-280)/2, (SCREEN_HEIGHT-185)/2, 280, 185)];
        alertView.alpha = 1;
        
        [UIView commitAnimations];
        
        
    }
    
    
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.productNow.productCategory]) {
        
        
        NSMutableDictionary *purchasedCatelog = [[NSMutableDictionary alloc] init];
        [purchasedCatelog setObject:@"yes" forKey:@"haveNew"];
        
        NSMutableArray *purchasedArray = [[NSUserDefaults standardUserDefaults] objectForKey:self.productNow.productCategory];
        
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
            NSDictionary *allProducts = [infoDict objectForKey:@"productInfo"];
            [[allProducts objectForKey:catelog] removeObjectAtIndex:elementNum];
            [infoDict setObject:allProducts forKey:@"productInfo"];
            [infoDict writeToFile:plistPath atomically:NO];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
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
