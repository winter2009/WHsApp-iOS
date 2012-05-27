//
//  LoginViewController.h
//  LaLa
//
//  Created by Zonghui Zhang on 27/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataManager.h"
#import "WebServiceManager.h"
#import "ASIHTTPRequest.h"
#import <CoreLocation/CoreLocation.h>

@protocol LoginDelegate <NSObject>

- (void)loginSucceed;

@end

@interface LoginViewController : UIViewController<ASIHTTPRequestDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    CLLocationManager   *m_locationManager;
    AppDataManager      *m_appDataManager;
    WebServiceManager   *m_webServiceManager;
    BOOL                m_isRememberPassword;
    UITextField         *m_activeField;
}

@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckbox;
@property (assign, nonatomic) id<LoginDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (retain, nonatomic) IBOutlet UILabel *lblLoadingMessage;

- (IBAction)btnCheckboxClicked:(id)sender;
- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnRegisterClicked:(id)sender;



@end
