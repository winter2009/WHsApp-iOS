//
//  AppDelegate.m
//  WHsApp
//
//  Created by Zonghui Zhang on 27/5/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

- (void)checkNeedLogin;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize rootNavigationController = _rootNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    m_appDataManager = [AppDataManager sharedAppDataManager];
    HomeViewController *homeController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window.rootViewController = self.rootNavigationController;
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginController.delegate = self;
    m_loginController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    [self.window makeKeyAndVisible];
    
    [self checkNeedLogin];
    
    self.rootNavigationController.navigationBar.barStyle = UIBarStyleBlack;

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

#pragma mark -
#pragma mark Public Method
- (void)logout
{
    [m_appDataManager loggedOut];
    [m_appDataManager clearUsernamePassword];
    [self checkNeedLogin];
}

#pragma mark -
#pragma mark Private Method
- (void)checkNeedLogin
{
    if ( ![m_appDataManager isUserLoggedIn] ) 
    {
        [m_loginController popToRootViewControllerAnimated:NO];
        [self.rootNavigationController presentModalViewController:m_loginController animated:NO];
    }
}

#pragma mark -
#pragma mark Login Delegate
- (void)loginSucceed
{
    [self.rootNavigationController dismissModalViewControllerAnimated:YES];
}


@end
