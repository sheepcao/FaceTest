//
//  ViewController.m
//  Anime Face
//
//  Created by Eric Cao on 3/26/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "ViewController.h"
#import "gameViewController.h"
#import "rewardViewController.h"
#import "storeViewController.h"
#import "buyOneViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMailComposeViewControllerDelegate>
{
    NetworkClock *                  netClock;
    NetAssociation *                netAssociation;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    netClock = [NetworkClock sharedNetworkClock];

    self.navigationController.navigationBarHidden = YES;

//    [self copyPlistToDocument:@"GameData"];
//    self.GameDatas = [self readDataFromPlist:@"GameData"];
    
    [self updatePlistWhenUpdateing];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasBoughtHotSale"]){
        [self.oneBuy setHidden:YES];
        return;
    }else
    {
        [self goUpper];
    }
    
    NSString *diamond = [[NSUserDefaults standardUserDefaults] objectForKey:@"diamond"];
    
    if (diamond) {
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:StartDiamond forKey:@"diamond"];
        UIButton *firstLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/30, 1.5*SCREEN_WIDTH/30)];
        [firstLogin setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        
        [firstLogin setImage:[UIImage imageNamed:@"shoudengdali"] forState:UIControlStateNormal];
        [firstLogin setImage:[UIImage imageNamed:@"shoudengdali"] forState:UIControlStateHighlighted];
        [firstLogin addTarget:self action:@selector(cancelift:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:firstLogin];

        [CommonUtility tapSound:@"boxOpen" withType:@"mp3"];
        

        [UIView beginAnimations:nil context:NULL];
        
        CGAffineTransform  transform;
        transform = CGAffineTransformScale(firstLogin.transform,28,28);
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationDelegate:self];
        [firstLogin setTransform:transform];
//        [firstLogin setFrame:CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH*1.5/2, SCREEN_WIDTH, 1.5*SCREEN_WIDTH)];
        
        [UIView commitAnimations];

        
//        [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
//            [firstLogin setFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/2-SCREEN_WIDTH/2, SCREEN_WIDTH*2/3, SCREEN_WIDTH)];
//        } completion:nil];

        
        
    }

    
    
}

-(void)cancelift:(UIButton *)sender
{
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"cardClose" withType:@"mp3"];
    }
    
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [sender setFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT+20, SCREEN_WIDTH*2/3, SCREEN_WIDTH)];
    } completion:nil];
    [sender removeFromSuperview];
    
}
-(void)goUpper
{
    UIButton *button = self.oneBuy;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y-10, button.frame.size.width,button.frame.size.height)];
    [UIView commitAnimations];
    
    [self performSelector:@selector(startBounce:) withObject:button afterDelay:0.22];
}

-(void)startBounce:(UIButton *)button
{
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.25
          initialSpringVelocity:0.4
                        options:0 animations:^{
                            
                            CGRect aframe = button.frame;
                            aframe.origin.y +=10;
                            [button setFrame:aframe];
                        }
                     completion:^(BOOL finished) {

                         [self performSelector:@selector(goUpper) withObject:nil afterDelay:1.95];
                     }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dailyReward];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasBoughtHotSale"]){
        [self.oneBuy setHidden:YES];
        return;
    }else
    {
        [self.oneBuy setHidden:NO];

    }


}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBounce:) object:self.oneBuy];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goUpper) object:nil];
//
//
//}


-(void)updatePlistWhenUpdateing
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"prior_version"] isEqualToString:VERSIONNUMBER]) {
        
        [self copyPlistToDocument:@"GameData"];
        
        return;
    }else
    {
        [self removePlistFromDocument:@"gameData"];
        [self copyPlistToDocument:@"GameData"];
//        self.GameDatas = [self readDataFromPlist:@"GameData"];
        
        [[NSUserDefaults standardUserDefaults] setObject:VERSIONNUMBER forKey:@"prior_version"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Plist Data

-(void)removePlistFromDocument:(NSString *)plistname
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSError *error;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:folderPath] == YES)
    {
        
        
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }
    
}

-(void)copyPlistToDocument:(NSString *)plistname
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSLog(@"Source Path: %@\n Documents Path: %@ \n Folder Path: %@", sourcePath, documentsDirectory, folderPath);
    
    NSError *error;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:folderPath] == NO)
    {
        
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                toPath:folderPath
                                                 error:&error];
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }
    
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

-(void)modifyPlist:(NSString *)plistname withValue:(id)value forKey:(NSString *)key
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@.plist",plistname ]];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plistPath] == YES)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [infoDict setObject:value forKey:key];
            [infoDict writeToFile:plistPath atomically:NO];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
        }
    }
}


- (IBAction)getReward:(id)sender {
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    rewardViewController *myReward = [[rewardViewController alloc] initWithNibName:@"rewardViewController" bundle:nil];
    
    self.GameDatas = [self readDataFromPlist:@"GameData"];
    
    myReward.GameData = self.GameDatas;
    [self.navigationController pushViewController:myReward animated:YES];

}

- (IBAction)store:(id)sender {
    
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    storeViewController *myStore = [[storeViewController alloc] initWithNibName:@"storeViewController" bundle:nil];
    self.GameDatas = [self readDataFromPlist:@"GameData"];

    myStore.GameData = self.GameDatas;
    
    [self.navigationController pushViewController:myStore animated:YES];

    
}

- (IBAction)enterGame:(UIButton *)sender {
    gameViewController *myGame = [[gameViewController alloc] initWithNibName:@"gameViewController" bundle:nil];
    
    self.GameDatas = [self readDataFromPlist:@"GameData"];

    myGame.GameData = self.GameDatas;
    myGame.sex = (int)sender.tag;
    [CommonUtility tapSound:@"entry" withType:@"mp3"];

    [self.navigationController pushViewController:myGame animated:YES];
//    [self presentViewController:myGame animated:YES completion:nil];
    
}

- (IBAction)oneBuyClick:(id)sender {
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    if(!self.myBuyOneController)
    {
    self.myBuyOneController = [[buyOneViewController alloc] initWithNibName:@"buyOneViewController" bundle:nil];
    self.myBuyOneController.closeDelegate =self;
    
    [self.myBuyOneController view];
    
    
    self.buyDiamondView = self.myBuyOneController.view;
    [self.buyDiamondView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    [self.view addSubview:self.buyDiamondView];
    }
    
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyDiamondView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:nil];
    
    
}

- (IBAction)settingTap:(id)sender {
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    [self setupSettingView];
}


-(void)stopJump
{
    [self.oneBuy setHidden:YES];
}
-(void)closingBuy
{
    if(soundSwitch)
    {
        [CommonUtility tapSound:@"click" withType:@"mp3"];
    }
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.buyDiamondView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    } completion:nil];

    
    
}


#pragma mark Daily reward
- (void)dailyReward
{
    
    //eric:set last day
    if(!netAssociation)
    {
        netAssociation = [[NetAssociation alloc] initWithServerName:@"time.apple.com"];
        netAssociation.delegate = self;
    }

    [netAssociation sendTimeQuery];

    
//    [self performSelector:@selector(getTime) withObject:nil afterDelay:1.0 ];
    

    
}



-(void)giveReward:(NSString *)day
{
    [[NSUserDefaults standardUserDefaults] setObject:day forKey:@"lastDailyReword"];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"luckyFinished"];

    

    
}

/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃ Called when that single NetAssociation has a network time to report.                             ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/
- (void) reportFromDelegate {
    
    NSLog(@"time net:%f",netAssociation.offset);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    //set locale
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLang];
    [dateFormat setLocale:locale];
    
    NSDate *dateNet = [[NSDate date] dateByAddingTimeInterval:-netAssociation.offset];
    
    NSString *today = [dateFormat stringFromDate:dateNet];
    NSString *todaylocal = [dateFormat stringFromDate:[NSDate date]];
    
    NSLog(@"today is :%@----local is :%@",today,todaylocal);
    NSLog(@"time:%@",[NSDate date]);
    NSLog(@"time2:%@",dateNet);
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastDailyReword"]) {
        
        [self giveReward:today];
        
    }else if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"lastDailyReword"] isEqualToString:today])
    {
        [self giveReward:today];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"luckyFinished"] isEqualToString:@"yes"]) {
        
        [self.freeImage setHidden:YES];
        
    }else
    {
        [self.freeImage setHidden:NO];

    }

    
}


#pragma settingView
-(void)setupSettingView
{
    UIView *settingBack = [[UIView alloc] initWithFrame:self.view.frame];
    [settingBack setBackgroundColor:[UIColor clearColor]];
    
    
    UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, SCREEN_HEIGHT+10, 295, 325)];
    settingView.alpha = 0.0f;
    [settingBack addSubview:settingView];
    
    [self.view addSubview:settingBack];
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 325)];
    [backImg setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"setting board" ofType:@"png"]]];
    [settingView addSubview:backImg];
 
    
    
    UIButton *musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImg.frame.size.width/2-128, 55, 116, 35)];
    [musicBtn setImage:[UIImage imageNamed:@"music on"] forState:UIControlStateNormal];
    [musicBtn setImage:[UIImage imageNamed:@"music off"] forState:UIControlStateSelected];
    [musicBtn addTarget:self action:@selector(musicTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (musicSwitch)
    {
        [musicBtn setSelected:NO];
    }else
    {
        [musicBtn setSelected:YES];
    }
    
    UIButton *soundBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImg.frame.size.width/2+12, 55, 116, 35)];
    [soundBtn setImage:[UIImage imageNamed:@"voice on"] forState:UIControlStateNormal];
    [soundBtn setImage:[UIImage imageNamed:@"voice off"] forState:UIControlStateSelected];
    [soundBtn addTarget:self action:@selector(soundTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (soundSwitch)
    {
        [soundBtn setSelected:NO];
    }else
    {
        [soundBtn setSelected:YES];
    }
    
    UIButton *reviewBtn = [[UIButton alloc] initWithFrame:CGRectMake(33, soundBtn.frame.origin.y+48, 214, 35)];
    [reviewBtn setImage:[UIImage imageNamed:@"give advice normal"] forState:UIControlStateNormal];
    [reviewBtn setImage:[UIImage imageNamed:@"give advice press"] forState:UIControlStateHighlighted];
    [reviewBtn addTarget:self action:@selector(reviewTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *teamProductBtn = [[UIButton alloc] initWithFrame:CGRectMake(33, reviewBtn.frame.origin.y+48, 214, 35)];
    [teamProductBtn setImage:[UIImage imageNamed:@"team production normal"] forState:UIControlStateNormal];
    [teamProductBtn setImage:[UIImage imageNamed:@"team production press"] forState:UIControlStateHighlighted];
    [teamProductBtn addTarget:self action:@selector(teamProductTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(33, teamProductBtn.frame.origin.y+48, 214, 35)];
    [shareBtn setImage:[UIImage imageNamed:@"share normal"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share press"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareAppTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, shareBtn.frame.origin.y+45, 260, 3)];
    [line setImage:[UIImage imageNamed:@"xuxian"]];
    
    UIButton *contact = [[UIButton alloc] initWithFrame:CGRectMake(10, line.frame.origin.y+10, 260, 35)];
    contact.backgroundColor = [UIColor clearColor];
    contact.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [contact setTitleColor:[UIColor colorWithRed:155/255.0f green:86/255.0f blue:65/255.0f alpha:1.0] forState:UIControlStateNormal] ;
    [contact setTitle:@"联系我们: 3284753277@qq.com" forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(contactTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(settingView.frame.size.width-140, settingView.frame.size.height-35, 130, 30)];
    [versionLabel setText:[NSString stringWithFormat:@"版本号: V%@",VERSIONNUMBER]];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor colorWithRed:146/255.0f green:127/255.0f blue:122/255.0f alpha:1.0];
    versionLabel.font = [UIFont systemFontOfSize:14.0];

    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(settingView.frame.size.width-35, 0, 35, 35)];
    [cancelBtn setImage:[UIImage imageNamed:@"closeBuyBtn"] forState:UIControlStateNormal];
//    [cancelBtn setImage:[UIImage imageNamed:@"cancel-press"] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [settingView addSubview:musicBtn];
    [settingView addSubview:soundBtn];
    [settingView addSubview:reviewBtn];
    [settingView addSubview:teamProductBtn];
    [settingView addSubview:shareBtn];
    [settingView addSubview:line];
    [settingView addSubview:contact];
    [settingView addSubview:versionLabel];

    [settingView addSubview:cancelBtn];
    
    
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        
        [settingView setFrame:CGRectMake((SCREEN_WIDTH-280)/2, (SCREEN_HEIGHT-325)/2, 295, 325)];
        settingView.alpha = 1;
        
    } completion:nil];
    
    
    
}

-(void)cancelAlert:(UIButton *)sender
{
    UIView *theAlertView = [[sender superview] superview];
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        
        [theAlertView setFrame:CGRectMake(0, SCREEN_HEIGHT+10, SCREEN_WIDTH ,SCREEN_HEIGHT)];
        theAlertView.alpha = 0;

    } completion:^(BOOL isfinished){
        [theAlertView removeFromSuperview];

    }];


    
}

-(void)soundTapped:(UIButton *)sender
{

    if (soundSwitch)
    {
        [sender setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"soundSwitch"];
        soundSwitch = NO;
    }else
    {
        [sender setSelected:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"soundSwitch"];
        soundSwitch = YES;
    }
    
    
}

-(void)musicTapped:(UIButton *)sender
{
    
    if (musicSwitch)
    {
        [sender setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"musicSwitch"];
        musicSwitch = NO;
        [CommonUtility stopBackMusic];

        
    }else
    {
        [sender setSelected:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"musicSwitch"];
        musicSwitch = YES;
        [CommonUtility playBackMusic];

    }
    
    
}
-(void)reviewTapped:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];

}
-(void)teamProductTapped:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];

}
-(void)shareAppTapped:(UIButton *)sender
{
    UIImage *icon = [UIImage imageNamed:@"ICON 512"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"萌漫头像"
                                       defaultContent:NSLocalizedString(@"",nil)
                                                image:[ShareSDK pngImageWithImage:icon]
                                                title:@"萌漫头像"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"",nil)
                                            mediaType:SSPublishContentMediaTypeNews];
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
                                    //eric: to be sned da bai....
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    

}

-(void)contactTapped:(UIButton *)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker.view setFrame:CGRectMake(0,20 , 320, self.view.frame.size.height-20)];
    picker.mailComposeDelegate = self;
    
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"sheepcao1986@163.com"];
    
    
    [picker setToRecipients:toRecipients];

    NSString *emailBody= @"";
    if ([CommonUtility isSystemLangChinese]) {
        [picker setSubject:@"意见反馈-萌漫头像"];
        emailBody = @"感谢您使用萌漫头像，您的反馈意见对我们很重要，我们将持续更新和改善，希望萌漫头像能带给您更多的惊喜和乐趣。";
    }else
    {
        
        [picker setSubject:@"Feed back - Face Anime"];
        emailBody = @"Dear consumer,\nThanks for using Face Anime. Your feedback is very precious. Let's improve this App together!";
    }
    
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)alertWithTitle: (NSString *)_title_ msg: (NSString *)msg

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                          
                                                    message:msg
                          
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    NSString *title = @"发送状态";
    
    NSString *msg;
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            msg = @"Mail canceled";//@"邮件发送取消";
            
            break;
            
        case MFMailComposeResultSaved:
            
            msg = @"邮件保存成功";//@"邮件保存成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultSent:
            
            msg = @"邮件发送成功";//@"邮件发送成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultFailed:
            
            msg = @"邮件发送失败";//@"邮件发送失败";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        default:
            
            msg = @"邮件尚未发送";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
    }
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}

@end
