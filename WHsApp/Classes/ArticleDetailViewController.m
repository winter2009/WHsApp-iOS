//
//  ArticleDetailViewController.m
//  WHsApp
//
//  Created by Zonghui Zhang on 3/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "Media.h"

@implementation ArticleDetailViewController
@synthesize lblTitle;
@synthesize lblCreatedOn;
@synthesize txtContent;
@synthesize article;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLblTitle:nil];
    [self setLblCreatedOn:nil];
    [self setTxtContent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.article != nil )
    {
        self.lblTitle.text = self.article.title;
        self.lblCreatedOn.text = [NSString stringWithFormat:@"Create On: %@", self.article.createDate];
        self.txtContent.text = self.article.description;
    }
    else
    {
        self.lblTitle.text = @"";
        self.lblCreatedOn.text = @"";
        self.txtContent.text = @"";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
