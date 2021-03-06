//
//  HomveViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class SubCategoryController;
@class AboutUsViewController;
@class KusoViewController;

@interface HomeViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    SubCategoryController   *m_subCategoryController;
    AboutUsViewController   *m_aboutUsController;
    KusoViewController      *m_kusoController;
}

- (IBAction)btnVideoClicked:(id)sender;
- (IBAction)btnAudioClicked:(id)sender;
- (IBAction)btnImageClicked:(id)sender;
- (IBAction)btnArticleClicked:(id)sender;
- (IBAction)btnMessageClicked:(id)sender;
- (IBAction)btnAboutUsClicked:(id)sender;
- (IBAction)btnKusoClicked:(id)sender;


@end
