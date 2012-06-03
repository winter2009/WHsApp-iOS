//
//  HomveViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubCategoryController;

@interface HomeViewController : UIViewController
{
    SubCategoryController   *m_subCategoryController;
}

- (IBAction)btnVideoClicked:(id)sender;
- (IBAction)btnAudioClicked:(id)sender;
- (IBAction)btnImageClicked:(id)sender;
- (IBAction)btnArticleClicked:(id)sender;
- (IBAction)btnMessageClicked:(id)sender;
- (IBAction)btnAboutUsClicked:(id)sender;


@end
