//
//  KusoViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 6/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "KusoViewController.h"
#import "SaveImageViewController.h"

#define TEMPLATE_IMAGE_WIDTH    160
#define TEMPLATE_IMAGE_HEIGHT   240
#define TEMPLATE_IMAGE_SPACE    80
#define SCROLL_VIEW_MARGIN_LEFT 80
#define SCROLL_VIEW_MARGIN_TOP  10


@interface KusoViewController ()

- (void)setupView;
- (UIImage *)mergeImage:(UIImage *)first withImage:(UIImage *)second;

@end

@implementation KusoViewController
@synthesize pageControl;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    m_templates = [[NSMutableArray alloc] init];
    [m_templates addObject:[UIImage imageNamed:@"template2.png"]];
    [m_templates addObject:[UIImage imageNamed:@"template3.png"]];
    [self setupView];
    
    m_saveImageController = [[SaveImageViewController alloc] initWithNibName:@"SaveImageViewController" bundle:nil];
    m_templateView = [[UIImageView alloc] init];
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Kuso 合照";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:178.0/255.0 green:168.0/255.0 blue:127.0/255.0 alpha:1.0]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Scroll View Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)tScrollView
{
    CGPoint contentOffset = tScrollView.contentOffset;
    m_currentPageIndex = ( contentOffset.x ) / (TEMPLATE_IMAGE_SPACE + TEMPLATE_IMAGE_WIDTH);
    NSLog(@"%f, %d", contentOffset.x, m_currentPageIndex);
    self.pageControl.currentPage = m_currentPageIndex;
}

#pragma mark -
#pragma mark IBActions
- (IBAction)btnTakePhotoClicked:(id)sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;    
    
    [m_templateView setImage:[m_templates objectAtIndex:m_currentPageIndex]];
    m_templateView.frame = imagePicker.view.frame;
    m_templateView.contentMode = UIViewContentModeScaleToFill;
    
    [imagePicker.cameraOverlayView addSubview:m_templateView];
    [imagePicker.cameraOverlayView bringSubviewToFront:m_templateView];

    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark -
#pragma mark Private Methods
- (void)setupView
{
    // 1. add imageviews to scroll view
    for ( NSInteger i = 0; i < m_templates.count; i++  )
    {
        UIImage *image = [m_templates objectAtIndex:i];
        UIImageView *templateView = [[UIImageView alloc] initWithImage:image];
        templateView.frame = CGRectMake(SCROLL_VIEW_MARGIN_LEFT + i * ( TEMPLATE_IMAGE_WIDTH + TEMPLATE_IMAGE_SPACE ), SCROLL_VIEW_MARGIN_TOP, TEMPLATE_IMAGE_WIDTH, TEMPLATE_IMAGE_HEIGHT);
        templateView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:templateView];
    }
    
    // 2. set scroll view init position, content size, init pagecontrol
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    NSInteger numberImages = m_templates.count;
    [self.scrollView setContentSize:CGSizeMake(SCROLL_VIEW_MARGIN_LEFT * 2 + numberImages * TEMPLATE_IMAGE_WIDTH + ( numberImages - 1 ) * TEMPLATE_IMAGE_SPACE  , self.scrollView.frame.size.height)];
    self.pageControl.numberOfPages = m_templates.count;
    self.pageControl.currentPage = 0;
    
    m_currentPageIndex = 0;
}

- (UIImage *)mergeImage:(UIImage *)first withImage:(UIImage *)second
{
//    CGImageRef firstImageRef = first.CGImage;
//    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
//    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
//    CGImageRef secondImageRef = second.CGImage;
//    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
//    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    CGSize mergedSize = CGSizeMake(640, 960);
    
    UIGraphicsBeginImageContext(mergedSize);
    
    [first drawInRect:CGRectMake(0, 0, 640, 960)];
    [second drawInRect:CGRectMake(0, 0, 640, 960)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark -
#pragma mark UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{        
    // 1. combine 2 images
    UIImage *combinedImage = [self mergeImage:image withImage:[m_templates objectAtIndex:m_currentPageIndex]];
    m_saveImageController.image = combinedImage;
    
    // 2. navigate to save image controller
    [self.navigationController pushViewController:m_saveImageController animated:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
