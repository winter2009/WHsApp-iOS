//
//  User.m
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "User.h"
#import "JSONKit.h"

@implementation User
@synthesize id;
@synthesize email;
@synthesize password;
@synthesize nickName;

- (NSString *)jsonString
{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    [userDict setObject:[NSNumber numberWithInt:id] forKey:@"id"];
    [userDict setObject:email forKey:@"email"];
    [userDict setObject:nickName forKey:@"nick_name"];    
    
    return [userDict JSONString];
}

@end
