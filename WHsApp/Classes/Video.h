//
//  Video.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *createDate;

@end
