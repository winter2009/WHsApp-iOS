//
//  WebServiceManager.h
//  LaLa
//
//  Created by Zonghui Zhang on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import <CoreLocation/CoreLocation.h>
#import "User.h"

@class AppDataManager;

@interface WebServiceManager : NSObject
{
    AppDataManager  *m_appDataManager;
    ASINetworkQueue *m_networkQueue;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)registerUserWithNickName:(NSString *)nickName email:(NSString *)email password:(NSString *)password andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getCagetoriesWithDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getSubCategoriesForCategory:(NSString *)category withDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)sendMessageToAdmin:(NSInteger)senderID subject:(NSString *)subject content:(NSString *)content replyTo:(NSInteger)messageID withDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getMessagesForUser:(NSInteger)userID withDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getMediaForSubCategory:(NSInteger)subCategoryID withDelegate:(id<ASIHTTPRequestDelegate>)delegate;

- (void)cancelRequests;

@end
