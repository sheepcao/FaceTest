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
@property (nonatomic,strong) NSArray *imageOptins;

@end

@implementation rewardViewController
@synthesize arrayGif;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    
    self.imageOptins = @[@"01",@"02",@"03"];
    
    // Do any additional setup after loading the view from its nib.
    
    [self.startReward setTitle:@"开始抽奖" forState:UIControlStateNormal];
    
    [self.productView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QuestionMark" ofType:@"png"]]];
    
    arrayGif=[[NSMutableArray array] init];
//    UIImage *gif = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self ofType:@"png"]];
//    [arrayGif addObject:gif];
    
    for (int i = 0; i<self.imageOptins.count; i++) {
        [arrayGif addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageOptins[i] ofType:@"png"]]];

    }
    
//    [arrayGif addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"]]];
    
    
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

- (IBAction)start:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开始抽奖"]) {
        if (arrayGif.count>0) {
            //设置动画数组
            [self.productView setAnimationImages:arrayGif];
            
            //设置动画播放次数
            [self.productView setAnimationRepeatCount:0];
            //设置动画播放时间
            [self.productView setAnimationDuration:0.3];
            //开始动画
            [self.productView startAnimating];
            
        }
        [sender setTitle:@"停!" forState:UIControlStateNormal];
    }else
    {
        CGPoint productViewCenter = self.productView.center;
      
        CGRect productViewFrame = self.productView.frame;
        
        [self.productView setFrame:CGRectMake(0, 0, 0, 0)];
        [self.productView setCenter:productViewCenter];
        
        [self.productView stopAnimating];
        
        
        NSInteger selected =  arc4random() % self.imageOptins.count;
        [self.productView setImage:[UIImage imageNamed:self.imageOptins[selected]]];
        [sender setTitle:@"开始抽奖" forState:UIControlStateNormal];
        

        
        [UIView animateWithDuration: 1.7
                         animations: ^{
                             
                             [self.productView setFrame:productViewFrame];
                         }
                         completion: ^(BOOL finished) {
                             
                             [self.resultLabel setText:[NSString stringWithFormat:@"恭喜,您获得了新品:\n%@",self.imageOptins[selected]]];

                             
                         }
         ];
        

    }

}
@end
