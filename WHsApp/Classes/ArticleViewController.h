//
//  ArticleViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class WebServiceManager;
@class SubCategory;
@class ArticleDetailViewController;

@interface ArticleViewController : UITableViewController <ASIHTTPRequestDelegate>
{
    WebServiceManager   *m_webServiceManager;
    NSMutableArray      *m_articles;
    ArticleDetailViewController *m_articleDetailController;
}

@property (strong, nonatomic) SubCategory *subCategory;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
