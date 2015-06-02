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
#import "storeViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>




@interface gameViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *imagesArray;
@property (nonatomic,strong) UIView *colorView;
@property (nonatomic,strong) UIImage *imageShare;

@property (nonatomic,strong) NSMutableDictionary *selectedElement;
@property (nonatomic,strong) UITextField *invisibleTextFiled;
@end

@implementation gameViewController

@synthesize selectedElement;
@synthesize invisibleTextFiled;

int lastOffside;
bool needSaveAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    needSaveAlert = NO;

    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d",self.sex] ofType:@"png"];

    [self.loadingView setImage:[UIImage imageWithContentsOfFile:path]];
    
    [self.loadPage setHidden:NO];
    
    
    //for custom text view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self initCustomTextViewWithY:SCREEN_HEIGHT];

    
    //eric: button on navigation bar....
    

    selectedElement = [[NSMutableDictionary alloc] initWithCapacity:15];
    
    self.imagesArray = @[@"hair",self.faceFrameView,self.eyeView,self.eyebrowView,self.noseView,self.mouthView,self.faceImage,self.mustacheView,self.glassesView,self.clothingView,self.hatView,self.gestureView,self.petView,self.backImage,self.moodView];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"body%d",self.sex] ofType:@"png"];
    [self.bodyImage setImage:[UIImage imageWithContentsOfFile:path1]];
    
    [self.backImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background1" ofType:@"png"]]];
    
    [self.faceFrameView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"face1" ofType:@"png"]]];
    [self.frontHairView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hair1-2-0-front" ofType:@"png"]]];
    [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hair1-2-0-back" ofType:@"png"]]];
    
    
    
//    self.catalogScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:@"slip-background.png"]];

    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupListsForPage:) withObject:@"0" afterDelay:0.9];
    
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

-(void)refreshLists
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d",self.sex] ofType:@"png"];
    
    [self.loadingView setImage:[UIImage imageWithContentsOfFile:path]];
    
    [self.loadPage setHidden:NO];
    
    
    
    [self performSelector:@selector(setupCatalog) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(setupListsForPage:) withObject:@"0" afterDelay:0.9];

}


#pragma mark setup Catalog
-(void)setupCatalog
{
    
    for (UIView *subScroll in [self.catalogScrollView subviews]) {
        if ([subScroll isKindOfClass:[UIButton class]]) {
            [subScroll removeFromSuperview];
        }
    }
    
    
    [self.catalogScrollView setContentSize:CGSizeMake(CATALOG_NUM*CATALOG_BUTTON_WIDTH, self.catalogScrollView.frame.size.height)];
    [self.catalogScrollView setContentOffset:CGPointMake(0, 0)];
    


    self.catalogScrollView.canCancelContentTouches = YES;
    
    
    NSArray *catalogText = [self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]];
    
    for (int i = 0 ; i < CATALOG_NUM; i++) {
        UIButton *catalogBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+i*CATALOG_BUTTON_WIDTH, 0, CATALOG_BUTTON_WIDTH, 40)];
//        [catalogBtn setTitle:catalogText[i] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:catalogText[i] ofType:@"png"]] forState:UIControlStateNormal];
        [catalogBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@1",catalogText[i]] ofType:@"png"]] forState:UIControlStateSelected];
        if([[NSUserDefaults standardUserDefaults] objectForKey:catalogText[i]])
        {
            NSMutableDictionary *purchasedCatelog = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:catalogText[i]]];
            
            if ([[purchasedCatelog objectForKey:@"haveNew"] isEqualToString:@"yes"]) {
                NSLog(@"have new!!!!!!");
                
                UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(catalogBtn.frame.size.width*5/7, 2, catalogBtn.frame.size.width/6, catalogBtn.frame.size.width/6)];
                [newImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"new small" ofType:@"png"]]];
                newImage.tag = 9999;// to identify
                
                bool hasAdded = NO;
                for (UIView *image in [catalogBtn subviews]) {
                    if ([image isKindOfClass:[UIImageView class]] &&image.tag == 9999) {
                        hasAdded = YES;
                    }
                }
                if (!hasAdded) {
                    [catalogBtn addSubview:newImage];
                }
                
            }
        }
        

        [catalogBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 1, 16)];
        
        catalogBtn.tag = i+1;
        [catalogBtn addTarget:self action:@selector(catalogTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.catalogScrollView addSubview:catalogBtn];
        
        if(i==0)
        {
            [catalogBtn setSelected:YES];
            lastOffside = 0;

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
    int page = (int)(sender.tag-1);

    if (self.colorView) {
        [self hideColorViewAnimationFor:self.colorView];
    }
    [self scrollToCatalog:sender.tag withDuration:0.05];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    

    [self.ListsScroll setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
    
    [UIView commitAnimations];
    
    UIView *superView = [sender superview];
    for (UIView *subView in [superView subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            [subBtn setSelected:NO];
        }
    }
    [sender setSelected:YES];
    

    

    NSLog(@"bool1:%d",(page-lastOffside)<2);
    NSLog(@"bool2:%d",(page-lastOffside)>-2);

    

    
    NSDictionary *listsText = [self.GameData objectForKey:@"Lists"];
    
    for (UIView *scroll in [self.ListsScroll subviews]) {
        if ([scroll isKindOfClass:[UIScrollView class]]) {

            
            if (scroll.tag==1000+page) {
                
                [self makeListFullElementsForPage:page withData:listsText];
            }else
            {
                for (UIView *elementBtn in [scroll subviews]) {
                    if (elementBtn.frame.origin.y>3*(ELEMENT_WIDTH+6)/1.2) {
                        [elementBtn removeFromSuperview];
                    }
                }
                
            }
        }
    }

    
    
    
}
-(void)scrollToCatalog:(NSInteger)BtnTag withDuration:(CGFloat)time
{
    [CommonUtility tapSound:@"catalog" withType:@"mp3"];

    
    
    UIButton * catalogBtn =(UIButton *)[self.catalogScrollView viewWithTag:BtnTag];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:time];
    
    
    [self.catalogScrollView setContentOffset:CGPointMake((catalogBtn.center.x - self.catalogScrollView.center.x), 0) animated:YES];
    
    [UIView commitAnimations];
    

    for (UIView *subView in [self.catalogScrollView subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            [subBtn setSelected:NO];
        }
    }
    [catalogBtn setSelected:YES];

    
    for (UIView *image in [catalogBtn subviews]) {
        if (image.tag == 9999) {
            [image removeFromSuperview];
            
            NSString *catalogKey = [[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:(BtnTag-1)];

            if([[NSUserDefaults standardUserDefaults] objectForKey:catalogKey])
            {
                NSMutableDictionary *purchasedCatelog = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:catalogKey]];
                
                [purchasedCatelog setObject:@"no" forKey:@"haveNew"];
                [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:catalogKey];
            }
            
        }
    }
    


    [self hideCustomTextView];


    
}

#pragma mark setup Lists
-(void)setupListsForPage:(NSString *)pageNum
{
    [self.ListsScroll setFrame:CGRectMake(0, self.catalogScrollView.frame.origin.y+self.catalogScrollView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.catalogScrollView.frame.origin.y+self.catalogScrollView.frame.size.height))];
    [self.ListsScroll setContentSize:CGSizeMake(CATALOG_NUM*SCREEN_WIDTH,self.ListsScroll.frame.size.height)];
    self.ListsScroll.canCancelContentTouches = YES;
    self.ListsScroll.pagingEnabled = YES;
    self.ListsScroll.bounces = NO;
    self.ListsScroll.showsHorizontalScrollIndicator = NO;
    self.ListsScroll.delegate = self;
    
    [self.ListsScroll setContentOffset:CGPointMake(0, 0)];

    
    for (UIView *subScroll in [self.ListsScroll subviews]) {
        if ([subScroll isKindOfClass:[UIScrollView class]]) {
            [subScroll removeFromSuperview];
        }
    }
    
    
    NSDictionary *listsText = [self.GameData objectForKey:@"Lists"];
 
    [self makeListElementsForPage:[pageNum intValue] withData:listsText];
    
    
    [self.loadPage setHidden:YES];

}


-(void)makeListElementsForPage:(int)pageNow withData:(NSDictionary *)dic
{
//    int page = -1;
//    
//    if (pageNow == 0 ) {
//        page =1;
//    }else if(pageNow == CATALOG_NUM-1)
//    {
//        page = CATALOG_NUM-2;
//    }else
//    {
//        page = pageNow;
//    }
    
//    for (int i = page-1 ; i < page+2 ; i++) {
        for (int i = 0 ; i < CATALOG_NUM ; i++) {

        
        NSString *catalogKey = [[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:i];
        
        NSArray *listElements = [dic objectForKey:catalogKey];
        NSMutableArray *allListElements = [NSMutableArray arrayWithArray:listElements];
        
        
        UIScrollView *oneList = [[UIScrollView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH,  self.ListsScroll.frame.size.height)];
        int rowForNotFull = (listElements.count%3 == 0)?0:1;
        [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(rowForNotFull+listElements.count/3)*(ELEMENT_WIDTH+6)/1.2)];
        oneList.canCancelContentTouches = YES;
        oneList.bounces = NO;
        oneList.showsVerticalScrollIndicator=NO;
        oneList.showsHorizontalScrollIndicator=NO;
        oneList.tag = 1000+i;
        oneList.delegate = self;
            

        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:catalogKey])
        {
            NSMutableDictionary *purchasedCatelog = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:i]]];
            
            NSArray *purchasedProducts = [purchasedCatelog objectForKey:@"purchasedArray"];
            for (int i = 0;  i<purchasedProducts.count; i++) {
                [allListElements addObject:purchasedProducts[i]];
            }
            
            
        }
        
        [self.ListsScroll addSubview:oneList];
        
        
        int elementCount = 0;
        //for the current page
//        if (i == pageNow) {
//            elementCount = (int)allListElements.count;
//        }else
//        {
            elementCount =(int)(allListElements.count>9?9:allListElements.count);
//        }
        
        
        for (int j = 0 ; j<elementCount; j++) {
            elemntButton *element = [[elemntButton alloc] initWithFrame:CGRectMake(6+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
            
            CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
            
            [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];
            
            
            if (j>=listElements.count) {
                
                
                NSString *newProductImageName = allListElements[j];
                NSArray *nameArray = [newProductImageName componentsSeparatedByString:@"+"];
                if (nameArray.count>1) {
                    NSString * newProductImageNameFinal = nameArray[0];
                    NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageNameFinal];
                    
                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                    
//                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:newProductImageNameFinal ofType:@"png"]] forState:UIControlStateNormal];
                    
                    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(element.frame.size.width*5/6, 2, element.frame.size.width/6, element.frame.size.width/6)];
                    
                    [newImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"new big" ofType:@"png"]]];
                    newImage.tag = 8888;// to identify
                    [element addSubview:newImage];
                    
                    element.imageName = newProductImageNameFinal;
//                    
//                    if(i==7)//guesture
//                    {
//                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageNameFinal];
//                        
//                        [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
//                        
//                    }
                    
                    
                }else
                {
                    NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageName];
                    
                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                    element.imageName = newProductImageName;
//                    if(i==7)//guesture
//                    {
//                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageName];
//                        
//                        [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
//                        
//                    }
//                    
                }
                
                
            }else
            {
                NSString *preView = [NSString stringWithFormat:@"%@-yulan",allListElements[j]];
                
                [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                element.imageName = allListElements[j];
//                if(i==7)//guesture
//                {
//                    NSString *preView = [NSString stringWithFormat:@"%@-yulan",allListElements[j]];
//                    
//                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
//                    
//                }
            }
            
            element.imageLevel =[NSNumber numberWithInt:i];
            
            [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
            [element setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]] forState:UIControlStateNormal];
            [element setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame selected" ofType:@"png"]] forState:UIControlStateSelected];
            
            element.tag = j+1;

            
//            if (j == 0) {
//                
//                [element setSelected:YES];
//            }
            
            //            NSLog(@"button:%@",element);
            [oneList addSubview:element];
            
        }
        
    }
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
    
    if ([sender.imageLevel intValue]==0)//hair
    {
        
        NSString *imageName = sender.imageName;
        NSArray *imageNameArray = [imageName componentsSeparatedByString:@"-"];
        if (imageNameArray.count>1) {
            sender.imageColor = [imageNameArray[1] intValue];
        }
        if (sender.imageColor>1) {
            [self showHairColorViewWith:sender];
        }
        
        NSString *frontImageName = [NSString stringWithFormat:@"%@-0-front",sender.imageName];
        [self.frontHairView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
        
        NSString *backImageName = [NSString stringWithFormat:@"%@-0-back",sender.imageName];
        UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]];
        if (backImage) {
            
            [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]]];
//            self.headImage.attachedView = self.backHairImage;
        }else
        {
            [self.backHairImage setImage:nil];
            self.headImage.attachedView = nil;

        }
        
//        self.headImage.placardView = self.frontHairView;
    }else
    {
        [self.imagesArray[[sender.imageLevel intValue]] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:sender.imageName ofType:@"png"]]];
        self.headImage.placardView = self.imagesArray[[sender.imageLevel intValue]];
    }
    
    if ([sender.imageLevel intValue] == 2)// eye view
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y-48;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 25;

    }else if ([sender.imageLevel intValue] == 7)//mustacheView
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp =self.headImage.placardView.center.y - 70;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 70;
    }else if ([sender.imageLevel intValue] == 3)//eyebrow view
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y-48;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 25;
    }else if ([sender.imageLevel intValue] == 8)//glasses view
    {
        self.headImage.swipeOrientation = swipeAll;
        self.headImage.limitationUp = 0;
        self.headImage.limitationDown = 0;
    }else if ([sender.imageLevel intValue] == 4) //nose view
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp = self.headImage.placardView.center.y -72;
        self.headImage.limitationDown = self.headImage.placardView.center.y +72;
    }else if ([sender.imageLevel intValue] == 5) // mouthView
    {
        self.headImage.swipeOrientation = swipevertical;
        self.headImage.limitationUp =self.headImage.placardView.center.y - 70;
        self.headImage.limitationDown =self.headImage.placardView.center.y + 70;
    }else if ([sender.imageLevel intValue] == 6)//faceImage
    {
        self.headImage.swipeOrientation = swipeAll;
        self.headImage.limitationUp =0;
        self.headImage.limitationDown =0;
    }else if ([sender.imageLevel intValue] == 12)//pet view
    {
        self.headImage.swipeOrientation = swipeHorizontal;
        self.headImage.limitationUp =0;
        self.headImage.limitationDown =0;
    }else if ([sender.imageLevel intValue] == 14)//mood view
    {
        self.headImage.swipeOrientation = swipeNone;
        self.headImage.limitationUp = 0;
        self.headImage.limitationDown = 0;

        if (sender.tag == 2) {
            [invisibleTextFiled becomeFirstResponder];
        }else
        {
            [self.customTextLabel setText:@""];
            [self hideCustomTextView];
        }
        
    }else
    {
        self.headImage.swipeOrientation = swipeNone;
        self.headImage.limitationUp = 0;
        self.headImage.limitationDown = 0;
    }
    
    
    
    for (UIView *image in [sender subviews]) {
        if (image.tag == 8888) {
            [image removeFromSuperview];
            
            NSString *catalogKey = [[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:([sender.imageLevel intValue])];
            
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:catalogKey])
            {
                NSMutableDictionary *purchasedCatelog =[NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey:catalogKey]];
                
                NSMutableArray *purchasedArray =[NSMutableArray arrayWithArray:[purchasedCatelog objectForKey:@"purchasedArray"]];
                
                
                NSString *newProductName = [NSString stringWithFormat:@"%@+new",sender.imageName];
                NSUInteger index =  [purchasedArray indexOfObject:newProductName];
                
                if(purchasedArray.count == 1)
                {
                    [purchasedArray removeAllObjects];
                    [purchasedArray addObject:sender.imageName];
                }else
                {
                    [purchasedArray removeObjectAtIndex:index];
                    [purchasedArray insertObject:sender.imageName atIndex:index];

                }
                
                
                [purchasedCatelog setObject:purchasedArray forKey:@"purchasedArray"];


                [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:catalogKey];

            }
            
        }
    }
    
    
    [selectedElement setObject:[NSNumber numberWithInteger:sender.tag] forKey:[NSString stringWithFormat:@"%@",sender.imageLevel]];
    
    
    
    needSaveAlert = YES;
    
    
}

-(void)initCustomTextViewWithY:(CGFloat)pos_Y
{
    UIView *customTextView = [[UIView alloc] initWithFrame:CGRectMake(0, pos_Y, SCREEN_WIDTH, 40)];
    [customTextView setBackgroundColor:[UIColor whiteColor]];
    customTextView.tag = 777;
    invisibleTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(3, 2, customTextView.frame.size.width-80, 36)];
    invisibleTextFiled.placeholder = @"请输入气泡内容";
    invisibleTextFiled.layer.borderWidth = 0.5;
    invisibleTextFiled.layer.cornerRadius = 7;
    invisibleTextFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    invisibleTextFiled.delegate = self;
    invisibleTextFiled.returnKeyType = UIReturnKeyDone;

    invisibleTextFiled.tag = 7;
    
    UIButton *doInput = [[UIButton alloc] initWithFrame:CGRectMake(customTextView.frame.size.width-78, 2, 75, 36)];
    [doInput setTitle:@"输入" forState:UIControlStateNormal];
    [doInput setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doInput addTarget:self action:@selector(inputText) forControlEvents:UIControlEventTouchUpInside];
    [customTextView addSubview:invisibleTextFiled];
    [customTextView addSubview:doInput];
    
//    [customTextView setHidden:YES];

    [self.view addSubview:customTextView];
    

    
}
-(void)hideCustomTextView
{
    UIView *customTextView = [self.view viewWithTag:777];
    [invisibleTextFiled setText:@""];
    [UIView animateWithDuration: 0.01
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
}


-(void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIView *customTextView = [self.view viewWithTag:777];
    [UIView animateWithDuration: 0.05
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height-40, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    [self.view layoutIfNeeded];
}

-(void)inputText
{
    UIView *customTextView = [self.view viewWithTag:777];
    UITextField *txtField = (UITextField *)[customTextView viewWithTag:7];
    
    [self.customTextLabel setText:txtField.text];
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
    
    NSArray *colorKey = [[self.GameData objectForKey:@"colorList"] objectForKey:sender.imageName];
    
    
    for (int i = 0; i<sender.imageColor; i++) {
        
        CGFloat btnSize = 0;

        btnSize = (sender.frame.size.width*3/4-12)/1.6;

        CGFloat startX = (SCREEN_WIDTH-(btnSize*sender.imageColor + 5*(sender.imageColor-1)))/2;
        

       
        
        elemntButton *colorBtn = [[elemntButton alloc] initWithFrame:CGRectMake(startX+i*(btnSize+5),(sender.frame.size.height - btnSize-5), btnSize,btnSize)];


        [colorBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorKey[i] ofType:@"png"]] forState:UIControlStateNormal];
        colorBtn.imageName = [NSString stringWithFormat:@"%@-%@",sender.imageName,colorKey[i]];
        [colorBtn addTarget:self action:@selector(colorTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorView addSubview:colorBtn];

    }
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
    [self.frontHairView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:frontImageName ofType:@"png"]]];
    
    NSString *backImageName = [NSString stringWithFormat:@"%@-back",sender.imageName];
    
    UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]];
    if (backImage) {
        
        [self.backHairImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:backImageName ofType:@"png"]]];
        self.headImage.attachedView = self.backHairImage;
    }else
    {
        [self.backHairImage setImage:nil];
        self.headImage.attachedView = nil;
        
    }
}




-(void)makeListFullElementsForPage:(int)page withData:(NSDictionary *)dic
{
    
    
    
    NSString *catalogKey = [[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:page];
    
    NSArray *listElements = [dic objectForKey:catalogKey];
    NSMutableArray *allListElements = [NSMutableArray arrayWithArray:listElements];
    
    
    UIScrollView *oneList = (UIScrollView *)[self.ListsScroll viewWithTag:(1000+page)];
    
    for (UIView *elementBtn in [oneList subviews]) {
        if ([elementBtn isKindOfClass:[elemntButton class]]) {
            [elementBtn removeFromSuperview];
        }
    }
    
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:catalogKey])
    {
        NSMutableDictionary *purchasedCatelog = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[[self.GameData objectForKey:[NSString stringWithFormat:@"catalog%d",self.sex]] objectAtIndex:page]]];
        
        NSArray *purchasedProducts = [purchasedCatelog objectForKey:@"purchasedArray"];
        for (int i = 0;  i<purchasedProducts.count; i++) {
            [allListElements addObject:purchasedProducts[i]];
        }
        
        
    }
    int rowForNotFull = (allListElements.count%3 == 0)?0:1;
    [oneList setContentSize:CGSizeMake(SCREEN_WIDTH,(rowForNotFull+allListElements.count/3)*(ELEMENT_WIDTH+6)/1.2)];
    
    
    for (int j = 0 ; j<allListElements.count; j++) {
        elemntButton *element = [[elemntButton alloc] initWithFrame:CGRectMake(6+(j%3)*(ELEMENT_WIDTH+6), 0+(j/3)*(ELEMENT_WIDTH+6)/1.2, ELEMENT_WIDTH, ELEMENT_WIDTH/1.2)];
        
        CGFloat sidesOffside = ELEMENT_WIDTH - ELEMENT_WIDTH/1.2;
        
        [element setImageEdgeInsets:UIEdgeInsetsMake(0, sidesOffside/2, 0, sidesOffside/2)];
        
        
        if (j>=listElements.count) {
            
            
            NSString *newProductImageName = allListElements[j];
            NSArray *nameArray = [newProductImageName componentsSeparatedByString:@"+"];
            if (nameArray.count>1) {
                
                NSString * newProductImageNameFinal = nameArray[0];
                
                NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageNameFinal];
                
                [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                
                //                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:newProductImageNameFinal ofType:@"png"]] forState:UIControlStateNormal];
                
                UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(element.frame.size.width*5/6, 2, element.frame.size.width/6, element.frame.size.width/6)];
                
                [newImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"new big" ofType:@"png"]]];
                newImage.tag = 8888;// to identify
                [element addSubview:newImage];
                
                element.imageName = newProductImageNameFinal;
                //
                //                    if(page==7)//guesture
                //                    {
                //                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageNameFinal];
                //
                //                        [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                //
                //                    }
                
                
            }else
            {
                //                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:newProductImageName ofType:@"png"]] forState:UIControlStateNormal];
                NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageName];
                
                [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                
                element.imageName = newProductImageName;
                //                    if(page==7)//guesture
                //                    {
                //                        NSString *preView = [NSString stringWithFormat:@"%@-yulan",newProductImageName];
                //
                //                        [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
                //
                //                    }
                
            }
            
            
        }else
        {
            //                [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:allListElements[j] ofType:@"png"]] forState:UIControlStateNormal];
            NSString *preView = [NSString stringWithFormat:@"%@-yulan",allListElements[j]];
            
            [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
            element.imageName = allListElements[j];
            //                if(page==7)//guesture
            //                {
            //                    NSString *preView = [NSString stringWithFormat:@"%@-yulan",allListElements[j]];
            //
            //                    [element setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:preView ofType:@"png"]] forState:UIControlStateNormal];
            //
            //                }
        }
        
        element.imageLevel =[NSNumber numberWithInt:page];
        
        [element addTarget:self action:@selector(elementTapped:) forControlEvents:UIControlEventTouchUpInside];
        [element setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]] forState:UIControlStateNormal];
        [element setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame selected" ofType:@"png"]] forState:UIControlStateSelected];
        
        element.tag = j+1;
        
        [oneList addSubview:element];
        
    }
        
//    [oneList setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
    NSNumber *selectedNumber = [selectedElement objectForKey:[NSString stringWithFormat:@"%d",page]];
    if (selectedNumber) {
        
        elemntButton *selectedBtn = (elemntButton *)[oneList viewWithTag:[selectedNumber integerValue]];
        [self elementTapped:selectedBtn];
    }
   

}


-(void)makeOtherListCleanForPage:(int)page
{
    for (UIView *scroll in [self.ListsScroll subviews]) {
        if ([scroll isKindOfClass:[UIScrollView class]]) {
            if (scroll.tag!=1000+page) {
                for (UIView *elementBtn in [scroll subviews]) {
                    if (elementBtn.frame.origin.y>3*(ELEMENT_WIDTH+6)/1.2) {
                        [elementBtn removeFromSuperview];
                    }
                }
            }
        }
    }
}


#pragma mark scroll delegate




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.ListsScroll ){
        CGFloat pageWidth = SCREEN_WIDTH;
        [scrollView setContentOffset:CGPointMake((pageWidth * (int)(scrollView.contentOffset.x / pageWidth)), 0)];
        int page = (int)(scrollView.contentOffset.x / pageWidth);

        [self scrollToCatalog:page+1 withDuration:0];
        

        
        NSDictionary *listsText = [self.GameData objectForKey:@"Lists"];

        for (UIView *scroll in [self.ListsScroll subviews]) {
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                if (scroll.tag==1000+page) {
                    
                    [self makeListFullElementsForPage:page withData:listsText];
                }else
                {
                    for (UIView *elementBtn in [scroll subviews]) {
                        if (elementBtn.frame.origin.y>3*(ELEMENT_WIDTH+6)/1.2) {
                            [elementBtn removeFromSuperview];
                        }
                    }
                }
            }
        }
        

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
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                // INSERT CODE TO PERFORM WHEN USER TAPS OK eg. :
                UIImageWriteToSavedPhotosAlbum(self.imageShare, nil, nil,nil);
                
//                UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"成功保存" message:@"已将保存萌照至系统相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                
//                [successAlert show];
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
        UIImageWriteToSavedPhotosAlbum(self.imageShare, nil, nil,nil);
        
//        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"成功保存" message:@"已将保存萌照至系统相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [successAlert show];
        NSLog(@"saved Image!");
        
    }else
    {
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"成功失败" message:@"请在设置－隐私－照片中允许访问您的相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [failAlert show];
        NSLog(@"save Image failed!");
    }
    
    

    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"萌漫头"
                                       defaultContent:NSLocalizedString(@"",nil)
                                                image:[ShareSDK pngImageWithImage:self.imageShare]
                                                title:@"萌漫头"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"",nil)
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
//                                    [MobClick event:@"share"];
                                    
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    

    
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
    
    if (needSaveAlert) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"当前形象尚未保存，确定返回主界面吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回主界面", nil];
        [alert show];
    }else
    {
        [invisibleTextFiled removeFromSuperview];
        [invisibleTextFiled resignFirstResponder];
        [self hideCustomTextView];

        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}

- (IBAction)storeTap:(id)sender {


    storeViewController *myStore = [[storeViewController alloc] initWithNibName:@"storeViewController" bundle:nil];
    self.GameData = [self readDataFromPlist:@"GameData"];
    
    myStore.GameData = self.GameData;
    myStore.delegateRefresh = self;
    
    [invisibleTextFiled removeFromSuperview];
    [invisibleTextFiled resignFirstResponder];
    [self hideCustomTextView];

    [self.navigationController pushViewController:myStore animated:YES];
    
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

- (IBAction)luckyHouseTap:(id)sender {
    
    
    rewardViewController *myReward = [[rewardViewController alloc] initWithNibName:@"rewardViewController" bundle:nil];
    
    self.GameData = [self readDataFromPlist:@"GameData"];
    
    myReward.GameData = self.GameData;
    myReward.delegateRefresh = self;

    [invisibleTextFiled removeFromSuperview];
    [invisibleTextFiled resignFirstResponder];
    [self hideCustomTextView];
    [self.navigationController pushViewController:myReward animated:YES];
    
}

- (IBAction)saveAndShare:(id)sender {
    
    [invisibleTextFiled resignFirstResponder];
    [self hideCustomTextView];
//    [self hideCustomTextView];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.headImage.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.headImage.frame.size);
    //获取图像
    
    [self.headImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.imageShare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.photoImage setImage:self.imageShare];

    if (self.photoPage.alpha <0.001) {
        self.photoPage.alpha = 1.0;
        [self.photoGirl setImage:[UIImage imageNamed:@"girlphoto2"]];
        [self.photoTextFrame setHidden:YES];
        [self.photoText setHidden:YES];
        [self.view bringSubviewToFront:self.photoPage];
    }
    

    

    [self.photoPage sendSubviewToBack:self.photoBack];
    
    [self performSelector:@selector(showFlash) withObject:nil afterDelay:0.35];
    

    

}

-(void)showFlash

{
    [self.photoGirl setImage:[UIImage imageNamed:@"girlphoto1"]];
    
    [CommonUtility tapSound:@"photo" withType:@"mp3"];

    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteView];
    whiteView.alpha = 0.8;
    
    [UIView animateWithDuration:0.75 delay:0.1 options:UIViewAnimationOptionTransitionNone animations: ^{

        whiteView.alpha = 0;
        
    }
                     completion: ^(BOOL finished) {
                         
                         [whiteView removeFromSuperview];
                         
                         [self.photoGirl setImage:[UIImage imageNamed:@"girlphoto2"]];
                         [self.photoTextFrame setHidden:NO];
                         [self.photoText setHidden:NO];
                         [self.photoText setText:@"世上竟有如此出尘绝艳的女子"];

                         
                     }
     ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [invisibleTextFiled removeFromSuperview];
        [invisibleTextFiled resignFirstResponder];
        [self hideCustomTextView];

        [self.navigationController popViewControllerAnimated:YES];

    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    [textField resignFirstResponder];
//    
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    UIView *customTextView = [self.view viewWithTag:777];
    [UIView animateWithDuration: 0.15
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, self.catalogScrollView.frame.origin.y-40, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    [self.view layoutIfNeeded];
    
    return YES;
}

@end
