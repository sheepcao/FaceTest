

#import "myIAPHelper.h"

@implementation myIAPHelper

+ (myIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static myIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"sheepcao.AnimeFace.diamond1000",@"sheepcao.AnimeFace.diamond3",@"sheepcao.AnimeFace.diamond9",@"sheepcao.AnimeFace.diamond20",@"sheepcao.AnimeFace.hotSale",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
