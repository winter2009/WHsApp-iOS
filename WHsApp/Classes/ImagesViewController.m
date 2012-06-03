//
//  ImagesViewController.m
//  SingEat
//
//  Created by Zonghui Zhang on 5/20/11.
//  Copyright 2011 PhoneSoul. All rights reserved.
//

#import "ImagesViewController.h"
#import "WebServiceManager.h"
#import "SubCategory.h"
#import "Media.h"
#import "JSONKit.h"
#import "Utility.h"
#import "KTPhotoView+SDWebImage.h"
#import "KTThumbView+SDWebImage.h"

@interface ImagesViewController ()

- (void)getImages;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end

@implementation ImagesViewController
@synthesize subCategory;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_webServiceManager = [[WebServiceManager alloc] init];
    m_photos = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.subCategory != nil )
    {
        self.title = self.subCategory.name;
    }
    [self getImages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willLoadThumbs 
{
    [self showActivityIndicator];
}

- (void)didLoadThumbs 
{
    [self hideActivityIndicator];
}

#pragma mark -
#pragma mark Activity Indicator

- (UIActivityIndicatorView *)activityIndicator 
{
    if (activityIndicatorView_) {
        return activityIndicatorView_;
    }
    
    activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint center = [[self view] center];
    [activityIndicatorView_ setCenter:center];
    [activityIndicatorView_ setHidesWhenStopped:YES];
    [activityIndicatorView_ startAnimating];
    [[self view] addSubview:activityIndicatorView_];
    
    return activityIndicatorView_;
}

- (void)showActivityIndicator 
{
    [[self activityIndicator] startAnimating];
}

- (void)hideActivityIndicator 
{
    [[self activityIndicator] stopAnimating];
}

#pragma mark -
#pragma mark Private Methods
- (void)getImages
{
    if ( self.subCategory != nil )
    {
        [m_webServiceManager getMediaForSubCategory:self.subCategory.id withDelegate:self];
    }
}

#pragma mark -
#pragma mark ASIHttpRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
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
                NSArray *images = [response objectForKey:@"media"];
                for ( NSDictionary *imageDict in images )
                {
                    Media *photo = [[Media alloc] init];
                    photo.id = [[imageDict objectForKey:@"id"] intValue];
                    photo.title = [imageDict objectForKey:@"media_name"];
                    photo.urlString = [imageDict objectForKey:@"media_url"];
                    photo.createDate = [imageDict objectForKey:@"media_created"];
                    [m_photos addObject:photo];
                }
                
                self.dataSource = self;
            }
            else if ( message != nil )
            {
                [Utility showAlertWithTitle:@"获取图片失败" message:message];
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
    [Utility showAlertWithTitle:@"错误" message:@"连接服务器失败，请检查你的网络连接并稍后再试。"];
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos 
{
    NSInteger count = [m_photos count];
    return count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView 
{
    Media *image = [m_photos objectAtIndex:index];
    [photoView setImageWithURL:[NSURL URLWithString:image.urlString] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView 
{
    Media *image = [m_photos objectAtIndex:index];
    [thumbView setImageWithURL:[NSURL URLWithString:image.urlString] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

@end
