//
//  LegalViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 27/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "LegalViewController.h"
#define LEGALTEXT @"Terms of Use Policy\nDisclaimer\n\nRetailweb does not warrant, guarantee or make any representations as to the content or suitability of the information on this application (or any application or site linked to this application) for any purpose.\nRetailweb will not be liable for any claims or damages whatsoever resulting from use or reliance on information in this application.\nWe are committed to the protection of the privacy of our customers. This Privacy Policy is subject always to the requirements of the Privacy Act 1988 (Act). The purpose of this Privacy Policy is to set out the collection, use and disclosure practices of Retailweb in relation to personal information.\nThis Privacy Policy works together with any documents or information provided to you from time to time, such as the terms of use governing our application, tax invoices and other material.\n\nPersonal Information\nYour personal information is any information or opinion about you from which your identity is apparent or can reasonably be ascertained (Personal Information).\n\nAggregated Data\nAggregated data is information that relates purely to generic statistics such as demographics and traffic flow with our application, and which does not personally identify you. Aggregated data allows us to better provide our services to you. We may provide this data to third parties.\n\nCollection of Personal Information\nWhen you use any of our services you may provide us with information which, when collected alone or together with other information, constitutes Personal Information. We will collect personal information only in ways that are not prohibited by the Act. We will not collect personal information unless:\n(a) the collection is lawful; and\n(b) you are made aware of such collection.\nIf you wish to enter our competitions or register to receive updates, promotions or benefits available on our application, you will need to provide us with personal information by filling in an application form. You may unsubscribe from any of these services at any time by emailing unsubscribe@retailweb.com.au.\n\nUse of Personal Information\nWe only collect, store, use or disclose your Personal Information:\n(a) in a manner consistent with the primary purpose of its collection or for other purposes related to that primary purpose where you would reasonably expect your personal information to be used or disclosed for that other purpose;\n(b) if required or permitted by law or by a relevant regulatory authority;\n(c) to protect and defend our legal rights and to enforce our user, advertiser and other agreements;\n(d) with your consent; or\n(e) as otherwise permitted by the Act.\n\nDisclosure of Personal Information\nWe may disclose your Personal Information to:\n(a) related bodies corporate of Retailweb;\n(b) external service providers engaged by Retailweb (on a confidential basis and on the condition that their use will be limited in their use of the information to the purpose of Retailweb’s business only);\n(c) any other person authorised, implicitly or expressly, when the personal information is provided to or collected by Retailweb; and\n(d) third parties for purposes notified by us to you from time to time.\n\nAccess to and correction of Personal Information\nGenerally, you have a right of access to your Personal Information held by us. We will take reasonable steps to ensure that Personal Information we collect and store is accurate, complete and up-to-date and to correct any inaccurate personal information. We will process requests for access and correction within a reasonable time and may charge a fee to cover the costs of verifying the application and retrieving the information requested.\n\nSensitive Personal Information;\nRetailweb does not generally collect any sensitive information (such as information relating to racial or ethnic origin, membership of political bodies, religion or trade unions, sexual preferences, criminal record, state of health or medical history). If we ask for sensitive information, we will explain the request and will only use and disclose such information for the purpose that which it was provided.\n\nSecurity of Personal Information\nWe will take all reasonable steps to protect your Personal Information from misuse. If, despite taking reasonable steps, we are unable to protect your personal information from misuse then, to the extent permitted by law, we will not be responsible for such misuse. If you suspect that someone has unauthorised access to, or has made unauthorised use of, any of your Personal Information, please notify us as soon as possible.\n\nDestruction of Personal Information\nWe will take all reasonable steps to destroy or permanently de-identify your personal information if it is no longer needed for any of the purposes detailed above.\n\nLinks to Third Party Websites\nOur application may contain links to other sites. This policy applies solely to us and that we are not responsible for the privacy practices of any other website. We encourage you to read the privacy policies of every website that collects personal information.\n\nChanges to this policy\nRetailweb may amend this policy from time to time, and the policy will be published on its web site www.retailweb.com.au"


@interface LegalViewController ()

@end

@implementation LegalViewController

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
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self setupNav];
    [self setupTextView];
}


-(void)setupTextView{
    
    if (IS_IPHONE_5) {
        frameText = CGRectMake(0, 50, 320, 500);
    }
    else{
        frameText = CGRectMake(0, 50, 320, 410);
    }

    UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
    textView.text = LEGALTEXT;
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAddress;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
}

-(void)setupNav{
    CGRect frame = CGRectMake(151.0, 219.0, 25.0, 25.0);
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:frame];
    navBar.barStyle = UIBarStyleBlack;
    [navBar sizeToFit];
    navBar.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
    //[navBar setBackgroundImage:[UIImage imageNamed:@"nav50.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    UINavigationItem *backNavItem = [[UINavigationItem alloc] initWithTitle:@"Terms of Use"];
    [backNavItem setLeftBarButtonItem:closeButton animated:YES];
    [navBar pushNavigationItem:backNavItem animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closeView {
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Orientation
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


@end
