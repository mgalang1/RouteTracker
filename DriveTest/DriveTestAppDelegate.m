//
//  DriveTestAppDelegate.m
//  DriveTest
//
//  Created by Marvin Galang on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriveTestAppDelegate.h"
#import "HomeViewController.h"

@interface DriveTestAppDelegate()  


@property (retain, nonatomic) UITabBarController *tabController;

@end


@implementation DriveTestAppDelegate

@synthesize window = _window;
@synthesize tabController=_tabController;


- (void)dealloc
{
    [_window release];
    [_tabController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Allocate and Initialize tab bar controller
	self.tabController=[[[UITabBarController alloc] init]autorelease];
    
    HomeViewController *homeController=[[[HomeViewController alloc] init]autorelease];
    
    
    HomeViewController *homeController1=[[[HomeViewController alloc] init]autorelease];
    
    
	UINavigationController *tabViewController1 = [[[UINavigationController alloc] initWithRootViewController:homeController]autorelease];
	UINavigationController *tabViewController2 = [[[UINavigationController alloc] initWithRootViewController:homeController1]autorelease];
    
	NSMutableArray *viewControllersArray = [[[NSMutableArray alloc] init]autorelease];
	[viewControllersArray addObject:tabViewController1];
	[viewControllersArray addObject:tabViewController2];
    
    [self.tabController setViewControllers:viewControllersArray animated:YES];
    
    //[_window addSubview:_tabController.view];
    self.window.rootViewController = self.tabController; 
    
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
