//
//  NewsBrowserController.h
//  Football West
//
//  Created by Adrian Jurcevic on 1/04/2014.
//  Copyright (c) 2014 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyApplication.h"
#import "PaperFoldSwipeHintView.h"

// The names of the images for the 'back' and 'forward' buttons in the toolbar.
#define PNG_BUTTON_FORWARD @"right.png"
#define PNG_BUTTON_BACK @"left.png"

// List of all strings used
#define ACTION_CANCEL           @"Cancel"
#define ACTION_OPEN_IN_SAFARI   @"Open in Safari"

@interface NewsBrowserController : UIViewController
<
UIWebViewDelegate,
UIActionSheetDelegate
>
{
    // the current URL of the UIWebView
    NSURL *url;
    
    // the UIWebView where we render the contents of the URL
    IBOutlet UIWebView *webView;
    
    // the UIToolbar with the "back" "forward" "reload" and "action" buttons
    IBOutlet UIToolbar *toolbar;
    
    // used to indicate that we are downloading content from the web
    UIActivityIndicatorView *activityIndicator;
    
    // pointers to the buttons on the toolbar
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIBarButtonItem *stopButton;
    UIBarButtonItem *reloadButton;
    UIBarButtonItem *actionButton;
}

@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) UIToolbar *toolbar;
@property(nonatomic, retain) UIBarButtonItem *backButton;
@property(nonatomic, retain) UIBarButtonItem *forwardButton;
@property(nonatomic, retain) UIBarButtonItem *stopButton;
@property(nonatomic, retain) UIBarButtonItem *reloadButton;
@property(nonatomic, retain) UIBarButtonItem *actionButton;

@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

// Initializes the BrowserViewController with a specific URL
- (id)initWithUrls:(NSURL*)u;

@end
