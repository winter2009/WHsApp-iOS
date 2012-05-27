//
//  User.h
//  LaLa
//
//  Created by Zonghui Zhang on 11/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSDate *lastLoginTime;
@property (nonatomic, retain) NSString *moodMessage;

@property (nonatomic, retain) NSString *loveRole;
@property (nonatomic) NSInteger loveRoleID;

@property (nonatomic, retain) NSString *loveType;

@property (nonatomic, retain) NSString *smokeStatus;
@property (nonatomic, retain) NSString *drinkStatus;
@property (nonatomic, retain) NSString *marriageStatus;
@property (nonatomic, retain) NSString *comeOutStatus;
@property (nonatomic, retain) NSString *constellation;
@property (nonatomic, retain) NSString *web;
@property (nonatomic, retain) NSString *weibo;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *religion;
@property (nonatomic, retain) NSString *provinceOfBirth;
@property (nonatomic, retain) NSString *cityOfBirth;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *qq;
@property (nonatomic, retain) NSString *msn;
@property (nonatomic, retain) NSString *selfIntro;
@property (nonatomic, retain) NSString *hobbies;
@property (nonatomic, retain) NSString *profession;

@property (nonatomic) NSInteger age;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;



- (NSString *)jsonString;

@end
