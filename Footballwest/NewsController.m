//
//  NewsController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 13/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "NewsController.h"
#import "NSString+HTML.h"
#import "ISRefreshControl.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface NewsController ()
{
    MBProgressHUD *hud;
}
@end

@implementation NewsController

@synthesize itemsToDisplay;
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
    // Setup
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //self.title = @"Loading...";
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    // Refresh button
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refresh)];
     */
    
    [self sortTable];
    [self loading];
    
    NSURL *feedURL = [NSURL URLWithString:NEWS_URL];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
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


-(void)sortTable{
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)loading{
	//[SVProgressHUD show];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidUnload{
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];
}

#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
    //self.title = @"Refreshing...";
    [self loading];
    [parsedItems removeAllObjects];
    [feedParser stopParsing];
    [feedParser parse];
    self.tableView.userInteractionEnabled = NO;
    //self.table.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.alpha = 1;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    //NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    //NSLog(@"Parsed Feed Info: “%@”", info.title);
    //self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    //NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
    [self.refreshControl endRefreshing];
    //    [SVProgressHUD dismiss];
    [hud removeFromSuperview];

}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    //NSLog(@"Finished Parsing With Error: %@", error);
    [self.refreshControl endRefreshing];
    //[SVProgressHUD dismiss];
    [hud removeFromSuperview];

    if (parsedItems.count == 0) {
        //self.title = @"Failed"; // Show failed message in title
        UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"No Internet Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        e.delegate = self;
        [e show];
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemsToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell.
    MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
    //NSLog(@"item, %@", item);
    if (item) {
        // Process
        NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        // Set
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.textLabel.text = itemTitle;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];

        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.numberOfLines = 4;
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];

        
        UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"cellFW.png"]];
        [cell setBackgroundView:cellOne];
        
        UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
        [cell setSelectedBackgroundView:cellTwo];

        NSMutableString *subtitle = [NSMutableString string];
        if (item.date) [subtitle appendFormat:@" %@\n", [formatter stringFromDate:item.date]];
        [subtitle appendString:itemSummary];
        cell.detailTextLabel.text = subtitle;
    }    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
    NSString *itemLink = item.link ? [item.link stringByConvertingHTMLToPlainText] : @"[No Link]";

    NSURL *newsDetailView = [NSURL URLWithString:itemLink];
    //BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:newsDetailView];
    NewsBrowserController *bvc = [[NewsBrowserController alloc] initWithUrls:newsDetailView];
    [self.navigationController pushViewController:bvc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
