//
//  ArticleViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "ArticleViewController.h"
#import "WebServiceManager.h"
#import "SubCategory.h"
#import "JSONKit.h"
#import "Utility.h"
#import "Media.h"
#import "ArticleDetailViewController.h"

@interface ArticleViewController ()

- (void)showLoadingView;
- (void)hideLoadingView;

- (void)getArticles;

@end

@implementation ArticleViewController
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
    m_articles = [[NSMutableArray alloc] init];
    m_articleDetailController = [[ArticleDetailViewController alloc] initWithNibName:@"ArticleDetailViewController" bundle:nil];
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
    
    if ( self.subCategory != nil )
    {
        self.title = self.subCategory.name;
    }
    [self getArticles];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Media *article = [m_articles objectAtIndex:indexPath.row];
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created on: %@", article.createDate];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *article = [m_articles objectAtIndex:indexPath.row];
    m_articleDetailController.article = article;
    [self.navigationController pushViewController:m_articleDetailController animated:YES];
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

- (void)getArticles
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
                NSArray *articles = [response objectForKey:@"media"];
                for ( NSDictionary *articleDict in articles )
                {
                    Media *article = [[Media alloc] init];
                    article.id = [[articleDict objectForKey:@"id"] intValue];
                    article.title = [articleDict objectForKey:@"media_name"];
                    article.urlString = [articleDict objectForKey:@"media_url"];
                    article.createDate = [articleDict objectForKey:@"media_created"];
                    article.description = [articleDict objectForKey:@"media_description"];
                    [m_articles addObject:article];
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
