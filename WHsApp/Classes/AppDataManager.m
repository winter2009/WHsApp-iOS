//
//  AppDataManager.m
//  hongye-iphone
//
//  Created by Zonghui Zhang on 29/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDataManager.h"

#define KEY_REMEMBER_PASSWORD   @"lala-remember-password"
#define KEY_USERNAME            @"lala-username"
#define KEY_PASSWORD            @"lala-password"

static AppDataManager *singletonAppDataManager = nil;

@implementation AppDataManager
@synthesize user;
@synthesize isRememberPassword = m_isRememberPassword;
@synthesize username = m_username;
@synthesize password = m_password;

- (void)dealloc
{
    [user release];
    [m_username release];
    [m_password release];
    
	[super dealloc];
}

- (id)init
{
	if (( self = [super init] ))
	{
		m_isUserLoggedIn = NO;      
        m_userDefaults = [NSUserDefaults standardUserDefaults];
        
        BOOL isRemember = [m_userDefaults boolForKey:KEY_REMEMBER_PASSWORD];
        if ( isRemember ) 
        {
            m_isRememberPassword = YES;
            m_username = [m_userDefaults objectForKey:KEY_USERNAME];
            m_password = [m_userDefaults objectForKey:KEY_PASSWORD];
        }
        else 
        {
            m_isRememberPassword = NO;
        }
	}
	
	return self;
}

#pragma mark -
#pragma mark Public Methods
- (void)loggedIn
{
    m_isUserLoggedIn = YES;
}

- (void)loggedOut
{
    m_isUserLoggedIn = NO;
    self.user = nil;
}

- (BOOL)isUserLoggedIn
{
    return m_isUserLoggedIn;
}

- (void)rememberUsername:(NSString *)username password:(NSString *)password
{
    [m_userDefaults setBool:YES forKey:KEY_REMEMBER_PASSWORD];
    [m_userDefaults setObject:username forKey:KEY_USERNAME];
    [m_userDefaults setObject:password forKey:KEY_PASSWORD];
}

- (void)clearUsernamePassword
{
    [m_userDefaults setBool:NO forKey:KEY_REMEMBER_PASSWORD];
    [m_userDefaults removeObjectForKey:KEY_USERNAME];
    [m_userDefaults removeObjectForKey:KEY_PASSWORD];
}

#pragma mark -
#pragma mark Singelton Methods
+ (AppDataManager*)sharedAppDataManager 
{
	@synchronized ( self ) 
	{
		if ( !singletonAppDataManager ) 
		{
			singletonAppDataManager = [[AppDataManager alloc] init];
		}
	}
	
	return singletonAppDataManager;
}
 
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized ( self ) 
	{
        if ( !singletonAppDataManager ) 
		{
            singletonAppDataManager = [super allocWithZone:zone];
            return singletonAppDataManager;
        }
    }
	
    return nil;
}
 
- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}
 
- (id)retain 
{
	return self;
}
 
- (unsigned)retainCount 
{
	return UINT_MAX;  //denotes an object that cannot be released
}
 
- (void)release 
{
	//do nothing
}
 
- (id)autorelease 
{
	return self;
}

@end
