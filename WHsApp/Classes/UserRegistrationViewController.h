//
//  UserRegistrationViewController.h
//  LaLa
//
//  Created by Zonghui Zhang on 27/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class AppDataManager;
@class WebServiceManager;

@interface UserRegistrationViewController : UIViewController <UITextFieldDelegate, ASIHTTPRequestDelegate>
{
    AppDataManager          *m_appDataManager;
    WebServiceManager       *m_webServiceManager;
}

@property (retain, nonatomic) IBOutlet UITextField *txtNickname;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (retain, nonatomic) IBOutlet UILabel *lblLoadingMessage;

- (IBAction)btnRegisterClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
