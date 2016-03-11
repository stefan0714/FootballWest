//
//  VenueViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 14/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "VenueViewController.h"
#import "ISRefreshControl.h"
#import "AvailabilityInternal.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

#define VENUELIST @"http://www.jurcevic.com/fw/VenueList.plist"

@interface VenueViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation VenueViewController
@synthesize venueData;
@synthesize tableDataSource;
@synthesize dictionary;
@synthesize venueName;
@synthesize cellAddAll;
@synthesize venueTitles;
@synthesize titles = _titles;
@synthesize ready;
@synthesize latString, longString;
@synthesize urlText;

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
   
    [self sortTable];
    isLatLong = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getIssuesList)
                  forControlEvents:UIControlEventValueChanged];

    

    [self getIssuesList];
    
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

-(void)loading{
	//[SVProgressHUD show];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)getIssuesList {
    [self loading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       // Local plist
                       //NSString *path = [[NSBundle mainBundle] pathForResource:@"VenueListStatic" ofType:@"plist"];
                       //NSDictionary *tmpIssues = [[NSDictionary alloc] initWithContentsOfFile:path];

                       NSDictionary *tmpIssues = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:VENUELIST]];
                       
                       if(!tmpIssues) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"No Internet Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                               e.delegate = self;
                               [e show];
                               //                               [SVProgressHUD dismiss];
                               [hud removeFromSuperview];
                               [self.refreshControl endRefreshing];
                           });
                           
                       } else {
                           if(dictionary) {
                           }
                           dictionary = [[NSDictionary alloc] initWithDictionary:tmpIssues];
                           self.venueTitles = dictionary;
                           NSArray *array = [[self.venueTitles allKeys] sortedArrayUsingSelector:@selector(compare:)];
                           
                           _titles = array;
                           
                           ready = YES;

                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.tableView reloadData];
                               [self.refreshControl endRefreshing];
                               //                               [SVProgressHUD dismiss];
                               [hud removeFromSuperview];
                           });

                       }
                   });

}


-(void)sortTable {
    self.tableView = [[UITableView alloc] init];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 17;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = NSLocalizedString(@"Venues", @"Venues");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *alpha = [self.titles objectAtIndex:section];
    NSArray *alphaSelection = [self.venueTitles objectForKey:alpha];
    return [alphaSelection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *alpha = [self.titles objectAtIndex:[indexPath section]];
    
    NSArray *alphaSelection = [self.venueTitles objectForKey:alpha];
    
    NSDictionary *diction = [alphaSelection objectAtIndex:[indexPath row]];
    
    self.dictionary = diction;
	NSString * cellName = [[NSString alloc] initWithFormat:@"%@",[diction objectForKey:@"name"]];
	NSString * cellAddress = [[NSString alloc] initWithFormat:@"%@",[diction objectForKey:@"address"]];
	NSString * cellSuburb = [[NSString alloc] initWithFormat:@"%@",[diction objectForKey:@"suburb"]];
	NSString * cellPostcode = [[NSString alloc] initWithFormat:@"%@",[diction objectForKey:@"postcode"]];
    
    cellAddAll = [[NSString alloc] initWithFormat:@"%@, %@ %@", cellAddress, cellSuburb, cellPostcode];
        
    cell.textLabel.text = cellName;
    cell.detailTextLabel.text = cellAddAll;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    
    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"cellFW.png"]];
	[cell setBackgroundView:cellOne];
    
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];
    	
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *alpha = [self.titles objectAtIndex:section];
    return alpha;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.titles;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.separatorColor = [UIColor clearColor];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
	[self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *alpha = [self.titles objectAtIndex:[indexPath section]];
    
    NSArray *alphaSelection = [self.venueTitles objectForKey:alpha];
    
    NSDictionary *diction = [alphaSelection objectAtIndex:[indexPath row]];
    
    venueName = [[NSString alloc] initWithFormat:@"%@, %@ %@",[diction objectForKey:@"address"],[diction objectForKey:@"suburb"],[diction objectForKey:@"postcode"]];
    latString = [[NSString alloc] initWithFormat:@"%@", [diction objectForKey:@"latitude"]];
    longString = [[NSString alloc] initWithFormat:@"%@", [diction objectForKey:@"longitude"]];
    
    if (latString.length > 7) {
        isLatLong = YES;
    }

    NSString * venueString = [[NSString alloc] initWithFormat:@"%@",self.venueName];
    UIAlertView *w = [[UIAlertView alloc] initWithTitle:@"Locate Venue" message:venueString delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    w.delegate = self;
    [w show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			break;
		case 1:
			if (isLatLong) {
                [self latitude:latString longitude:longString];
            }
            else{
                [self goToVenue:venueName];
            }
            break;
		default:
			break;
	}
}


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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, tableView.bounds.size.width - 10, 15)];
    NSString *alpha = [self.titles objectAtIndex:section];
    label.text = alpha;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    return headerView;

}


-(void)viewDidUnload{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];
}

- (IBAction)dismissView:(id)sender {
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
