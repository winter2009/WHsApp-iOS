//
//  SubCategoryController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "SubCategoryController.h"
#import "WebServiceManager.h"
#import "JSONKit.h"
#import "Utility.h"
#import "SubCategory.h"
#import "VideoViewController.h"

@interface SubCategoryController ()

- (void)showLoadingView;
- (void)hideLoadingView;

- (void)getSubCategories;

@end

@implementation SubCategoryController
@synthesize category;
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
    m_subCategories = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [self setLoadingView:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getSubCategories];
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
    return [m_subCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SubCategory *subCategory = [m_subCategories objectAtIndex:indexPath.row];
    cell.textLabel.text = subCategory.name;
    cell.detailTextLabel.text = subCategory.description;
    NSLog(@"%@", subCategory.name);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.category caseInsensitiveCompare:@"video"] == NSOrderedSame )
    {
        VideoViewController *videoController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
        videoController.subCategory = (SubCategory *)[m_subCategories objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:videoController animated:YES];
    }
    else if ( [self.category caseInsensitiveCompare:@"audio"] == NSOrderedSame )
    {
        // TODO: handle audios
    }
    else if ( [self.category caseInsensitiveCompare:@"image"] == NSOrderedSame )
    {
        // TODO: handle images
    }
    else if ( [self.category caseInsensitiveCompare:@"article"] == NSOrderedSame )
    {
        // TODO: handle articles
    }
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

- (void)getSubCategories
{
    if ( self.category != nil && self.category.length > 0 ) 
    {
        [m_webServiceManager getSubCategoriesForCategory:self.category withDelegate:self];
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
                [m_subCategories removeAllObjects];
                NSArray *subCategories = [response objectForKey:@"sub_categories"];
                for ( NSDictionary *subCategory in subCategories )
                {
                    SubCategory *sub = [[SubCategory alloc] init];
                    sub.id = [[subCategory objectForKey:@"id"] intValue];
                    sub.name = [subCategory objectForKey:@"sub_category_name"];
                    sub.description = [subCategory objectForKey:@"sub_category_description"];
                    sub.category = self.category;
                    sub.categoryID = [[subCategory objectForKey:@"parent_id"] intValue];
                    [m_subCategories addObject:sub];
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
