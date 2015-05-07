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

@interface ViewController ()
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
    
    [self dailyReward];
    

    
}

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
    rewardViewController *myReward = [[rewardViewController alloc] initWithNibName:@"rewardViewController" bundle:nil];
    [self.navigationController pushViewController:myReward animated:YES];

}

- (IBAction)store:(id)sender {
    
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
    [CommonUtility tapSound:@"entry" withType:@"m4a"];

    [self.navigationController pushViewController:myGame animated:YES];
    
}

#pragma mark Daily reward
- (void)dailyReward
{
    
    //eric:set last day
    
    netAssociation = [[NetAssociation alloc] initWithServerName:@"time.apple.com"];
    netAssociation.delegate = self;
    [netAssociation sendTimeQuery];

    
//    [self performSelector:@selector(getTime) withObject:nil afterDelay:1.0 ];
    

    
}



-(void)giveReward:(NSString *)day
{
    [[NSUserDefaults standardUserDefaults] setObject:day forKey:@"lastDailyReword"];
    
    UIAlertView *rewardAlert = [[UIAlertView alloc] initWithTitle:@"感谢您的支持" message:@"幸运屋已开启，快来试试手气吧" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    rewardAlert.tag = 100;
    [rewardAlert show];
    
}

/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃ Called when that single NetAssociation has a network time to report.                             ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/
- (void) reportFromDelegate {
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

    
}

@end
