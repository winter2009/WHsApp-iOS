//
//  WebServiceManager.m
//  LaLa
//
//  Created by Zonghui Zhang on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServiceManager.h"
#import "Settings.h"
#import "JSONKit.h"
#import "AppDataManager.h"

@implementation WebServiceManager

- (id)init
{
	if (( self = [super init] ))
	{
		m_appDataManager = [AppDataManager sharedAppDataManager];
	}
    
	return self;
}

- (void)registerUserWithNickName:(NSString *)nickName email:(NSString *)email password:(NSString *)password location:(CLLocation *)location andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_REGISTER];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addPostValue:nickName forKey:@"nick_name"];
    [request addPostValue:email forKey:@"email"]; 
    [request addPostValue:password forKey:@"password"]; 
    
    if ( location != nil )
    {
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"]; 
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];         
    }
    else 
    {
        [request addPostValue:[NSNull null] forKey:@"latitude"]; 
        [request addPostValue:[NSNull null] forKey:@"longitude"];
    }
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password location:(CLLocation *)location andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_LOGIN];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:username];
    [request addRequestHeader:@"X_PASSWORD" value:password];
    if ( location != nil )
    {
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"]; 
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];
    }
    else 
    {
//        [request addPostValue:[NSNull null] forKey:@"latitude"]; 
//        [request addPostValue:[NSNull null] forKey:@"longitude"];
        
        // testing
        [request addPostValue:@"1.339121" forKey:@"latitude"]; 
        [request addPostValue:@"103.681857" forKey:@"longitude"];
    }
    
//    NSLog(@"%@ %@ %f %f", username, password, location.coordinate.latitude, location.coordinate.longitude);
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)getNearbyUsersWithFilters:(CLLocation *)location filters:(NSDictionary *)filters andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETNEARBYUSERSWITHFILTERS];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    if ( location != nil )
    {
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"]; 
        [request addPostValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];         
    }
    else 
    {
//        [request addPostValue:[NSNull null] forKey:@"latitude"]; 
//        [request addPostValue:[NSNull null] forKey:@"longitude"];
        
        // testing
        [request addPostValue:@"1.339121" forKey:@"latitude"]; 
        [request addPostValue:@"103.681857" forKey:@"longitude"];
    }
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)getUserInfoWithUserID:(NSInteger)userID andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETUSERINFO];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[NSNumber numberWithInt:userID] forKey:@"user_id"];
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)createChatGroupWithUsers:(NSArray *)users andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_CREATECHATGROUP];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    NSMutableDictionary *groupUsers = [[NSMutableDictionary alloc] init];
    [groupUsers setObject:users forKey:@"group_members"];
    [groupUsers setObject:[NSNumber numberWithInt:m_appDataManager.user.id] forKey:@"creator_id"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[groupUsers JSONString] forKey:@"participants"];    
    
//    NSLog(@"participants: %@", [groupUsers JSONString]);
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)addUsersToChatGroup:(NSArray *)users groupID:(NSInteger)groupID andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_ADDUSERSTOCHATGROUP];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[users JSONString] forKey:@"users"];    
    [request addPostValue:[NSNumber numberWithInt:groupID] forKey:@"group_id"];
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)sendMessageToGroup:(NSInteger)senderID groupID:(NSInteger)groupID message:(NSString *)message andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_SENDMESSAGETOGROUP];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[NSNumber numberWithInt:senderID] forKey:@"sender_id"];
    [request addPostValue:[NSNumber numberWithInt:groupID] forKey:@"group_id"];
    [request addPostValue:message forKey:@"message"];
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)getGroupChatHistory:(NSInteger)groupID since:(NSDate *)date andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETGROUPCHATHISTORY];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[NSNumber numberWithInt:groupID] forKey:@"group_id"];
    
    if ( date != nil )
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [request addPostValue:[df stringFromDate:date] forKey:@"since"];
        [df release];
    }

    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)getChatHistoryGroupListWithDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETCHATHISTORYGROUPLIST];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[NSNumber numberWithInt:m_appDataManager.user.id] forKey:@"user_id"];
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

- (void)updateUserDetailWithUser:(User *)user andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_UPDATEUSERDETAIL];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"X_USERNAME" value:m_appDataManager.user.email];
    [request addRequestHeader:@"X_PASSWORD" value:m_appDataManager.user.password];
    [request addPostValue:[user jsonString] forKey:@"user"];
    
    request.delegate = delegate;
    
    [request startAsynchronous];
}

@end
