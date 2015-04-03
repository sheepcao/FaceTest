//
//  gameViewController.m
//  Anime Face
//
//  Created by Eric Cao on 3/31/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "gameViewController.h"
#import "elemntButton.h"
#import "hairButton.h"

#define CATALOG_NUM 15
#define CATALOG_BUTTON_WIDTH 70
#define ELEMENT_WIDTH SCREEN_WIDTH/3


@interface gameViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *imagesArray;

@end

@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = @[self.faceFrameView,@"hair",self.mustacheView,self.clothingView,self.eyeView,self.eyebrowView,self.mouthView,self.gestureView,self.glassesView,self.noseView,self.moodView,self.faceImage,self.hatView,self.backImage,self.petView];
    
    [self.bodyImage setImage:[UIImage imageNamed:@"body1"]];
    
    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupLists) withObject:nil afterDelay:0.8];
//
//    [self setupCatalog];
//    [self setupLists];

    // Do any additional setup after loading the view from its nib.
}



#pragma mark setup Catalog
-(void)setupCatalog
{
    [self.catalogScrollView setContentSize:CGSizeMake(CATALOG_NUM*CATALOG_BUTTON_WIDTH, 40)];
    self.catalogScrollView.canCancelContentTouches = YES;
    NSArray *catalogText = [self.GameData objectForKey:@"catalog"];
    
    for (int i = 0 ; i < CATALOG_NUM; i++) {
        UIButton *catalogBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*CATALOG_BUTTON_WIDTH, 0, CATALOG_BUTTON_WIDTH, 40)];
        [catalogBtn setTitle:catalogText[i] forState:UIControlStateNormal];
        catalogBtn.tag = i;
        [catalogBtn addTarget:self action:@selector(catalogTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.catalogScrollView addSubview:catalogBtn];

    }
}
-(void)catalogTapped:(UIButton *)sender
{
    NSLog(@"tag:%ld",sender.tag);
    [self scrollToCatalog:sender.tag];
    [self.ListsScroll setContentOffset:CGPointMake(SCREEN_WIDTH * sender.tag, 0)];
    
}
-(void)scrollToCatalog:(NSInteger)BtnTag
{
    UIButton * catalogBtn =(UIButton *)[self.catalogScrollView viewWithTag:BtnTag];
    [self.catalogScrollView setContentOffset:CGPointMake((catalogBtn.center.x - self.catalogScrollView.center.x), 0) animated:YES];
}

#pragma mark setup Lists
-(void)setupLists
{
    [self.ListsScroll setFrame:CGRectMake(0, self.catalogScrollView.frame.origin.y+self.catalogScrollView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.catalogScrollView.frame.origin.y+self.catalogScrollView.frame.size.height))];
    [self.ListsScroll setContentSize:CGSizeMake(CATALOG_NUM*SCREEN_WIDTH,self.ListsScroll.frame.size.height)];
    self.ListsScroll.canCancelContentTouches = YES;
    self.ListsScroll.pagingEnabled = YES;
    self.ListsScroll.bounces = NO;
    self.ListsScroll.showsHorizontalScrollIndicator = NO;
    self.ListsScroll.delegate = self;
    
    NSDictionary *listsText = [self.GameData objectForKey:@"Lists"];

    
    for (int i = 0 ; i < CATALOG_NUM; i++) {
        NSArray *listElements = [listsText objectForKey:[[self.GameData objectForKey:@"catalog"] objectAtIndex:i]];

        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.ListsScroll.frame.size.height)];
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(1+listElements.count/3)*(ELEMENT_WIDTH/1.2))];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;

        

        [self.ListsScroll addSubview:oneList];
        
        for (int j = 0 ; j<listElements.count; j++) {
            elemntButton *element = [[elemntButton alloc] initWithFrame:CGRectMake(0+(j%3)*ELEMENT_WIDTH, 0+(j/3)*ELEMENT_WIDTH/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            [element setImage:[UIImage imageNamed:listElements[j]] forState:UIControlStateNormal];
            element.imageName = listElements[j];
            element.imageLevel =[NSNumber numberWithInt:i];
            
            [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
            [oneList addSubview:element];

        }
        
    }
}
-(void)elementTapped:(elemntButton *)sender
{
    NSLog(@"element:%@",sender.imageLevel);
    if ([sender.imageLevel intValue]==1) {
        
        NSString *imageName = sender.imageName;
        NSArray *imageNameArray = [imageName componentsSeparatedByString:@"-"];
        if (imageNameArray.count>1) {
            sender.imageColor = [imageNameArray[1] intValue];
        }
        if (sender.imageColor>1) {
            [self showHairColorViewWith:sender];
        }
        
        NSString *frontImageName = [NSString stringWithFormat:@"%@-0-front",sender.imageName];
        [self.frontHairView setImage:[UIImage imageNamed:frontImageName]];
        
        NSString *backImageName = [NSString stringWithFormat:@"%@-0-back",sender.imageName];
        UIImage *backImage = [UIImage imageNamed:backImageName];
        if (backImage) {
            
            [self.backHairImage setImage:[UIImage imageNamed:backImageName]];
            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            self.headImage.attachedView = nil;

        }
        
        self.headImage.placardView = self.frontHairView;
    }else
    {
        [self.imagesArray[[sender.imageLevel intValue]] setImage:sender.imageView.image];
        self.headImage.placardView = self.imagesArray[[sender.imageLevel intValue]];
    }
}

-(void)showHairColorViewWith:(elemntButton *)sender
{
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, sender.frame.size.height)];
    colorView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<sender.imageColor; i++) {
        elemntButton *colorBtn = [[elemntButton alloc] initWithFrame:CGRectMake(5+i*(sender.frame.size.width*3/4),(sender.frame.size.height - (sender.frame.size.width*3/4-10))/2, sender.frame.size.width*3/4-10,sender.frame.size.width*3/4-10)];
        NSString *imageWithColor = [NSString stringWithFormat:@"%@-%d",sender.imageName,i];
        [colorBtn setImage:[UIImage imageNamed:imageWithColor] forState:UIControlStateNormal];
        colorBtn.imageName = [NSString stringWithFormat:@"%@-%d",sender.imageName,i];
        [colorBtn addTarget:self action:@selector(colorTapped:) forControlEvents:UIControlEventTouchUpInside];
        [colorView addSubview:colorBtn];

    }
//    colorView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:colorView];
    
    [self showColorViewAnimationFor:colorView];
    
}


-(void)showColorViewAnimationFor:(UIView *)animatingView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    CGRect aframe = animatingView.frame;
    aframe.origin.y-=aframe.size.height;
    [animatingView setFrame:aframe];
    
    [UIView commitAnimations];
}
-(void)colorTapped:(elemntButton *)sender
{
    NSString *frontImageName = [NSString stringWithFormat:@"%@-front",sender.imageName];
    [self.frontHairView setImage:[UIImage imageNamed:frontImageName]];
    
    NSString *backImageName = [NSString stringWithFormat:@"%@-back",sender.imageName];
    
    UIImage *backImage = [UIImage imageNamed:backImageName];
    if (backImage) {
        
        [self.backHairImage setImage:[UIImage imageNamed:backImageName]];
        self.headImage.attachedView = self.backHairImage;
    }else
    {
        [self.backHairImage setImage:nil];
        self.headImage.attachedView = nil;
        
    }
}


#pragma mark scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.ListsScroll ){
        CGFloat pageWidth = SCREEN_WIDTH;
        [scrollView setContentOffset:CGPointMake((pageWidth * (int)(scrollView.contentOffset.x / pageWidth)), 0)];
        int page = (int)(scrollView.contentOffset.x / pageWidth);

        [self scrollToCatalog:page];

    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
