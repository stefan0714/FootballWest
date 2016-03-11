//
//  EventViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 22/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "EventViewController.h"
#import "ISRefreshControl.h"
//#import "SMXMLDocument.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

#import "BrowserViewController.h"

#define EVENT_URL @"http://coast260.anchor.net.au/cpftmb/clubinfo?club_id=6"

@interface EventViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation EventViewController
@synthesize eventHeadline, eventCost, eventDate, eventImage, eventMore, eventResEmail, eventResURL, eventText;
//@synthesize itemsToDisplay;
@synthesize currentItem;
@synthesize xmlParseData, xmlValue;
@synthesize receiveData;

@synthesize ps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   //parsedItems = [[NSMutableArray alloc] init];
    //self.itemsToDisplay = [NSArray array];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.rowHeight = 80;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self beginNSXML];

    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];

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

-(void)viewDidUnload{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}

-(void)loading{
	//[SVProgressHUD show];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)beginNSXML{
    //[SVProgressHUD show];
    [self loading];
    xmlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:EVENT_URL]] delegate:self];
    xmlParseData = [[NSMutableArray alloc] init];
    xmlValue = [[NSMutableString alloc] init];
    currentItem = [[NSMutableDictionary alloc] init];
    receiveData = [[NSMutableData alloc] init];
}

/*
-(void)beginXML{
    
    NSString *query = [NSString stringWithFormat:EVENT_URL];
    NSURL *URL = [NSURL URLWithString:query];
    NSData *data = [NSData dataWithContentsOfURL:URL];

    
    NSError *error;
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error) {
        NSLog(@"Error while parsing the document: %@", error);
        return;
    }
    
	SMXMLElement *events = [document.root childNamed:@"club_event"];
	
	for (SMXMLElement *event in [events childrenNamed:@"event"]) {
		
        eventCount = [event valueWithPath:@"event_total"];
        eventDate = [event valueWithPath:@"event_date"]; // child node value
        eventHeadline = [event valueWithPath:@"event_head_line"]; // child node value
        [parsedItems addObject:eventHeadline];
		eventText = [event valueWithPath:@"event_text"]; // child node value
		eventCost = [event valueWithPath:@"event_cost"]; // child node value
		eventMore = [event valueWithPath:@"more_event_url"]; // child node value
		eventResURL = [event valueWithPath:@"reservation_url"]; // child node value
		eventResEmail = [event valueWithPath:@"reservation_email"]; // child node value
		eventImage = [event valueWithPath:@"email_img_url"]; // child node value
        NSLog(@"t:%@",eventText);
	}
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
}
*/

#pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [hud removeFromSuperview];
    //[SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *y = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    y.delegate = self;
    [y show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receiveData];
    [parser setDelegate:self];
    [parser parse];
    self.receiveData = nil;
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

    [self.refreshControl endRefreshing];
	[self.tableView reloadData];
}

#pragma mark XMLParse delegate methods
- (void)parserDidStartDocument : (NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"club_event"])
		elementType2 = etItem2;
	[xmlValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (elementType2 != etItem2)
		return;
	if ([elementName isEqualToString:@"event_date"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
    }
    if ([elementName isEqualToString:@"event_head_line"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"event_text"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"event_cost"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"more_event_url"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"registration_required"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"reservation_url"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"reservation_email"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"event_img_url"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}    
    if ([elementName isEqualToString:@"event"]) {
		[xmlParseData addObject:[NSDictionary dictionaryWithDictionary:currentItem]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (elementType2 == etItem2) {
		[xmlValue appendString:string];
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}


-(void)refresh{
    //[parsedItems removeAllObjects];
    [self beginNSXML];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [xmlParseData count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dictionary = [xmlParseData objectAtIndex:indexPath.row];
    eventHeadline = [dictionary objectForKey:@"event_head_line"];
    eventResEmail = [dictionary objectForKey:@"reservation_email"];
    eventResURL = [dictionary objectForKey:@"reservation_url"];
    
    cell.textLabel.text = eventHeadline;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
   cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@: %@",[dictionary objectForKey:@"event_date"], [dictionary objectForKey:@"event_text"]];
    cell.detailTextLabel.numberOfLines = 4;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"cellFW.png"]];
	[cell setBackgroundView:cellOne];
    
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:eventHeadline delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Book via Email",@"Event Website", nil];
    [actionSheet showInView:self.view];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //NSLog(@"zero = book :%@",eventResEmail);
        [self emailEvent:eventResEmail subject:eventHeadline];
    }
    if (buttonIndex == 1) {
        //NSLog(@"one event website");
        [self eventWebsite:eventResURL];
    }
}
/*
 eventDate = [event valueWithPath:@"event_date"]; // child node value
 eventHeadline = [event valueWithPath:@"event_head_line"]; // child node value
 [parsedItems addObject:eventHeadline];
 eventText = [event valueWithPath:@"event_text"]; // child node value
 eventCost = [event valueWithPath:@"event_cost"]; // child node value
 eventMore = [event valueWithPath:@"more_event_url"]; // child node value
 eventResURL = [event valueWithPath:@"reservation_url"]; // child node value
 eventResEmail = [event valueWithPath:@"reservation_email"]; // child node value
 eventImage = [event valueWithPath:@"email_img_url"]; // child node value
*/

-(void)emailEvent:(NSString *)emailString subject:(NSString *)subjectString{
    NSString *emailAddress = emailString;
    NSString *emailHeading = subjectString;
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:emailHeading];
        NSArray *toRecipients = [NSArray arrayWithObjects:emailAddress, nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"Hi, \n\n I would like to book for this event.";
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


-(void)eventWebsite:(NSString *)websiteURL{
    
NSURL *url = [NSURL URLWithString:websiteURL];
BrowserViewController *bwv = [[BrowserViewController alloc] initWithUrls:url];
[self.navigationController pushViewController:bwv animated:YES];
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
