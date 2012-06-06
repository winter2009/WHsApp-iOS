//
//  KusoViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 6/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveImageViewController;

@interface KusoViewController : UIViewController<UIScrollViewDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray  *m_templates;
    NSInteger       m_currentPageIndex;
    SaveImageViewController *m_saveImageController;
    UIImageView     *m_templateView;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnTakePhotoClicked:(id)sender;
@end
