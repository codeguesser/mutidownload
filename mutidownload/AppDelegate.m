//
//  AppDelegate.m
//  mutidownload
//
//  Created by  on 2012/5/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MYLoadingPic.h"
@implementation AppDelegate
@synthesize window = _window;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
    
    
    MYLoadingPic *pic = [[MYLoadingPic alloc]initWithFrame:CGRectMake(0, 100, 100, 100) url:@"https://devimages.apple.com.edgekey.net/programs/mac/images/hero20110712.png"];
    [self.window addSubview:pic];
    MYLoadingPic *pic1 = [[MYLoadingPic alloc]initWithFrame:CGRectMake(0, 300, 100, 100) url:@"http://www.codeguesser.tk/wp-content/themes/twentyeleven/images/headers/shore.jpg"];
    [self.window addSubview:pic1];
 
    
    
    [self.window makeKeyAndVisible];
    return YES;
}




@end
