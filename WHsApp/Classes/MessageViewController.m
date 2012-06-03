//
//  MessageViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "MessageViewController.h"
#import "WebServiceManager.h"
#import "AppDataManager.h"
#import "JSONKit.h"
#import "Utility.h"

@interface MessageViewController ()

- (void)showLoadingView;
- (void)hideLoadingView;

- (void)getMessages;

@end

@implementation MessageViewController
@synthesize loadingView;
@synthesize loadingIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息中心";
    
    m_webServiceManager = [[WebServiceManager alloc] init];
    m_appDataManager = [AppDataManager sharedAppDataManager];
}

- (void)viewDidUnload
{
    tableCell = nil;
    [self setLoadingView:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getMessages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark Pivate Methods
- (void)showLoadingView
{
    loadingView.frame = CGRectMake(self.view.frame.size.width / 2.0 - loadingView.frame.size.width / 2.0, 
                                   self.view.frame.size.height / 2.0 - loadingView.frame.size.height / 2.0,
                                   loadingView.frame.size.width, loadingView.frame.size.height);
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    [loadingIndicator startAnimating];
}

- (void)hideLoadingView
{
    if ( [loadingView superview] != nil )
    {
        [loadingIndicator stopAnimating];
        [loadingView removeFromSuperview];
    }
}

- (void)getMessages
{
    // TODO: get messages
    [m_webServiceManager getMessagesForUser:m_appDataManager.user.id withDelegate:self];
    [self showLoadingView];
}

#pragma mark -
#pragma mark ASIHttpRequest
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
                [m_messages removeAllObjects];
                NSArray *messages = [response objectForKey:@"messages"];
                for ( NSDictionary *messageDict in messages )
                {
                    // TODO: add message to array
                }
                
                [self.tableView reloadData];
            }
            else if ( message != nil )
            {
                [Utility showAlertWithTitle:@"获取分类失败" message:message];
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

@end
