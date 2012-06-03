//
//  HomveViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "HomeViewController.h"
#import "SubCategoryController.h"
#import "AboutUsViewController.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"WHsApp";
    
    // Do any additional setup after loading the view from its nib.
    m_subCategoryController = [[SubCategoryController alloc] initWithNibName:@"SubCategoryController" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBActions
- (IBAction)btnVideoClicked:(id)sender
{
    m_subCategoryController.category = @"video";
    [self.navigationController pushViewController:m_subCategoryController animated:YES];
}

- (IBAction)btnAudioClicked:(id)sender 
{
    m_subCategoryController.category = @"audio";
    [self.navigationController pushViewController:m_subCategoryController animated:YES];
}

- (IBAction)btnImageClicked:(id)sender 
{
    m_subCategoryController.category = @"image";
    [self.navigationController pushViewController:m_subCategoryController animated:YES];
}

- (IBAction)btnArticleClicked:(id)sender 
{
    m_subCategoryController.category = @"article";
    [self.navigationController pushViewController:m_subCategoryController animated:YES];
}

- (IBAction)btnMessageClicked:(id)sender 
{
    if ([MFMailComposeViewController canSendMail]) 
    {        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"admin@whsapp.com"]];
        [mailViewController setSubject:@"Feedback for iPhone app."];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        [self presentModalViewController:mailViewController animated:YES];        
    }    
    else 
    {        
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (IBAction)btnAboutUsClicked:(id)sender 
{
    m_aboutUsController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:m_aboutUsController animated:YES];
}

#pragma mark -
#pragma mark MailCompose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
