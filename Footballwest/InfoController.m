//
//  InfoController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 27/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "InfoController.h"
#import "LegalViewController.h"
#import "CLTickerView.h"

@interface InfoController ()
{
    CGRect frame;
}

@end

@implementation InfoController
//@synthesize mv;
@synthesize ps;

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    //self.view.bounds = CGRectMake(120, 0, 320, 748);
    
    [self setupButtons];
    [self setupTextView];
    [self setupAutoScroll];
       
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-landscape.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(slider)];
}

-(void)slider{
    ps = [[PaperFoldSwipeHintView alloc] initWithPaperFoldSwipeHintViewMode:PaperFoldSwipeHintViewModeSwipeRight];
    [ps showInView:self.view];
    
    [self performSelector:@selector(timerCallback) withObject:nil afterDelay:1.5];
}

-(void)timerCallback{
    [ps removeFromSuperview];
    [ps hide];
}


-(void)setupAutoScroll{
    if (IS_IPHONE_5) {
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        viewFrame = CGRectMake(0, 483, 320, 22);
        }else {
        viewFrame = CGRectMake(0, 548, 320, 22);
        }
    }
    else{
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        viewFrame = CGRectMake(0, 394, 320, 22);
        }else{
        viewFrame = CGRectMake(0, 453, 320, 22);
        }
    }
    
    CLTickerView *ticker = [[CLTickerView alloc] initWithFrame:viewFrame];
    ticker.marqueeStr = @"Would you like a mobile app for your club? click here to email or visit http://www.retailweb.com.au";
    ticker.marqueeFont = [UIFont systemFontOfSize:16];
    ticker.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:ticker];
    
    //Advert Retailweb
    UIButton *rwButton = [[UIButton alloc] initWithFrame:viewFrame];
    rwButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rwButton];
    [rwButton addTarget:self action:@selector(retailwebAdvert) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupButtons{
    if (IS_IPHONE_5) {
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        buttonFrame1 = CGRectMake(25, 146, 270, 44);
        buttonFrame2 = CGRectMake(25, 216, 270, 44);
        buttonFrame3 = CGRectMake(25, 286, 270, 44);
        buttonFrame4 = CGRectMake(25, 356, 270, 44);
        }
        else{
        buttonFrame1 = CGRectMake(25, 211, 270, 44);
        buttonFrame2 = CGRectMake(25, 281, 270, 44);
        buttonFrame3 = CGRectMake(25, 351, 270, 44);
        buttonFrame4 = CGRectMake(25, 421, 270, 44);
        }
    }
    else{
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        buttonFrame1 = CGRectMake(25, 150, 270, 44);
        buttonFrame2 = CGRectMake(25, 210, 270, 44);
        buttonFrame3 = CGRectMake(25, 270, 270, 44);
        buttonFrame4 = CGRectMake(25, 330, 270, 44);
        }
        else{
        buttonFrame1 = CGRectMake(25, 215, 270, 44);
        buttonFrame2 = CGRectMake(25, 275, 270, 44);
        buttonFrame3 = CGRectMake(25, 335, 270, 44);
        buttonFrame4 = CGRectMake(25, 395, 270, 44);
        }
    }
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:buttonFrame1];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:buttonFrame2];
    UIButton *feedbackButton = [[UIButton alloc] initWithFrame:buttonFrame3];
    UIButton *termButton = [[UIButton alloc] initWithFrame:buttonFrame4];
    
    contactButton.backgroundColor = [UIColor darkGrayColor];
    shareButton.backgroundColor = [UIColor darkGrayColor];
    feedbackButton.backgroundColor = [UIColor darkGrayColor];
    termButton.backgroundColor = [UIColor darkGrayColor];
    
    UIImage *img = [UIImage imageNamed:@"about1.png"];
    
    [contactButton setImage:img forState:UIControlStateNormal];
    [shareButton setImage:img forState:UIControlStateNormal];
    [feedbackButton setImage:img forState:UIControlStateNormal];
    [termButton setImage:img forState:UIControlStateNormal];
    
    
    if (IS_IPHONE_5) {
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        buttonText1 = CGRectMake(120, 157, 159, 21);
        buttonText2 = CGRectMake(120, 227, 165, 21);
        buttonText3 = CGRectMake(120, 297, 120, 21);
        buttonText4 = CGRectMake(120, 367, 100, 21);
        }
        else{
        buttonText1 = CGRectMake(120, 222, 159, 21);
        buttonText2 = CGRectMake(120, 292, 165, 21);
        buttonText3 = CGRectMake(120, 362, 120, 21);
        buttonText4 = CGRectMake(120, 432, 100, 21);
        }
    }
    else{
        if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
        buttonText1 = CGRectMake(120, 161, 159, 21);
        buttonText2 = CGRectMake(120, 221, 165, 21);
        buttonText3 = CGRectMake(120, 281, 120, 21);
        buttonText4 = CGRectMake(120, 341, 100, 21);
        }
        else{
        buttonText1 = CGRectMake(120, 226, 159, 21);
        buttonText2 = CGRectMake(120, 286, 165, 21);
        buttonText3 = CGRectMake(120, 346, 120, 21);
        buttonText4 = CGRectMake(120, 406, 100, 21);
        }
    }
    
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:buttonText1];
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:buttonText2];
    UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:buttonText3];
    UILabel *termLabel = [[UILabel alloc] initWithFrame:buttonText4];
    
    contactLabel.textColor = [UIColor whiteColor];
    shareLabel.textColor = [UIColor whiteColor];
    feedbackLabel.textColor = [UIColor whiteColor];
    termLabel.textColor = [UIColor whiteColor];
    
    contactLabel.backgroundColor = [UIColor clearColor];
    shareLabel.backgroundColor = [UIColor clearColor];
    feedbackLabel.backgroundColor = [UIColor clearColor];
    termLabel.backgroundColor = [UIColor clearColor];
    
    contactLabel.font = [UIFont systemFontOfSize:14];
    shareLabel.font = [UIFont systemFontOfSize:14];
    feedbackLabel.font = [UIFont systemFontOfSize:14];
    termLabel.font = [UIFont systemFontOfSize:14];
    
    contactLabel.text = @"Contact Football West";
    shareLabel.text = @"Share this Application";
    feedbackLabel.text = @"Send Feedback";
    termLabel.text = @"Terms of Use";
    
    if (IS_IPOD) {
        [self.view addSubview:shareLabel];
        [self.view addSubview:feedbackLabel];
        [self.view addSubview:termLabel];
        [self.view addSubview:shareButton];
        [self.view addSubview:feedbackButton];
        [self.view addSubview:termButton];
    }
    else{
        [self.view addSubview:contactButton];
        [self.view addSubview:shareButton];
        [self.view addSubview:feedbackButton];
        [self.view addSubview:termButton];
        [self.view addSubview:contactLabel];
        [self.view addSubview:shareLabel];
        [self.view addSubview:feedbackLabel];
        [self.view addSubview:termLabel];
    }
    
    [contactButton addTarget:self action:@selector(callButton) forControlEvents:UIControlEventTouchUpInside];
    [shareButton addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    [feedbackButton addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [termButton addTarget:self action:@selector(legalButton) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setupTextView{
    if (SYSTEM_VERSION_LESS_THAN (@"7.0")) {
    frame = CGRectMake(0, 0, 320, 138);
    }else{
    frame = CGRectMake(0, 65, 320, 138);
    }
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.text = @"Football West was established in July 2004 to represent the combined interests of all levels of competition and aspects of the game throughout metropolitan and regional Western Australia (WA).\nFootball will become a leading sport in Western Australia.";
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
}


-(void)legalButton{
    LegalViewController * lc = [[LegalViewController alloc] init];
    lc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	//[self presentModalViewController:lc animated:YES];
    [self presentViewController:lc animated:YES completion:nil];
}

-(void)callButton{
    UIAlertView *c = [[UIAlertView alloc] initWithTitle:@"Contact Football West \n (08) 9422 6900" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Call", nil];
    c.delegate = self;
    [c show];
    
}

-(void)retailwebAdvert{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"MyClubs App"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"publish@retailweb.com.au", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"Hi, \nI want an app for my club.";
        [mailer setMessageBody:emailBody isHTML:YES];
        //[self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


-(void)shareApp{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"FootballWest Application"];
        [mailer setToRecipients:nil];
        NSString *emailBody = @"Hey, \n check out this app on the AppStore: http://itunes.apple.com/au/app/football-west/id431613080?mt=8";
        [mailer setMessageBody:emailBody isHTML:YES];
        //[self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)sendMail{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Feedback: FootballWest App"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"support@retailweb.com.au", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"Hi Developers, \n\n";
        [mailer setMessageBody:emailBody isHTML:YES];
        //[self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

//UIAlertview for calling Football west
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+61894226900"]];
        default:
            break;
    }
}

//EMAIL
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
