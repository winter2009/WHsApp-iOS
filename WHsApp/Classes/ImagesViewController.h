//
//  ImagesViewController.h
//  SingEat
//
//  Created by Zonghui Zhang on 5/20/11.
//  Copyright 2011 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"
#import "ASIHTTPRequest.h"

@class SubCategory;
@class WebServiceManager;
@interface ImagesViewController : KTThumbsViewController <ASIHTTPRequestDelegate, KTPhotoBrowserDataSource>
{
    NSMutableArray  *m_photos;
    WebServiceManager   *m_webServiceManager;
    
    UIActivityIndicatorView *activityIndicatorView_;
    UIWindow *window_;
}

@property (strong, nonatomic) SubCategory *subCategory;


@end
