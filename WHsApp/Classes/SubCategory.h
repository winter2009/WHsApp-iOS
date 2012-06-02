//
//  SubCategory.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategory : NSObject

@property (nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (nonatomic) NSInteger categoryID;
@property (strong, nonatomic) NSString *category;

@end
