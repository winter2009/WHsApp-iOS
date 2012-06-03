//
//  VideoViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "VideoViewController.h"
#import "WebServiceManager.h"
#import "SubCategory.h"
#import "JSONKit.h"
#import "Utility.h"
#import "Video.h"
#import "YoutubeView.h"

#define TAG_TABLE_CELL_ELEMENT_VIDEO    101
#define TAG_TABLE_CELL_ELEMENT_TITLE    102
#define TAG_TABLE_CELL_ELEMENT_SUBTITLE 103

@interface VideoViewController ()

- (void)showLoadingView;
- (void)hideLoadingView;

- (void)getVideos;

@end

@implementation VideoViewController
@synthesize subCategory;
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
    
    m_webServiceManager = [[WebServiceManager alloc] init];
    m_videos = [[NSMutableArray alloc] init];
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
    
    [self getVideos];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_webServiceManager cancelRequests];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_videos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:self options:nil];
        cell = tableCell;
        tableCell = nil;
    }
    
    Video *video = [m_videos objectAtIndex:indexPath.row];
    
    YoutubeView *youtubeView = (YoutubeView *)[cell viewWithTag:TAG_TABLE_CELL_ELEMENT_VIDEO];
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:TAG_TABLE_CELL_ELEMENT_TITLE];
    UILabel *lblSubtitle = (UILabel *)[cell viewWithTag:TAG_TABLE_CELL_ELEMENT_SUBTITLE];
    
    NSLog(@"%@, frame:%@", video.urlString, NSStringFromCGRect(youtubeView.frame));
//    youtubeView = [[YoutubeView alloc] initWithStringAsURL:video.urlString frame:youtubeView.frame];
    [youtubeView setUrlString:video.urlString];
    lblTitle.text = video.title;
    lblSubtitle.text = [NSString stringWithFormat:@"Created: %@", video.createDate];
    
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
#pragma mark Private Methods
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

- (void)getVideos
{
    if ( self.subCategory != nil )
    {
        [m_webServiceManager getMediaForSubCategory:self.subCategory.id withDelegate:self];
        [self showLoadingView];
    }
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
                NSArray *videos = [response objectForKey:@"media"];
                for ( NSDictionary *videoDict in videos )
                {
                    Video *video = [[Video alloc] init];
                    video.id = [[videoDict objectForKey:@"id"] intValue];
                    video.title = [videoDict objectForKey:@"media_name"];
                    video.urlString = [videoDict objectForKey:@"media_url"];
                    video.createDate = [videoDict objectForKey:@"media_created"];
                    [m_videos addObject:video];
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
