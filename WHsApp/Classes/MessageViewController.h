//
//  MessageViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class WebServiceManager;
@class AppDataManager;

@interface MessageViewController : UITableViewController<ASIHTTPRequestDelegate>
{    
    AppDataManager          *m_appDataManager;
    WebServiceManager       *m_webServiceManager;
    IBOutlet UITableViewCell *tableCell;
    NSMutableArray          *m_messages;
}

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@end
