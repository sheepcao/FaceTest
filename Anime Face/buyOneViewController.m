//
//  buyOneViewController.m
//  Anime Face
//
//  Created by Eric Cao on 5/29/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "buyOneViewController.h"
#import "myIAPHelper.h"
#import "IAPButton.h"
#import <StoreKit/StoreKit.h>
@interface buyOneViewController ()
{
    NSMutableArray *_products;
    
}
@end

@implementation buyOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loadingView setHidden:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)productPurchased:(NSNotification *)notification {
    if (![self.loadingView isHidden]) {
        [self.loadingView setHidden:YES];
    }
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            if ([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.hotSale"]) {
                
                [CommonUtility coinsChange:20];
                [self writeToPurchasedFor:@"手势" withProduct:@"diannaoshoushi"];
                [self writeToPurchasedFor:@"头发女" withProduct:@"xuezhizi"];
                [self writeToPurchasedFor:@"头发" withProduct:@"xuezhizi"];

                [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"hasBoughtHotSale"];
                
                [self.closeDelegate stopJump];
                [self.closeDelegate closingBuy];
                
            }
        }
    }];
    
    
    
}
-(void)writeToPurchasedFor:(NSString *)catalog withProduct:(NSString *)productName
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:catalog]) {
        
        
        NSMutableDictionary *purchasedCatelog = [[NSMutableDictionary alloc] init];
        [purchasedCatelog setObject:@"yes" forKey:@"haveNew"];
        
        NSMutableDictionary *purchasedDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:catalog]];
        
        NSMutableArray *purchasedArray = [NSMutableArray arrayWithArray:[purchasedDic objectForKey:@"purchasedArray"]];
        
        
        NSString *newProductName = [NSString stringWithFormat:@"%@+new",productName];
        [purchasedArray addObject:newProductName];
        [purchasedCatelog setObject:purchasedArray forKey:@"purchasedArray"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:catalog];
        
        
    }else
    {
        NSMutableDictionary *purchasedCatelog = [[NSMutableDictionary alloc] init];
        [purchasedCatelog setObject:@"yes" forKey:@"haveNew"];
        
        NSMutableArray *purchasedArray = [[NSMutableArray alloc] init];
        
        NSString *newProductName = [NSString stringWithFormat:@"%@+new",productName];
        [purchasedArray addObject:newProductName];
        
        [purchasedCatelog setObject:purchasedArray forKey:@"purchasedArray"];
        
        [[NSUserDefaults standardUserDefaults] setObject:purchasedCatelog forKey:catalog];
    }
  
}



-(void)reloadwithRefreshControl{
    if ([self.loadingView isHidden]) {
        [self.loadingView setHidden:NO];
    }
    _products = nil;
    [[myIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = [NSMutableArray arrayWithArray:products];
            
            [self buyAction];
            
        }else
        {
            UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取网络数据失败,请检查您的网络状态。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [netAlert show];
            [self.closeDelegate closingBuy];
        }
        
        
    }];
}


-(void)buyAction
{
    int i = 0;
    for (SKProduct *product in _products) {
        
        
        if([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.hotSale"])
        {
            [[myIAPHelper sharedInstance] buyProduct:product withLoadingView:self.loadingView];
            if ([self.loadingView isHidden]) {
                [self.loadingView setHidden:NO];
            }
            break;
        }
        
        i++;

        
    }
    
    if (i== 5 ) {
        UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取网络数据失败,请检查您的网络状态。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [netAlert show];
        [self.closeDelegate closingBuy];
    }

}


- (IBAction)buyOneTap:(id)sender {
    
    [self reloadwithRefreshControl];

}

- (IBAction)closeBuy:(id)sender {
    [self.closeDelegate closingBuy];
    [self.loadingView setHidden:YES];

}
@end
