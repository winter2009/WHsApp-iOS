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
#import <CoreLocation/CoreLocation.h>
#import "User.h"

@class AppDataManager;

@interface WebServiceManager : NSObject
{
    AppDataManager  *m_appDataManager;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password location:(CLLocation *)location andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)registerUserWithNickName:(NSString *)nickName email:(NSString *)email password:(NSString *)password location:(CLLocation *)location andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getNearbyUsersWithFilters:(CLLocation *)location filters:(NSDictionary *)filters andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getUserInfoWithUserID:(NSInteger)userID andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)createChatGroupWithUsers:(NSArray *)users andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)addUsersToChatGroup:(NSArray *)users groupID:(NSInteger)groupID andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)sendMessageToGroup:(NSInteger)senderID groupID:(NSInteger)groupID message:(NSString *)message andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getGroupChatHistory:(NSInteger)groupID since:(NSDate *)date andDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)getChatHistoryGroupListWithDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (void)updateUserDetailWithUser:(User *)user andDelegate:(id<ASIHTTPRequestDelegate>)delegate;

@end
