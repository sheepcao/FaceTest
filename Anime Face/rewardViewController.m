//
//  rewardViewController.m
//  Anime Face
//
//  Created by Eric Cao on 4/7/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "rewardViewController.h"
#import "imageWithName.h"

@interface rewardViewController ()

@property (nonatomic,strong) NSMutableArray *arrayGif;
@property (nonatomic,strong) NSMutableArray *arrayGifOpenBox;
@property CGFloat baseY;

//@property (nonatomic,strong) NSArray *imageOptins;

@end

@implementation rewardViewController
@synthesize arrayGif;
@synthesize arrayGifOpenBox;
@synthesize baseY;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;

    [self.rewardView setHidden:YES];
    
//    self.imageOptins = @[@"wenhao0",@"wenhao1",@"wenhao2",@"wenhao3",@"wenhao4",@"wenhao5",@"wenhao6",@"wenhao7",@"wenhao8",@"wenhao9",@"wenhao10"];
    
    
    // Do any additional setup after loading the view from its nib.
    
//    [self.startReward setTitle:@"开始抽奖" forState:UIControlStateNormal];
    
    [self.productView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QuestionMark" ofType:@"png"]]];
    
    arrayGif=[[NSMutableArray array] init];
    arrayGifOpenBox=[[NSMutableArray array] init];

//    UIImage *gif = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self ofType:@"png"]];
//    [arrayGif addObject:gif];
    
//    for (int i = 0; i<self.imageOptins.count; i++) {
//        [arrayGif addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageOptins[i] ofType:@"png"]]];
//
//    }
    for (int i = 0; i<7; i++) {
        [arrayGifOpenBox addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tanchu%d",i] ofType:@"png"]]];
    }
    
    
    if (arrayGif.count>0) {
        //设置动画数组
        [self.productView setAnimationImages:arrayGif];
        
        //设置动画播放次数
        [self.productView setAnimationRepeatCount:0];
        //设置动画播放时间
        [self.productView setAnimationDuration:1.85];
        //开始动画
        [self.productView startAnimating];
        
    }
    

    //witch animation
    
    baseY = 0;
    [self performSelector:@selector(animateWitcth) withObject:nil afterDelay:0.9];
    
    
}

//-(void)viewDidLayoutSubviews
//{
//    CGPoint center = self.witch.center;
//    CGFloat centerYBase = center.y;
//    [self performSelector:@selector(animateWitcth:) withObject:[NSNumber numberWithFloat:centerYBase] afterDelay:0.5];
//}

-(void)animateWitcth
{
    
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)start:(UIButton *)sender {

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
    [self performSelector:@selector(showCard) withObject:nil afterDelay:0.15];
    
}

-(void)showCard
{
    [self.rewardView setHidden:NO];

    int selected =  arc4random() % 7;
    [self.productBought setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",selected]]];
    
    [self.productCard setImage:[UIImage imageNamed:@"card"]];
    [self.productName setText:[NSString stringWithFormat:@"色块%d",selected]];
    NSLog(@"frame:%@",self.productName);
}
@end
