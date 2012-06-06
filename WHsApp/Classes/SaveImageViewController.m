//
//  SaveImageViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 7/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "SaveImageViewController.h"
#import "Utility.h"

@interface SaveImageViewController ()

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end

@implementation SaveImageViewController
@synthesize imageView;
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.imageView setImage:self.image];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnSaveClicked:(id)sender 
{
    // save image to disk
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)btnDiscardClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Private Method
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // return to kuso view controller if saved
    if ( error )
    {
        [Utility showAlertWithTitle:@"错误" message:@"无法保存图片到手机相册"];
    }
    else 
    {
        [Utility showAlertWithTitle:@"成功" message:@"成功保存图片到手机相册"];
    }    
}
@end
