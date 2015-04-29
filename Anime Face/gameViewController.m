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
#import "rewardViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>




@interface gameViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *imagesArray;
@property (nonatomic,strong) UIView *colorView;
@property (nonatomic,strong) UIImage *imageShare;
@end

@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    


    
    [self.loadingView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d",self.sex]]];
    
    [self.loadPage setHidden:NO];
    
    
    //eric: button on navigation bar....
    
//    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    buttonContainer.backgroundColor = [UIColor clearColor];
//    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button0 setFrame:CGRectMake(0, 0, 100, 44)];
//    [button0 setTitle:@"Save" forState:UIControlStateNormal];
//    [button0 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
////    [button0 setBackgroundImage:[UIImage imageNamed:@"button0.png"] forState:UIControlStateNormal];
//    [button0 addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [button0 setShowsTouchWhenHighlighted:YES];
//    [buttonContainer addSubview:button0];
//    
//    self.navigationItem.titleView = buttonContainer;
    

    
    self.imagesArray = @[self.faceFrameView,@"hair",self.mustacheView,self.clothingView,self.eyeView,self.eyebrowView,self.mouthView,self.gestureView,self.glassesView,self.noseView,self.moodView,self.faceImage,self.hatView,self.backImage,self.petView];
    
    [self.bodyImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"body%d",self.sex]]];
    
    [self.backImage setImage:[UIImage imageNamed:@"background1"]];
    
    [self.faceFrameView setImage:[UIImage imageNamed:@"face1"]];
    [self.frontHairView setImage:[UIImage imageNamed:@"hair1-2-0-front"]];
    [self.backHairImage setImage:[UIImage imageNamed:@"hair1-2-0-back"]];
    
    
    
//    self.catalogScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slip-background.png"]];

    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupLists) withObject:nil afterDelay:0.9];
    
    self.imageShare = [[UIImage alloc] init];
//
//    [self setupCatalog];
//    [self setupLists];

    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    


}


#pragma mark setup Catalog
-(void)setupCatalog
{
    
    [self.catalogScrollView setContentSize:CGSizeMake(CATALOG_NUM_STORE*CATALOG_BUTTON_WIDTH, self.catalogScrollView.frame.size.height)];
    
    self.catalogScrollView.pagingEnabled = YES;


    self.catalogScrollView.canCancelContentTouches = YES;
    
    
    NSArray *catalogText = [self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]];
    
    for (int i = 0 ; i < CATALOG_NUM; i++) {
        UIButton *catalogBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*CATALOG_BUTTON_WIDTH, 0, CATALOG_BUTTON_WIDTH, 40)];
//        [catalogBtn setTitle:catalogText[i] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageNamed:catalogText[i]] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",catalogText[i]]] forState:UIControlStateSelected];
        if([[NSUserDefaults standardUserDefaults] objectForKey:catalogText[i]])
        {
            NSMutableDictionary *purchasedCatelog = [[NSUserDefaults standardUserDefaults] objectForKey:catalogText[i]];
            
            if ([[purchasedCatelog objectForKey:@"haveNew"] isEqualToString:@"yes"]) {
                NSLog(@"have new!!!!!!");
                
                UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(catalogBtn.frame.size.width*5/7, 2, catalogBtn.frame.size.width/6, catalogBtn.frame.size.width/6)];
                [newImage setImage:[UIImage imageNamed:@"new small"]];
                newImage.tag = 9999;// to identify
                [catalogBtn addSubview:newImage];
                
            }
        }
        

        [catalogBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 15, 3, 16)];
        
        catalogBtn.tag = i;
        [catalogBtn addTarget:self action:@selector(catalogTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.catalogScrollView addSubview:catalogBtn];
        
        if(i==0)
        {
            [catalogBtn setSelected:YES];
        }

    }
    
    if(IS_IPHONE_4_OR_LESS)
    {
        [self.moveMeViewLeading setConstant:50];
        [self.moveMeViewTrailing setConstant:50];
        [self.headImage setNeedsUpdateConstraints];
        
        [self.backViewLeading setConstant:-50];
        [self.backViewTrailing setConstant:-50];
        [self.backImage setNeedsUpdateConstraints];
        
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        
    }
    
    
}
-(void)catalogTapped:(UIButton *)sender
{
    NSLog(@"tag:%ld",(long)sender.tag);
    if (self.colorView) {
        [self hideColorViewAnimationFor:self.colorView];
    }
    [self scrollToCatalog:sender.tag];
    [self.ListsScroll setContentOffset:CGPointMake(SCREEN_WIDTH * sender.tag, 0)];
    
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
        
        NSString *catalogKey = [[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:i];
        
        NSArray *listElements = [listsText objectForKey:catalogKey];
        NSMutableArray *allListElements = [NSMutableArray arrayWithArray:listElements];


        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.ListsScroll.frame.size.height)];
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(1+listElements.count/3)*(ELEMENT_WIDTH+6)/1.2)];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;

        
        if([[NSUserDefaults standardUserDefaults] objectForKey:catalogKey])
        {
            NSMutableDictionary *purchasedCatelog = [[NSUserDefaults standardUserDefaults] objectForKey:[[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:i]];
            
            NSArray *purchasedProducts = [purchasedCatelog objectForKey:@"purchasedArray"];
            for (int i = 0;  i<purchasedProducts.count; i++) {
                [allListElements addObject:purchasedProducts[i]];
            }
            
            
        }

        [self.ListsScroll addSubview:oneList];
        
        for (int j = 0 ; j<allListElements.count; j++) {
            elemntButton *element = [[elemntButton alloc] initWithFrame:CGRectMake(6+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            
            CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
            
            [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];

            
            if (j>=listElements.count) {
                
                
                NSString *newProductImageName = allListElements[j];
                NSArray *nameArray = [newProductImageName componentsSeparatedByString:@"+"];
                if (nameArray.count>1) {
                    NSString * newProductImageNameFinal = nameArray[0];
                    [element setImage:[UIImage imageNamed:newProductImageNameFinal] forState:UIControlStateNormal];
                    
                    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(element.frame.size.width*5/6, 2, element.frame.size.width/6, element.frame.size.width/6)];
                    [newImage setImage:[UIImage imageNamed:@"new big"]];
                    newImage.tag = 8888;// to identify
                    [element addSubview:newImage];
                    
                    element.imageName = newProductImageNameFinal;
                    
                    if(i==7)//guesture
                    {
                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageNameFinal];
                        
                        [element setImage:[UIImage imageNamed:preView] forState:UIControlStateNormal];
                        
                    }

                    
                }else
                {
                    [element setImage:[UIImage imageNamed:newProductImageName] forState:UIControlStateNormal];
                    element.imageName = newProductImageName;
                    if(i==7)//guesture
                    {
                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageName];
                        
                        [element setImage:[UIImage imageNamed:preView] forState:UIControlStateNormal];
                        
                    }

                }


            }else
            {
                [element setImage:[UIImage imageNamed:allListElements[j]] forState:UIControlStateNormal];
                element.imageName = allListElements[j];
                if(i==7)//guesture
                {
                    NSString *preView = [NSString stringWithFormat:@"%@-yulan",allListElements[j]];
                    
                    [element setImage:[UIImage imageNamed:preView] forState:UIControlStateNormal];
                    
                }
            }
            
            element.imageLevel =[NSNumber numberWithInt:i];
            
            [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
            [element setBackgroundImage: [UIImage imageNamed:@"fame1"] forState:UIControlStateNormal];
            [element setBackgroundImage:[UIImage imageNamed:@"fame-choosed1"] forState:UIControlStateSelected];
            
            
            if (j == 0) {
            
                [element setSelected:YES];
            }
            
//            NSLog(@"button:%@",element);
            [oneList addSubview:element];

        }
        
    }
    
    
    [self.loadPage setHidden:YES];

}
-(void)elementTapped:(elemntButton *)sender
{
    NSLog(@"element:%@",sender.imageLevel);
    
    UIView *superView = [sender superview];
    for (UIButton *subBtn in [superView subviews]) {
        [subBtn setSelected:NO];
    }
    [sender setSelected:YES];

    
    
    if (self.colorView) {
        [self hideColorViewAnimationFor:self.colorView];
    }
    
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
//            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            self.headImage.attachedView = nil;

        }
        
//        self.headImage.placardView = self.frontHairView;
    }else
    {
        [self.imagesArray[[sender.imageLevel intValue]] setImage:[UIImage imageNamed:sender.imageName]];
        self.headImage.placardView = self.imagesArray[[sender.imageLevel intValue]];
    }
    
    if ([sender.imageLevel intValue] == 4)// eye view
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y-48;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 25;

    }else if ([sender.imageLevel intValue] == 2)
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp =self.headImage.placardView.center.y - 70;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 70;
    }else if ([sender.imageLevel intValue] == 5)
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y-48;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 25;
    }else if ([sender.imageLevel intValue] == 8)
    {
        self.headImage.swipeOrientation = swipeAll;
        self.headImage.limitationUp = 0;
        self.headImage.limitationDown = 0;
    }else if ([sender.imageLevel intValue] == 9)
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y -72;
        self.headImage.limitationDown = self.headImage.placardView.center.y +72;
    }else if ([sender.imageLevel intValue] == 6)
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp =self.headImage.placardView.center.y - 70;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 70;
    }else if ([sender.imageLevel intValue] == 11)
    {
        self.headImage.swipeOrientation = swipeAll;
        self.headImage.limitationUp =0;
        self.headImage.limitationDown =0;
    }else if ([sender.imageLevel intValue] == 14)
    {
        self.headImage.swipeOrientation = swipeAll;
        self.headImage.limitationUp =0;
        self.headImage.limitationDown =0;
    }else
    {
        self.headImage.swipeOrientation = swipeNone;
        self.headImage.limitationUp = 0;
        self.headImage.limitationDown = 0;
    }
    
}

-(void)showHairColorViewWith:(elemntButton *)sender
{

    if (!self.colorView) {
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, sender.frame.size.height)];
    }else
    {
        
        for (UIView *subView in [self.colorView subviews]) {
            [subView removeFromSuperview];
        }
    }
    self.colorView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i<sender.imageColor; i++) {
        
        CGFloat btnSize = 0;
        if (sender.imageColor == 2) {
            btnSize = (sender.frame.size.width*3/4-10)/1.2;
        }else if(sender.imageColor == 4)
        {
            btnSize = (sender.frame.size.width*3/4-10)/1.6;
        }else
        {
            btnSize = (sender.frame.size.width*3/4-10)/2.0;
        }
        
        CGFloat startX = (SCREEN_WIDTH-(btnSize*sender.imageColor + 5*(sender.imageColor-1)))/2;
        
        
        elemntButton *colorBtn = [[elemntButton alloc] initWithFrame:CGRectMake(startX+i*(btnSize+5),(sender.frame.size.height - btnSize-5), btnSize,btnSize)];
//        NSString *imageWithColor = [NSString stringWithFormat:@"%@-%d",sender.imageName,i];
        NSString *imageWithColor = [NSString stringWithFormat:@"%d",i];

        [colorBtn setImage:[UIImage imageNamed:imageWithColor] forState:UIControlStateNormal];
        colorBtn.imageName = [NSString stringWithFormat:@"%@-%d",sender.imageName,i];
        [colorBtn addTarget:self action:@selector(colorTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorView addSubview:colorBtn];

    }
//    colorView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.colorView];
    
    [self showColorViewAnimationFor:self.colorView];
    
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

-(void)hideColorViewAnimationFor:(UIView *)animatingView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGRect aframe = animatingView.frame;
    aframe.origin.y=SCREEN_HEIGHT;
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

#pragma mark Save Image

-(void)saveImage:(UIImage *)image
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                // INSERT CODE TO PERFORM WHEN USER TAPS OK eg. :
                UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
 
                UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"成功保存" message:@"已将保存萌照至系统相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
               
                [successAlert show];
                NSLog(@"saved Image!");

                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            // INSERT CODE TO PERFORM WHEN USER TAPS DONT ALLOW, eg. :
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"成功失败" message:@"请在设置－隐私－照片中允许访问您的相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [failAlert show];
            NSLog(@"save Image failed!");
        }];
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"成功保存" message:@"已将保存萌照至系统相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [successAlert show];
        NSLog(@"saved Image!");
       
    }else
    {
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"成功失败" message:@"请在设置－隐私－照片中允许访问您的相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [failAlert show];
        NSLog(@"save Image failed!");
    }

    

}




- (IBAction)share:(id)sender {
    
}

- (IBAction)saveAlbum:(id)sender {
    [self saveImage:self.imageShare];

}

- (IBAction)cancelPhoto:(id)sender {
    
    [UIView animateWithDuration: 0.45
                     animations: ^{
                            self.photoPage.alpha = 0.0f;
                         
                     }
                     completion:nil
     ];
    

}





- (IBAction)backTapp:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)storeTap:(id)sender {



    
}

- (IBAction)luckyHouseTap:(id)sender {
    
    
    rewardViewController *myReward = [[rewardViewController alloc] initWithNibName:@"rewardViewController" bundle:nil];
    [self.navigationController pushViewController:myReward animated:YES];
    
}

- (IBAction)saveAndShare:(id)sender {
    
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.headImage.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.headImage.frame.size);
    //获取图像
    
    [self.headImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.imageShare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.photoImage setImage:self.imageShare];

    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:whiteView];
    whiteView.alpha = 0.8;
    [self.photoPage sendSubviewToBack:self.photoBack];
    

    
    [UIView animateWithDuration: 0.75
                     animations: ^{
                         whiteView.alpha = 0;

                     }
                     completion: ^(BOOL finished) {
                         
                         if (self.photoPage.alpha <0.001) {
                             self.photoPage.alpha = 1.0;
                             [self.view bringSubviewToFront:self.photoPage];
                         }
                         
//                         [UIView animateWithDuration: 0.4
//                                          animations: ^{
//                                              whiteView.alpha = 0;
//
//                                              if (self.photoPage.alpha <0.001) {
//                                                  self.photoPage.alpha = 1.0;
//                                              }
//                                          }
//                                          completion:nil
//                          ];
                         
                         [whiteView removeFromSuperview];


                     }
     ];
}
@end
