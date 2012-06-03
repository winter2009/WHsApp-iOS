//
//  YoutubeView.h
//  TestYoutubeVideo
//
//  Created by Zonghui Zhang on 1/6/12.
//  Copyright (c) 2012 PhoneSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeView : UIWebView


- (YoutubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
- (void)setUrlString:(NSString *)urlString;

@end
