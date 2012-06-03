//
//  ArticleDetailViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;
@interface ArticleDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatedOn;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (strong, nonatomic) Media *article;

@end
