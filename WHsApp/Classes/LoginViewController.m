//
//  LoginViewController.m
//  LaLa
//
//  Created by Zonghui Zhang on 27/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "UserRegistrationViewController.h"
#import "JSONKit.h"
#import "Utility.h"

@interface LoginViewController ()

- (void)startStandardUpdates;
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)loginSucceed;
- (void)showLoadingViewWithMessage:(NSString *)message;
- (void)hideLoadingView;
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification *)aNotification;
- (void)keyboardWillBeHidden:(NSNotification *)aNotification;

@end

@implementation LoginViewController
@synthesize loadingView;
@synthesize loadingIndicator;
@synthesize lblLoadingMessage;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize btnCheckbox;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_appDataManager = [AppDataManager sharedAppDataManager];
    m_webServiceManager = [[WebServiceManager alloc] init];
    m_isRememberPassword = NO;
}

- (void)viewDidUnload
{
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setBtnCheckbox:nil];
    [self setLoadingView:nil];
    [self setLoadingIndicator:nil];
    [self setLblLoadingMessage:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self registerForKeyboardNotifications];    
    [self startStandardUpdates];
    if ( m_appDataManager.isRememberPassword ) 
    {
        m_isRememberPassword = YES;
        [btnCheckbox setSelected:m_isRememberPassword];
        txtUsername.text = m_appDataManager.username;
        txtPassword.text = m_appDataManager.password;
//        [self loginWithUsername:m_appDataManager.username andPassword:m_appDataManager.password];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
    [m_webServiceManager cancelRequests];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark IB Actions
- (IBAction)btnCheckboxClicked:(id)sender 
{
    m_isRememberPassword = !m_isRememberPassword;
    [btnCheckbox setSelected:m_isRememberPassword];
}

- (IBAction)btnLoginClicked:(id)sender 
{
    if ( [txtUsername.text length] > 0 && [txtPassword.text length] > 0 ) 
    {
        [self loginWithUsername:txtUsername.text andPassword:txtPassword.text];
        
        // testing use only
//        [self loginSucceed];
    }
    else 
    {
        [Utility showAlertWithTitle:@"信息不完整" message:@"请填写邮箱和密码."];
    }
}

- (IBAction)btnRegisterClicked:(id)sender 
{
    UserRegistrationViewController *userRegistrationController = [[UserRegistrationViewController alloc] initWithNibName:@"UserRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:userRegistrationController animated:YES];
}

#pragma mark -
#pragma mark Private Methods
- (void)startStandardUpdates
{
    if ( nil == m_locationManager )
    {
        m_locationManager = [[CLLocationManager alloc] init];
    }
    
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    m_locationManager.distanceFilter = 500;
    [m_locationManager startUpdatingLocation];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [m_webServiceManager loginWithUsername:username password:password andDelegate:self];
    [self showLoadingViewWithMessage:@"登陆中..."];
}

- (void)loginSucceed
{
    [m_appDataManager loggedIn];
    [m_locationManager stopUpdatingLocation];
    
    if ( m_isRememberPassword )
    {
        [m_appDataManager rememberUsername:txtUsername.text password:txtPassword.text];
    }
    else 
    {
        [m_appDataManager clearUsernamePassword];
    }
    
    [self.delegate loginSucceed];
}

- (void)showLoadingViewWithMessage:(NSString *)message
{
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    [loadingIndicator startAnimating];
    [lblLoadingMessage setText:message];
}

- (void)hideLoadingView
{
    if ( [loadingView superview] != nil )
    {
        [loadingIndicator stopAnimating];
        [lblLoadingMessage setText:@""];
        [loadingView removeFromSuperview];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // if active text field is hidden by keyboard, scroll it so it is visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if ( !CGRectContainsPoint(aRect, CGPointMake(m_activeField.frame.origin.x, m_activeField.frame.origin.y + m_activeField.frame.size.height)) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, m_activeField.frame.origin.y - kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark -
#pragma mark ASIHttpRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    NSData *jsonData = [request responseData];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary *response = [decoder objectWithData:jsonData];
    NSLog(@"%@", response);
    
    if ( response )
    {
        if ( [response objectForKey:@"status"] != nil  )
        {
            NSString *status = [response objectForKey:@"status"];
            NSString *message = ( [response objectForKey:@"message"] == nil ) ? @"" : [response objectForKey:@"message"];
            
            if ( [status caseInsensitiveCompare:@"OK"] == NSOrderedSame ) 
            {
                NSDictionary *userDict = [response objectForKey:@"user"];
                User *user = [[User alloc] init];
                user.id = [[userDict objectForKey:@"id"] intValue];
                user.nickName = [userDict objectForKey:@"nick_name"];
                user.email = [userDict objectForKey:@"email"];                
                user.password = txtPassword.text;
                
                m_appDataManager.user = user;
                m_appDataManager.username = user.email;
                m_appDataManager.password = user.password;
                [self loginSucceed];
            }
            else if ( message != nil )
            {
                [Utility showAlertWithTitle:@"登陆失败" message:message];
            }
        }
        else 
        {
            [Utility showAlertWithTitle:@"错误" message:@"连接服务器失败，请重新尝试"];
        }
    }
    else 
    {
        [Utility showAlertWithTitle:@"错误" message:@"连接服务器失败，请重新尝试"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    [Utility showAlertWithTitle:@"错误" message:@"连接服务器失败，请检查你的网络连接并稍后再试。"];
}

#pragma mark -
#pragma mark UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_activeField = nil;
}

@end
