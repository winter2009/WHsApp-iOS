//
//  User.m
//  LaLa
//
//  Created by Zonghui Zhang on 11/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "JSONKit.h"

@implementation User
@synthesize id;
@synthesize nickName;
@synthesize email;
@synthesize password;
@synthesize avatar;

@synthesize lastLoginTime;
@synthesize loveRole;
@synthesize loveRoleID;

@synthesize loveType;
@synthesize smokeStatus;
@synthesize drinkStatus;
@synthesize marriageStatus;
@synthesize comeOutStatus;
@synthesize constellation;
@synthesize web;
@synthesize weibo;
@synthesize address;
@synthesize religion;
@synthesize provinceOfBirth;
@synthesize cityOfBirth;
@synthesize province;
@synthesize city;
@synthesize qq;
@synthesize msn;
@synthesize selfIntro;
@synthesize hobbies;
@synthesize profession;

@synthesize age;
@synthesize latitude;
@synthesize longitude;
@synthesize moodMessage;

- (void)dealloc
{
    [nickName release];
    [email release];
    [password release];
    [avatar release];
    [lastLoginTime release];
    [moodMessage release];
    
    [loveRole release];
    [loveType release];
    [smokeStatus release];
    [drinkStatus release];
    [marriageStatus release];
    [comeOutStatus release];
    [constellation release];
    [web release];
    [weibo release];
    [address release];
    [religion release];
    [provinceOfBirth release];
    [cityOfBirth release];
    [province release];
    [city release];
    [qq release];
    [msn release];
    [selfIntro release];
    [hobbies release];
    [profession release];
    
	[super dealloc];
}

- (NSString *)jsonString
{
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:[NSNumber numberWithInt:id] forKey:@"id"];
    [dictionary setObject:self.nickName forKey:@"nick_name"];
    [dictionary setObject:self.email forKey:@"email"];
    [dictionary setObject:self.avatar forKey:@"avatar"];
    [dictionary setObject:self.lastLoginTime forKey:@"last_login_time"];
    [dictionary setObject:self.moodMessage forKey:@"mood_message"];
    [dictionary setObject:[NSNumber numberWithInt:self.age] forKey:@"age"];
    [dictionary setObject:[NSNumber numberWithFloat:self.latitude] forKey:@"latitude"];
    [dictionary setObject:[NSNumber numberWithFloat:self.longitude] forKey:@"longitude"];
    
    [dictionary setObject:[NSNumber numberWithInt:self.loveRoleID] forKey:@"love_role_id"];
    [dictionary setObject:self.loveType forKey:@"love_type"];    
    [dictionary setObject:self.smokeStatus forKey:@"smoke_status"];    
    [dictionary setObject:self.drinkStatus forKey:@"drink_status"];    
    [dictionary setObject:self.marriageStatus forKey:@"marriage_status"];
    [dictionary setObject:self.comeOutStatus forKey:@"come_out_status"];
    [dictionary setObject:self.constellation forKey:@"constellation"];
    [dictionary setObject:self.web forKey:@"web"];
    [dictionary setObject:self.weibo forKey:@"weibo"];
    [dictionary setObject:self.address forKey:@"address"];
    [dictionary setObject:self.religion forKey:@"religion"];
    [dictionary setObject:self.provinceOfBirth forKey:@"province_of_birth"];
    [dictionary setObject:self.cityOfBirth forKey:@"city_of_birth"];
    [dictionary setObject:self.province forKey:@"province"];
    [dictionary setObject:self.city forKey:@"city"];
    [dictionary setObject:self.qq forKey:@"qq"];
    [dictionary setObject:self.msn forKey:@"msn"];
    [dictionary setObject:self.selfIntro forKey:@"selfIntro"];
    [dictionary setObject:self.hobbies forKey:@"hobbies"];
    [dictionary setObject:self.profession forKey:@"profession"];
    
    return [dictionary JSONString];
}

@end
