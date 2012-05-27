//
//  Utility.h
//  LaLa
//
//  Created by Zonghui Zhang on 26/1/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// alerts
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

@end
