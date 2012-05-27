//
//  AppDataManager.h
//  hongye-iphone
//
//  Created by Zonghui Zhang on 29/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AppDataManager : NSObject 
{
    BOOL            m_isUserLoggedIn;
    NSUserDefaults  *m_userDefaults;
    BOOL            m_isRememberPassword;
    NSString        *m_username;
    NSString        *m_password;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@property (nonatomic) BOOL isRememberPassword;


+ (AppDataManager*)sharedAppDataManager;
- (void)loggedIn;
- (void)loggedOut;
- (BOOL)isUserLoggedIn;
- (void)rememberUsername:(NSString *)username password:(NSString *)password;
- (void)clearUsernamePassword;

@end
