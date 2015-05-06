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

@property (nonatomic,strong) NSArray *imageOptins;

@end

@implementation rewardViewController
@synthesize arrayGif;
@synthesize arrayGifOpenBox;


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;

    [self.rewardView setHidden:YES];
    
    self.imageOptins = @[@"wenhao0",@"wenhao1",@"wenhao2",@"wenhao3",@"wenhao4",@"wenhao5",@"wenhao6",@"wenhao7",@"wenhao8",@"wenhao9",@"wenhao10"];
    
    
    // Do any additional setup after loading the view from its nib.
    
//    [self.startReward setTitle:@"开始抽奖" forState:UIControlStateNormal];
    
    [self.productView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QuestionMark" ofType:@"png"]]];
    
    arrayGif=[[NSMutableArray array] init];
    arrayGifOpenBox=[[NSMutableArray array] init];

//    UIImage *gif = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self ofType:@"png"]];
//    [arrayGif addObject:gif];
    
    for (int i = 0; i<self.imageOptins.count; i++) {
        [arrayGif addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageOptins[i] ofType:@"png"]]];

    }
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

- (IBAction)cardTapped:(id)sender {
    
    [self.rewardView setHidden:YES];
    [self.boxImage setImage:[UIImage imageNamed:@"box.png"]];


}

- (IBAction)start:(UIButton *)sender {

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

    NSInteger selected =  arc4random() % self.imageOptins.count;
    [self.productBought setImage:[UIImage imageNamed:self.imageOptins[selected]]];
    
    [self.productCard setImage:[UIImage imageNamed:@"mistery room card"]];
}
@end
