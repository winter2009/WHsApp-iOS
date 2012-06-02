//
//  UserRegistrationViewController.m
//  LaLa
//
//  Created by Zonghui Zhang on 27/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserRegistrationViewController.h"
#import "Utility.h"
#import "JSONKit.h"
#import "User.h"
#import "WebServiceManager.h"
#import "AppDataManager.h"
#import "AppDelegate.h"

@interface UserRegistrationViewController ()

- (void)registerSucceed;
- (void)showLoadingViewWithMessage:(NSString *)message;
- (void)hideLoadingView;

@end

@implementation UserRegistrationViewController
@synthesize lblLoadingMessage;
@synthesize txtNickname;
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize txtConfirmPassword;
@synthesize loadingView;
@synthesize loadingIndicator;


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
}

- (void)viewDidUnload
{
    [self setTxtNickname:nil];
    [self setTxtEmail:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [m_webServiceManager cancelRequests];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBActions
- (IBAction)btnRegisterClicked:(id)sender 
{
    if ( txtNickname.text != nil && [txtNickname.text length] > 0 && 
        txtEmail.text != nil && [txtEmail.text length] > 0 &&
        txtPassword != nil && [txtPassword.text length] > 0 &&
        txtConfirmPassword != nil && [txtConfirmPassword.text length] > 0
        ) 
    {
        if ( [txtPassword.text caseInsensitiveCompare:txtConfirmPassword.text] == NSOrderedSame )
        {
            [m_webServiceManager registerUserWithNickName:txtNickname.text email:txtEmail.text password:txtPassword.text andDelegate:self];
            [self showLoadingViewWithMessage:@"注册用户 ..."];
        }
        else 
        {
            [Utility showAlertWithTitle:@"密码不一致" message:@"两次输入的密码不一样，请重新填写。"];
        }
    }
    else 
    {
        [Utility showAlertWithTitle:@"信息不完整" message:@"请确保所有信息均已填写。"];
    }
}

- (IBAction)btnCancelClicked:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark -
#pragma mark Private Methods
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

- (void)registerSucceed
{
    [m_appDataManager loggedIn];    
    [m_appDataManager rememberUsername:txtEmail.text password:txtPassword.text];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate loginSucceed];
}

#pragma mark -
#pragma mark ASIHttpRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    NSData *jsonData = [request responseData];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary *response = [decoder objectWithData:jsonData];
//    NSLog(@"%@", response);
    
    if ( response )
    {
        if ( [response objectForKey:@"status"] != nil )
        {
            NSString *status = [response objectForKey:@"status"];
            NSString *message = ( [response objectForKey:@"message"] == nil ) ? @"" : [response objectForKey:@"message"];
            
            if ( [status caseInsensitiveCompare:@"OK"] == NSOrderedSame ) 
            {
                NSDictionary *userDict = [response objectForKey:@"user"];
                User *user = [[User alloc] init];
                user.id = [[userDict objectForKey:@"id"] intValue];
                user.nickName = txtNickname.text;
                user.email = txtEmail.text;
                user.password = txtPassword.text;
                
                m_appDataManager.user = user;
                [self registerSucceed];
            }
            else if ( message != nil )
            {
                [Utility showAlertWithTitle:@"注册失败" message:message];
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


@end
