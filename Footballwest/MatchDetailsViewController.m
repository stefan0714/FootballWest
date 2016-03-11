//
//  MatchDetailsViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 28/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "MatchDetailsViewController.h"
//#import "SVProgressHUD.h"
#import "LadderViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface MatchDetailsViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation MatchDetailsViewController
@synthesize stringName;

@synthesize mAwayTeam, mAwayScore, mHomeTeam, mHomeScore, mVenueName, mMatchDate, mMatchTime;
@synthesize mAddress, mLat, mLong;

@synthesize currentItem;
@synthesize xmlParseData, xmlValue;
@synthesize receiveData;

@synthesize mc;
@synthesize urlText;
@synthesize venueLat;
@synthesize venueLong;
@synthesize venueAddress;
@synthesize dictionary;

@synthesize urlFixture;

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

    eventStore = [[EKEventStore alloc] init];

    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Ladder" style:UIBarButtonItemStyleBordered target:self action:@selector(checkLadder)];
   
    mMatchDate = [[NSDate alloc] init];
    
    //[SVProgressHUD show];
    [self hudLoading];
    [self CheckFixtureLadder];
    [self sortTable];
    [self sortLink];
    [self beginNSXML];
}

-(void)hudLoading
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)sortTable{
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.rowHeight = 80;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)CheckFixtureLadder
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* ladderString = [[NSString alloc] initWithFormat:@"%@", delegate.ladderValue];
    //NSLog(@"adsf%@", ladderString);
    if ([ladderString isEqualToString:@"no"]) {
        //NSLog(@"do not dispaly a cup");
    } else {
        //NSLog(@"display");

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Ladder" style:UIBarButtonItemStyleBordered target:self action:@selector(checkLadder)];
    }
}

-(void)checkLadder{
    LadderViewController * lc = [[LadderViewController alloc] init];
    //[self presentViewController:lc animated:YES completion:nil];
    
    lc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	//[self presentModalViewController:lc animated:YES];
    [self presentViewController:lc animated:YES completion:nil];
}

-(void)sortLink{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url = [[NSString alloc] initWithFormat:@"%@", delegate.fixtureURL];
    self.urlFixture = url;
}

-(void)beginNSXML{
    xmlParseData = nil;
    xmlValue = nil;
    currentItem = nil;
    receiveData = nil;
    
    xmlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlFixture]] delegate:self];
    
    if (xmlConnection == nil){
        //[SVProgressHUD dismiss];
        [hud removeFromSuperview];

     UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No information could be captured, Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     e.delegate = self;
     [e show];
     }
    else
     {
    xmlParseData = [[NSMutableArray alloc] init];
    xmlValue = [[NSMutableString alloc] init];
    currentItem = [[NSMutableDictionary alloc] init];
    receiveData = [[NSMutableData alloc] init];
    }
}

#pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //[SVProgressHUD dismiss];
    [hud removeFromSuperview];

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
    //[SVProgressHUD dismiss];
    [hud removeFromSuperview];

	[self.tableView reloadData];
}


#pragma mark XMLParse delegate methods
- (void)parserDidStartDocument : (NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"Matches"])
		elementType = etItem;
	[xmlValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (elementType != etItem)
		return;
	if ([elementName isEqualToString:@"AwayName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
    }
    if ([elementName isEqualToString:@"AwayScore"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Date"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"HomeName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"HomeScore"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Time"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueAddress1"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueState"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueAddress3"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueLat"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"VenueLong"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"CompName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}

    if ([elementName isEqualToString:@"Match"]) {
		[xmlParseData addObject:[NSDictionary dictionaryWithDictionary:currentItem]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (elementType == etItem) {
		[xmlValue appendString:string];
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    MatchCell *cell = (MatchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MatchCell" owner:self options:nil];
        cell = mc;
    }
    dictionary = [[NSDictionary alloc]init];
    dictionary = nil;
    dictionary = [xmlParseData objectAtIndex:indexPath.row];
	cell.homeNameLabel.text = [dictionary objectForKey:@"HomeName"];
	cell.awayNameLabel.text = [dictionary objectForKey:@"AwayName"];

    //Format Scores
	if ([[dictionary objectForKey:@"HomeScore"] isEqualToString:@""] || [[dictionary objectForKey:@"HomeScore"] isEqual:nil]) {
        cell.homeScoreLabel.text = @"-";
        cell.awayScoreLabel.text = @"-";
    }
    else
    {
    cell.homeScoreLabel.text = [dictionary objectForKey:@"HomeScore"];
	cell.awayScoreLabel.text = [dictionary objectForKey:@"AwayScore"];
    }
    
    //Format Venue
    if ([[dictionary objectForKey:@"VenueName"] isEqualToString:@""] || [[dictionary objectForKey:@"VenueName"] isEqual:nil]) {
        cell.VenueLabel.text = @"Bye";
    }
    else
    {
    cell.VenueLabel.text = [dictionary objectForKey:@"VenueName"];
    }
    
    if ([cell.VenueLabel.text isEqualToString:@"Bye"]) {
        cell.homeScoreLabel.text = @"";
        cell.awayScoreLabel.text = @"";
    }
    
    //Format Date
    NSString *dateStr = [dictionary objectForKey:@"Date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"EEEE MMM d, YYYY hh:mma"];
    dateStr = [dateFormat2 stringFromDate:date];
	cell.dateLabel.text = dateStr;
    
    //Custom Cell
    cell.homeNameLabel.textColor = [UIColor whiteColor];
    cell.homeNameLabel.textColor = [UIColor whiteColor];
	cell.homeScoreLabel.textColor = [UIColor whiteColor];
	cell.awayNameLabel.textColor = [UIColor whiteColor];
	cell.awayScoreLabel.textColor = [UIColor whiteColor];
	cell.VenueLabel.textColor = [UIColor lightGrayColor];
	cell.dateLabel.textColor = [UIColor lightGrayColor];

    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"fixture.png"]];
    [cell setBackgroundView:cellOne];
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];

    self.stringName = [dictionary objectForKey:@"CompName"];
    
    return cell;
}

-(void)viewDidUnload{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}

-(void)viewDidDisappear:(BOOL)animated{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}

-(void)viewWillDisappear:(BOOL)animated{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}


# pragma Header Title

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return stringName;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, tableView.bounds.size.width - 20, 20)];
    label.text = stringName;
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Verdana" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    return headerView;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    dictionary = [xmlParseData objectAtIndex:indexPath.row];
    
    //Define Event Details
    mHomeTeam = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"HomeName"]];
    mAwayTeam = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"AwayName"]];
    mVenueName = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"VenueName"]];
    
    //Format Date for Event
    NSString *dateStr = [dictionary objectForKey:@"Date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.mMatchDate = [dateFormat dateFromString:dateStr];

    
    //Define Location Details
    venueLat = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"VenueLat"]];
    venueLong = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"VenueLong"]];
    venueAddress = [[NSString alloc] initWithFormat:@"%@, %@, %@",[dictionary objectForKey:@"VenueAddress1"],[dictionary objectForKey:@"VenueAddress3"],[dictionary objectForKey:@"VenueState"]];
    
    //Create ActionSheet
    if (venueLat.length < 3) {
        UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no information for this match" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        aView.delegate = self;
        [aView show];
    }
    else
    {
    NSString *ASVenueName = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"VenueName"]];
    actionSheet = [[UIActionSheet alloc] initWithTitle:ASVenueName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Display Location", @"Save to Calendar", nil];
    [actionSheet showInView:self.view];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //NSLog(@"location");
        if (venueLat) {
            [self latitude:venueLat longitude:venueLong];
        }
        else{
            [self goToVenue:venueAddress];
        }
    }
    if (buttonIndex == 1) {
        //NSLog(@"save calender");
        [self saveEvent];
    }
    if (buttonIndex == 2) {
       // NSLog(@"cancel");
    }
}

#pragma Display Location

-(void)goToVenue:(NSString *)string  {
    NSString *addressText =  [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        urlText = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
    }
    else{
        urlText = [[NSString alloc] initWithFormat:@"http://maps.apple.com/maps?q=%@", addressText];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}



-(void)latitude:(NSString *)lat longitude:(NSString *)lon  {
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        urlText = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?f=q&hl=em&q=%@,%@&ie=UTF8&z=16&iwloc=addr&om=1", lat, lon];
    }
    else{
        urlText = [[NSString alloc] initWithFormat:@"http://maps.apple.com/maps?f=q&hl=em&q=%@,%@&ie=UTF8&z=16&iwloc=addr&om=1", lat, lon];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

#pragma Calender Event

-(void)saveEvent{    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        __weak typeof (self) weakSelf = self; // replace __block with __weak if you are using ARC
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 [weakSelf performSelectorOnMainThread:@selector(addEventToCalendar) withObject:nil waitUntilDone:YES];
             }
             else
             {
                 NSLog(@"Not granted");
                 UIAlertView *alertCalendar = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to approve FootballWest to add to your Calendar, go to Settings -> Privacy -> Calendar" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alertCalendar show];
             }
         }];
    }
    else
    {
        [self addEventToCalendar];
    }
}

-(void)addEventToCalendar{
    EKEvent * event = [EKEvent eventWithEventStore:eventStore];
    NSString *titleEvent = [[NSString alloc] initWithFormat:@"%@ vs %@", mHomeTeam, mAwayTeam];
    
    event.title     = titleEvent;
    event.location  = venueAddress;
    event.startDate = mMatchDate;
    event.endDate = [event.startDate dateByAddingTimeInterval:3600];
    event.notes     = mVenueName;
    
    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    
    controller.eventStore       = eventStore;
    controller.event            = event;
    controller.editViewDelegate = self;
    
    NSError *error = nil;
    [controller.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    
    if (!error) {
    } else {
        error = nil;
    }
    
    [self presentViewController:controller animated:YES completion:nil];

    //[self presentModalViewController:controller animated:YES];

}

-(void)eventEditViewController:(EKEventEditViewController *)controller
         didCompleteWithAction:(EKEventEditViewAction)action {
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            //  User tapped "cancel"
            break;
        case EKEventEditViewActionSaved:
             // User tapped "save"
            break;
        case EKEventEditViewActionDeleted:
            // User tapped "delete"
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action{
    // NSLog(@"Blah");
}

/*
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
 */

@end
