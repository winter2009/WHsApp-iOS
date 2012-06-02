//
//  VideoViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class WebServiceManager;
@class SubCategory;

@interface VideoViewController : UITableViewController<ASIHTTPRequestDelegate>
{   
    IBOutlet UITableViewCell *tableCell;
    WebServiceManager   *m_webServiceManager;
    NSMutableArray      *m_videos;
}

@property (strong, nonatomic) SubCategory *subCategory;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
