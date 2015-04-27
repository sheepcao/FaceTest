//
//  storeViewController.m
//  Anime Face
//
//  Created by Eric Cao on 4/23/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "storeViewController.h"
#import "elemntButton.h"


@interface storeViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic) NSArray *heartArray;

@end

@implementation storeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.heartArray = @[self.heart1,self.heart2,self.heart3,self.heart4,self.heart5];
    [self.loadingView setHidden:NO];
    [self.view bringSubviewToFront:self.loadingView];
    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupLists) withObject:nil afterDelay:0.9];
    
    
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
//        [self.moveMeViewLeading setConstant:50];
//        [self.moveMeViewTrailing setConstant:50];
//        [self.headImage setNeedsUpdateConstraints];
//        
//        [self.backViewLeading setConstant:-50];
//        [self.backViewTrailing setConstant:-50];
//        [self.backImage setNeedsUpdateConstraints];
//        
//        [self.view setNeedsUpdateConstraints];
//        [self.view layoutIfNeeded];
        
        
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
    
    NSDictionary *listsText = [self.GameData objectForKey:@"Lists"];
    
    
    for (int i = 0 ; i < CATALOG_NUM_STORE; i++) {
        NSArray *listElements = [listsText objectForKey:[[self.GameData objectForKey:@"catalogStore"] objectAtIndex:i]];
        
        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.productListScorll.frame.size.height)];
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(1+listElements.count/3)*(ELEMENT_WIDTH/1.2))];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;
        
        
        
        [self.productListScorll addSubview:oneList];
        
        for (int j = 0 ; j<listElements.count; j++) {
            
            elemntButton *element = [[elemntButton alloc] initWithFrame:CGRectMake(0+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            
            CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
            
            [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];
            
            [element setImage:[UIImage imageNamed:listElements[j]] forState:UIControlStateNormal];
            element.imageName = listElements[j];
            element.imageLevel =[NSNumber numberWithInt:i];
            
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
    
    
    [self.loadingView setHidden:YES];
    
}
-(void)elementTapped:(elemntButton *)sender
{
    NSLog(@"element:%@",sender.imageLevel);
    
    UIView *superView = [sender superview];
    for (UIButton *subBtn in [superView subviews]) {
        [subBtn setSelected:NO];
    }
    [sender setSelected:YES];
    

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
}

- (IBAction)goLuckyHouse:(id)sender {
}

- (IBAction)addDiamond:(id)sender {
}
@end
