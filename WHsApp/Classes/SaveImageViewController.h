//
//  SaveImageViewController.h
//  WHsApp
//
//  Created by Zonghui Zhang on 7/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) UIImage *image;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnDiscardClicked:(id)sender;

@end
