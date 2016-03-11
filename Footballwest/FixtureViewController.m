//
//  FixtureViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 28/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "FixtureViewController.h"
#import "MatchDetailsViewController.h"
#import "BrowserViewController.h"
#import "NewsBrowserController.h"

//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

#import "AppDelegate.h"
//#import "PaperFoldMenuController.h"
#import "MenuViewController.h"
#import "AsyncImageDownloader.h"
#import "UIImageView+Network.h"

#define FIXTURELIST @"http://www.jurcevic.com/fw/FixtureList.plist"
#define COMPFIXTURE @"http://119.252.88.88/fbtw/compfixture?cm_id="
#define COMPELADDER @"http://119.252.88.88/fbtw/compladder?cm_id="

@interface FixtureViewController ()
{
    NSMutableArray *arrayImage;
    MBProgressHUD *hud;
}

@end

@implementation FixtureViewController
@synthesize dictionary;
@synthesize fixtureTitles;
@synthesize titles = _titles;
@synthesize currentLevel;
@synthesize currentTitle;
@synthesize tableDataSource;

@synthesize compFixURL, compLadURL;
@synthesize clusterURL;
@synthesize ps, ladderV;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {


    }
    return self;
}


- (void)viewDidLoad
{

    [super viewDidLoad];

    [self sortTable];
    [self didLoad];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    if (currentLevel == 0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-landscape.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(slider)];
    }
}


-(void)slider{
    
    PaperFoldMenuController *pfmc = [[PaperFoldMenuController alloc] init];
    
    [pfmc showMenu:NO animated:YES];

    ps = [[PaperFoldSwipeHintView alloc] initWithPaperFoldSwipeHintViewMode:PaperFoldSwipeHintViewModeSwipeRight];
    [ps showInView:self.view];
    
    [self performSelector:@selector(timerCallback) withObject:nil afterDelay:1.5];
}

-(void)timerCallback{
    [ps removeFromSuperview];
    [ps hide];
}

-(void)didLoad{
    //[SVProgressHUD show];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadFixtures];
}

#pragma mark paper fold delegate

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
    NSLog(@"did transition to state %i automated %i", paperFoldState, automated);
}


-(void)loadFixtures {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       // Local plist
                       //NSString *path = [[NSBundle mainBundle] pathForResource:@"FixtureList" ofType:@"plist"];
                       //NSDictionary *tmpIssues = [[NSDictionary alloc] initWithContentsOfFile:path];
                       
                       NSDictionary *tmpIssues = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:FIXTURELIST]];

                       if(!tmpIssues) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"No Internet Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                               e.delegate = self;
                               [e show];
                               //[SVProgressHUD dismiss];
                               [hud removeFromSuperview];
                               [self.refreshControl endRefreshing];
                           });
                           
                       } else {
                           if(dictionary) {
                           }
                           dictionary = [[NSDictionary alloc] initWithDictionary:tmpIssues];
                           self.fixtureTitles = dictionary;
                           NSArray *array = [[self.fixtureTitles allKeys] sortedArrayUsingSelector:@selector(compare:)];
                           _titles = array;
                           
                           
                           if(currentLevel == 0) {
                               
                               NSArray *tempArray = [[NSArray alloc] initWithArray:[fixtureTitles objectForKey:@"fixtures"]];
                               self.tableDataSource = tempArray;
                           }
                           else {
                               self.navigationItem.title = currentTitle;
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.tableView reloadData];
                               [self.refreshControl endRefreshing];
                               //[SVProgressHUD dismiss];
                               [hud removeFromSuperview];

                           });
                       }
                   });
    //[SVProgressHUD dismiss];
    [hud removeFromSuperview];

}

-(void)sortTable {
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 3;
    return [self.tableDataSource count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
   NSDictionary *tempDic = [self.tableDataSource objectAtIndex:indexPath.row];
    
    NSString *leagueTitle = [[NSString alloc] initWithFormat:@"%@", [tempDic objectForKey:@"title"]];
    
    cell.detailTextLabel.text = leagueTitle;
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    /*
    [self downloadImageWithURL:[tempDic objectForKey:@"imgurl"] completionBlock:^(BOOL succeeded, UIImage *image){
        if (succeeded) {
            cell.imageView.image = image;
        }
    }];
    */
    [cell.imageView setImage:[UIImage imageNamed:[tempDic objectForKey:@"image"]]];

    cell.imageView.backgroundColor = [UIColor clearColor];
    
    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"fixture.png"]];
    [cell setBackgroundView:cellOne];
    
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];

    return cell;
}
/* Async image download
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}*/


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)viewDidUnload{
    //[SVProgressHUD dismiss];
    self.compFixURL = nil;
    self.compLadURL = nil;
    self.clusterURL = nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
    
    //compFixURL = nil;
    //compLadURL = nil;
    //clusterURL = nil;

    NSString *compListID = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:@"complist"]];
    compFixURL = [[NSString alloc] initWithFormat:@"%@%@",COMPFIXTURE,compListID];
    compLadURL = [[NSString alloc] initWithFormat:@"%@%@",COMPELADDER,compListID];
    
    NSString *clusterID = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:@"cluster"]];
    clusterURL = clusterID;
    NSURL *url = [NSURL URLWithString:clusterURL];
    
    ladderV = [dictionary objectForKey:@"ladder"];
    //NSLog(@"qqq:%@", ladderV);
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.fixtureURL = self.compFixURL;
    delegate.ladderURL = self.compLadURL;
    delegate.ladderValue = ladderV;
    
    NSArray *children = [dictionary objectForKey:@"children"];
	
    if([children count] == 0) {
        if (clusterURL.length >7) {
            //BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:url];
            NewsBrowserController *bvc = [[NewsBrowserController alloc] initWithUrls:url];
            [self.navigationController pushViewController:bvc animated:YES];
        }
        else{
            MatchDetailsViewController *mdv = [[MatchDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:mdv animated:YES];
        }
    }
	else if ([children count] != 0) {
        FixtureViewController *fvc = [[FixtureViewController alloc] initWithStyle:UITableViewStylePlain];
		fvc.currentLevel += 1;
		fvc.currentTitle = [dictionary objectForKey:@"title"];
		[self.navigationController pushViewController:fvc animated:YES];
        fvc.tableDataSource = children;
    }
}

#pragma Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //if (orientation == UIInterfaceOrientationPortrait)
    //    return YES;
    return YES;
}

@end
