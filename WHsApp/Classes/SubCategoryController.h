//
//  SubCategoryController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class WebServiceManager;

@interface SubCategoryController : UITableViewController<ASIHTTPRequestDelegate>
{
    WebServiceManager   *m_webServiceManager;
    NSMutableArray      *m_subCategories;
}

@property (nonatomic, strong) NSString *category;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
