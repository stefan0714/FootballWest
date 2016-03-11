//
//  LadderViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 3/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "LadderViewController.h"
#import "AppDelegate.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface LadderViewController ()
{
    CGRect tableFrame;
}
@end

@implementation LadderViewController
@synthesize tabView;
@synthesize lc;
@synthesize urlLadder;

@synthesize teamName;
@synthesize teamValue;
@synthesize teamPosition;
@synthesize compName;
@synthesize currentRound;

@synthesize xmlParseData;
@synthesize xmlValue;
@synthesize receiveData;
@synthesize currentItem;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self showLoading];
    
    [self sortLink];
    [self setupNav];
    [self setupTable];
    [self beginXML];
    
    //[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [self performSelectorOnMainThread:@selector(beginXML) withObject:nil waitUntilDone:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    //[self showLoading];

    //[self performSelector:@selector(beginXML) withObject:nil afterDelay:3.0];

}

-(void)showLoading{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sortLink{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url = [[NSString alloc] initWithFormat:@"%@", delegate.ladderURL];
    self.urlLadder = url;
}

-(void)beginXML{

    xmlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlLadder]] delegate:self];
    
     if (xmlConnection == nil){
         //[SVProgressHUD dismiss];
         //[HUD removeFromSuperview];
     UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    [HUD removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *y = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    y.delegate = self;
    [y show];
    //[SVProgressHUD dismiss];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receiveData appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receiveData];
    [parser setDelegate:self];
    [parser parse];
    self.receiveData = nil;
	[self.tabView reloadData];
    //[SVProgressHUD dismiss];

    [HUD removeFromSuperview];
}

#pragma mark XMLParse delegate methods
- (void)parserDidStartDocument : (NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"Data"])
		elementType1 = etItem1;
	[xmlValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (elementType1 != etItem1)
		return;
	if ([elementName isEqualToString:@"Position"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
    }
    if ([elementName isEqualToString:@"TeamName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Value"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Played"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Won"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Drawn"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"Lost"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"CompName"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}
    if ([elementName isEqualToString:@"CurrentRound"]) {
		[currentItem setValue:[NSString stringWithString:xmlValue] forKey:elementName];
	}    
    if ([elementName isEqualToString:@"Team"]) {
		[xmlParseData addObject:[NSDictionary dictionaryWithDictionary:currentItem]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (elementType1 == etItem1) {
		[xmlValue appendString:string];
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[SVProgressHUD dismiss];
    [HUD removeFromSuperview];

}

-(void)viewDidUnload{
    //[SVProgressHUD dismiss];
    [HUD removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[SVProgressHUD dismiss];
    [HUD removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[SVProgressHUD dismiss];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [xmlParseData count];
    // NSLog(@"count: %d",[xmlParseData count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }*/
    
    static NSString *CellIdentifier = @"Cell";
    
    LadderCell *cell = (LadderCell *)[tabView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LadderCell" owner:self options:nil];
        cell = lc;
    }

    NSDictionary *dictionary = [xmlParseData objectAtIndex:indexPath.row];
	
    cell.teamName.text = [dictionary objectForKey:@"TeamName"];
	cell.teamPosition.text = [dictionary objectForKey:@"Position"];
	cell.teamValue.text = [dictionary objectForKey:@"Value"];
	
    NSString *teamPlayedString = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"Played"]];
    NSString *teamWonString = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"Won"]];
    NSString *teamDrawString = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"Drawn"]];
    NSString *teamLostString = [[NSString alloc] initWithFormat:@"%@",[dictionary objectForKey:@"Lost"]];
    
    if ([teamPlayedString isEqualToString:@""] || [teamPlayedString isEqual:nil]) {
        cell.teamPlayed.text = @"0";
    }
    else {
        cell.teamPlayed.text = teamPlayedString;
    }

    if ([teamWonString isEqualToString:@""] || [teamWonString isEqual:nil]) {
        cell.teamWon.text = @"0";
    }
    else {
        cell.teamWon.text = teamWonString;
    }
    
    if ([teamDrawString isEqualToString:@""] || [teamDrawString isEqual:nil]) {
        cell.teamDrawn.text = @"0";
    }
    else {
        cell.teamDrawn.text = teamDrawString;
    }
    if ([teamLostString isEqualToString:@""] || [teamLostString isEqual:nil]) {
        cell.teamLost.text = @"0";
    }
    else {
        cell.teamLost.text = teamLostString;
    }
    //cell.teamPlayed.text = [dictionary objectForKey:@"Played"];
	//cell.teamWon.text = [dictionary objectForKey:@"Won"];
	//cell.teamDrawn.text = [dictionary objectForKey:@"Drawn"];
	//cell.teamLost.text = [dictionary objectForKey:@"Lost"];
    
    cell.teamName.textColor = [UIColor whiteColor];
    cell.teamPosition.textColor = [UIColor whiteColor];
    cell.teamValue.textColor = [UIColor whiteColor];
    cell.teamPlayed.textColor = [UIColor whiteColor];
	cell.teamWon.textColor = [UIColor whiteColor];
	cell.teamDrawn.textColor = [UIColor whiteColor];
	cell.teamLost.textColor = [UIColor whiteColor];

    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"cellFW.png"]];
    [cell setBackgroundView:cellOne];
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tabView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)setupTable{
    ////    CGRect tableFrame = CGRectMake(0, 44, 320, 416);

    if (IS_IPHONE_5) {
    tableFrame = CGRectMake(0, 54, 320, 506);
    }
    else
    {
    tableFrame = CGRectMake(0, 54, 320, 426);
    }
    tabView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	tabView.delegate = self;
	tabView.dataSource = self;
    tabView.backgroundColor = [UIColor darkGrayColor];
    tabView.rowHeight = 30;
    //tabView.sectionHeaderHeight = 30;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    tabView.contentInset = inset;
    [self.view addSubview:tabView];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setupNav{
    CGRect frame = CGRectMake(151.0, 219.0, 25.0, 25.0);
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:frame];
    navBar.barStyle = UIBarStyleBlack;
    [navBar sizeToFit];
    navBar.frame = CGRectMake(0.0, 0.0, 320.0, 54.0);
    //[navBar setBackgroundImage:[UIImage imageNamed:@"nav50.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
   // UIBarButtonItem *testButton = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(requestAccess)];

    UINavigationItem *backNavItem = [[UINavigationItem alloc] initWithTitle:@"Ladder"];
    //[backNavItem setLeftBarButtonItem:testButton animated:YES];
    [backNavItem setRightBarButtonItem:closeButton animated:YES];
    [navBar pushNavigationItem:backNavItem animated:NO];
}

# pragma Header Title

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}



 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, tableView.bounds.size.width - 20, 20)];
    //label.text = @"Position       Team                                   Points";
    label.text = @"#    Team                                    P  W  D  L  Pts";
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Verdana" size:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    return headerView;
}

- (void)closeView {
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
