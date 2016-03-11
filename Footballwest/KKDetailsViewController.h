//
//  KKDetailsViewController.h
//  tube
//
//  Created by Robert Ryan on 2/7/13.
//  Copyright (c) 2013 ikhlas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKDetailsViewController : UIViewController {
    UITextView *textView;
    UIWebView *videoView;
    UIImageView *imageView;
    CGRect textFrame;
    CGRect videoFrame;
    UIView *pView;
    UIView *lView;
}

@property (weak, nonatomic) NSDictionary *importVideoMetaData;

@property (weak, nonatomic) NSDictionary *importThumbnail;

@property (weak, nonatomic) NSString *importVideoID;

@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) UIImageView *imageView;

@end
