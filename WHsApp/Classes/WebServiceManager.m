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

- (void)dealloc
{
    [m_networkQueue cancelAllOperations];
}

- (id)init
{
	if (( self = [super init] ))
	{
		m_appDataManager = [AppDataManager sharedAppDataManager];
        m_networkQueue = [[ASINetworkQueue alloc] init];
	}
    
	return self;
}

- (void)registerUserWithNickName:(NSString *)nickName email:(NSString *)email password:(NSString *)password andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_REGISTER];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addPostValue:nickName forKey:@"nick_name"];
    [request addPostValue:email forKey:@"email"]; 
    [request addPostValue:password forKey:@"password"]; 
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_LOGIN];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:username];
    [request addRequestHeader:@"PASSWORD" value:password];
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)getCagetoriesWithDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETCATEGORIES];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:m_appDataManager.username];
    [request addRequestHeader:@"PASSWORD" value:m_appDataManager.password];
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)getSubCategoriesForCategory:(NSString *)category withDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETSUBCATEGORIES];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:m_appDataManager.username];
    [request addRequestHeader:@"PASSWORD" value:m_appDataManager.password];
    [request addPostValue:category forKey:@"category"];
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)sendMessageToAdmin:(NSInteger)senderID subject:(NSString *)subject content:(NSString *)content replyTo:(NSInteger)messageID withDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_SENDMESSAGETOADMIN];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:m_appDataManager.username];
    [request addRequestHeader:@"PASSWORD" value:m_appDataManager.password];
    [request addPostValue:[NSNumber numberWithInt:senderID] forKey:@"sender_id"];
    [request addPostValue:subject forKey:@"subject"];
    [request addPostValue:content forKey:@"content"];
    if ( messageID > 0 )
    {
        [request addPostValue:[NSNumber numberWithInt:messageID] forKey:@"parent_message_id"];
    }

    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)getMessagesForUser:(NSInteger)userID withDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETMESSAGES];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:m_appDataManager.username];
    [request addRequestHeader:@"PASSWORD" value:m_appDataManager.password];
    [request addPostValue:[NSNumber numberWithInt:userID] forKey:@"user_id"];
    
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)getMediaForSubCategory:(NSInteger)subCategoryID withDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    NSString *serviceUrlString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_BASE_URL, WEBSERVICE_GETMEDIAFORSUBCATEGORY];
    NSURL *serviceUrl = [NSURL URLWithString:serviceUrlString];
    NSLog(@"%@", serviceUrlString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:serviceUrl];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"USERNAME" value:m_appDataManager.username];
    [request addRequestHeader:@"PASSWORD" value:m_appDataManager.password];
    [request addPostValue:[NSNumber numberWithInt:subCategoryID] forKey:@"sub_category_id"];
    
    request.delegate = delegate;
    
    [m_networkQueue addOperation:request];
    [m_networkQueue go];
}

- (void)cancelRequests
{
    for ( ASIHTTPRequest *request in m_networkQueue.operations ) 
    {
        [request clearDelegatesAndCancel];
    }
    
    [m_networkQueue cancelAllOperations];
}

@end
