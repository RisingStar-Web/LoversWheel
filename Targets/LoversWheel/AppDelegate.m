//
//  AppDelegate.m
//  LoversWheel
//
//  Created by Alec Bettinson on 20/02/2013.
//  Copyright (c) 2013 Alec Bettinson. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"WheelText" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *wheelText = [dict objectForKey:@"WheelText"];
    
    GameViewController *gameVC = [[GameViewController alloc] initWithWheelText:wheelText];
    gameVC.canShowDescription = YES;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:gameVC];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
