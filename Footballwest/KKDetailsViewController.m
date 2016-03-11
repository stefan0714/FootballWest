//
//  KKDetailsViewController.m
//  tube
//
//  Created by Robert Ryan on 2/7/13.
//  Copyright (c) 2013 ikhlas. All rights reserved.
//

#import "KKDetailsViewController.h"

#import "AFNetworking.h"


@interface KKDetailsViewController ()

@end

@implementation KKDetailsViewController

@synthesize importVideoID;
@synthesize textView = _textView;
@synthesize imageView = _imageView;


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

    //[self checkRotation];
    [self makePView];
        
}

#pragma mark Make Views
#pragma mark Portrait
-(void)makePView{
    //[lView removeFromSuperview];

    pView = [[UIView alloc] initWithFrame:self.view.bounds];

    if (IS_IPHONE_5) {
        textFrame = CGRectMake(0, 200, 320, 304);
    } else {
        textFrame = CGRectMake(0, 200, 320, 225);
    }
    
    _textView = [[UITextView alloc] initWithFrame:textFrame];
    _textView.editable = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    
    videoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, 320, 200)];
    videoView.backgroundColor = [UIColor clearColor];
    
    pView.userInteractionEnabled = YES;
    [self.view addSubview:_textView];
    [self.view addSubview:videoView];
    //[pView addSubview:_textView];
   // [pView addSubview:videoView];
   // [self.view addSubview:pView];
    [self viewVideo];

}


#pragma mark Landscape
-(void)makeLView{
    [pView removeFromSuperview];
    lView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    if (IS_IPHONE_5) {
        textFrame = CGRectMake(295, 0, 273, 276);
        videoFrame = CGRectMake(0, 51, 294, 174);
    } else {
        textFrame = CGRectMake(253, 0, 227, 276);
        videoFrame = CGRectMake(0, 51, 251, 174);
    }
    
    _textView = [[UITextView alloc] initWithFrame:textFrame];
    _textView.editable = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    
    videoView = [[UIWebView alloc] initWithFrame:videoFrame];
    videoView.backgroundColor = [UIColor clearColor];
    
    [lView addSubview:_textView];
    [lView addSubview:videoView];
    [self.view addSubview:lView];
    [self viewVideo];

}

-(void)viewVideo{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.title = @"Football West TV";
    self.textView.text = [self.importVideoMetaData objectForKey:@"description"];
    NSURL *url = [[NSURL alloc] initWithString:[self.importThumbnail objectForKey:@"hqDefault"]];
    [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fakeThumbnail.png"]];

    // BELOW LINES WILL RECEIVE VIDEO ID FROM PREVIOUS VIEW AND DISPLAY VIDEOS
    
    NSString *htmlString = @"<html><head>\
    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>\
    <body style=\"background:#000;margin-top:0px;margin-left:0px\">\
    <iframe id=\"ytplayer\" type=\"text/html\" width=\"320\" height=\"240\"\
    src=\"http://www.youtube.com/embed/%@?autoplay=1\"\
    frameborder=\"0\"/>\
    </body></html>";
    htmlString = [NSString stringWithFormat:htmlString, importVideoID, importVideoID];
    [videoView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark -
#pragma mark Orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)checkRotation{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

-(void)orientationChanged:(NSNotification *)object{
    UIDeviceOrientation deviceOr = [[object object] orientation];
    
    if (deviceOr == UIInterfaceOrientationPortrait) {
        //self.view = pView;

        [self makePView];

    }
    else if (deviceOr == UIInterfaceOrientationLandscapeLeft || deviceOr == UIInterfaceOrientationLandscapeRight) {
        //self.view = lView;

        [self makeLView];

    }
}
 */


@end
