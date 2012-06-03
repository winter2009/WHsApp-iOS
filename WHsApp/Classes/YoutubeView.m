//
//  YoutubeView.m
//  TestYoutubeVideo
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import "YoutubeView.h"

@implementation YoutubeView

- (YoutubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame
{
    if (self = [super init]) 
    {
        // Create webview with requested frame size
        self = (YoutubeView *)[[UIWebView alloc] initWithFrame:frame];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
    }
    return self;  
}

- (void)setUrlString:(NSString *)urlString
{
    // HTML to embed YouTube video
    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, self.frame.size.width, self.frame.size.height];
    
    // Load the html into the webview
    [self loadHTMLString:html baseURL:nil];
}

@end
