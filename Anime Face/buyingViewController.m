//
//  buyingViewController.m
//  Anime Face
//
//  Created by Eric Cao on 5/29/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "buyingViewController.h"
#import "myIAPHelper.h"
#import "IAPButton.h"
#import <StoreKit/StoreKit.h>

@interface buyingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_products;
    
}
@property (nonatomic,strong) NSArray *prodcutsArray;

@end

@implementation buyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.prodcutsArray = @[@"60",@"190(赠10)",@"640(赠40)",@"1448(赠168)"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self.loadingView setHidden:YES];
    
    
    
    
    [self.itemTable setDelegate:self];
    [self.itemTable setDataSource:self];
    
    //    [self.itemsTable addSubview:self.refreshControl];
    
    
    
    //    [self.refreshControl addTarget:self action:@selector(reloadwithRefreshControl:) forControlEvents:UIControlEventValueChanged];
    [self reloadwithRefreshControl];
    
    
    
    
    [self.itemTable reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productPurchased:(NSNotification *)notification {
    
    [MobClick event:@"buyDiamond"];

    
    if (![self.loadingView isHidden]) {
        [self.loadingView setHidden:YES];
    }
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            if ([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.diamond1000"]) {
                
                
                [CommonUtility coinsChange:60];
                [self.closeDelegate makeDiamondLabel:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
                
                
            }else if([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.diamond3"])
            {
                
                [CommonUtility coinsChange:190];//18元买190coins
                
                [self.closeDelegate makeDiamondLabel:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
                //                [_parentCoinsButton setTitle:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]] forState:UIControlStateNormal];
            }else if([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.diamond9"])
            {
                
                [CommonUtility coinsChange:640];//60元买640coins
                
                [self.closeDelegate makeDiamondLabel:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
            }else if([product.productIdentifier isEqualToString:@"sheepcao.AnimeFace.diamond20"])
            {
                
                [CommonUtility coinsChange:1448];//128元买1448coins
                
                [self.closeDelegate makeDiamondLabel:[NSString stringWithFormat:@"%d",[CommonUtility fetchCoinAmount]]];
                
            }
            
        }
    }];
    
    
    
}



-(void)reloadwithRefreshControl{
    if ([self.loadingView isHidden]) {
        [self.loadingView setHidden:NO];
    }
    _products = nil;
    [[myIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = [NSMutableArray arrayWithArray:products];
            
            
            
            [self.itemTable reloadData];
        }else
        {
            UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取网络数据失败,请检查您的网络状态。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [netAlert show];
            [self.closeDelegate closingBuy];
        }
        [self.loadingView setHidden:YES];
        
    }];
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _products.count - 1;//hot sale minus one
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemTable.frame.size.height-1)/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"2");
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"buyCellView" owner:self options:nil];
    
    buyCellView *cell = [topLevelObjects lastObject];//加载nib文件
    //    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.priceLabel.text = self.prodcutsArray[indexPath.row];
    [cell.priceBtn addTarget:self action:@selector(buyClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row==0)
    {
        cell.priceBtn.identify = @"sheepcao.AnimeFace.diamond1000";
        UIImage *sixImage = [UIImage imageNamed:@"6kuai-normal"];
        [cell.priceBtn setImage:sixImage forState:UIControlStateNormal];
        [cell.priceBtn setImage:[UIImage imageNamed:@"6kuai-press"] forState:UIControlStateHighlighted];
        
        
    }else if (indexPath.row==1)
    {
        cell.priceBtn.identify = @"sheepcao.AnimeFace.diamond3";
        [cell.priceBtn setImage:[UIImage imageNamed:@"18kuai-normal"] forState:UIControlStateNormal];
        [cell.priceBtn setImage:[UIImage imageNamed:@"18kuai-press"] forState:UIControlStateHighlighted];
        
    }else if (indexPath.row==2)
    {
        cell.priceBtn.identify = @"sheepcao.AnimeFace.diamond9";
        [cell.priceBtn setImage:[UIImage imageNamed:@"60kuai-normal"] forState:UIControlStateNormal];
        [cell.priceBtn setImage:[UIImage imageNamed:@"60kuai-press"] forState:UIControlStateHighlighted];
        
    }else if (indexPath.row==3)
    {
        cell.priceBtn.identify = @"sheepcao.AnimeFace.diamond20";
        [cell.priceBtn setImage:[UIImage imageNamed:@"128kuai-normal"] forState:UIControlStateNormal];
        [cell.priceBtn setImage:[UIImage imageNamed:@"128kuai-press"] forState:UIControlStateHighlighted];
        
    }
    
    
    
    return cell;
}


-(void)buyClicked:(IAPButton *)sender
{
    
    for (SKProduct *product in _products) {
        
        if ([product.productIdentifier isEqualToString:sender.identify]) {
            [[myIAPHelper sharedInstance] buyProduct:product withLoadingView:self.loadingView];
            
            [self.loadingView setHidden:NO];
            break;
        }
    }
    
    
}




- (IBAction)closeIAP:(id)sender {
    [self.closeDelegate closingBuy];
    [self.loadingView setHidden:YES];

}
@end
