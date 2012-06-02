//
//  AppDelegate.h
//  WHsApp
//
//  Created by Zonghui Zhang on 27/5/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class AppDataManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginDelegate>
{
    AppDataManager          *m_appDataManager;
    UINavigationController  *m_loginController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

- (void)logout;

@end
