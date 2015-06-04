//
//  TestViewController.m
//  Anime Face
//
//  Created by Eric Cao on 6/4/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) NSMutableData *image;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loadingBack" ofType:@"png"]];
    self.image = [[NSMutableData alloc] init];
    for (int i = 0; i < 1000000; i++) {
        [self.image appendData:data];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.image = nil;
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
