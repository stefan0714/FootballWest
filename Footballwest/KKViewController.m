//
//  KKViewController.m
//  tube
//
//  Created by zim on 5/02/13.
//  Copyright (c) 2013 . All rights reserved.
//

#import "KKViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "KKDetailsViewController.h"
#import "ISRefreshControl.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

#define FWTV_LINK @"http://gdata.youtube.com/feeds/api/playlists/UUD0JP77YsSijWhCltkvapbQ?v=2&alt=jsonc&max-results=50"
#define FWTV_LINK2 @"http://gdata.youtube.com/feeds/api/playlists/UUD0JP77YsSijWhCltkvapbQ?v=2&alt=jsonc&max-results=50"
//#define FWTV_LINK3 @"http://gdata.youtube.com/feeds/api/playlists/PL9itj0btAe-wgxoqfSI7XD7IbM4LdpirN?v=2&alt=jsonc&max-results=50&start-index=51"
//#define FWTV_LINK_MAIN @"http://gdata.youtube.com/feeds/api/videos/?alt=json&author=footballwesttv"

@interface KKViewController ()
{
    MBProgressHUD *hud;
}


@end

@implementation KKViewController{
    
    int counter;
}
@synthesize titles;
@synthesize ps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //[SVProgressHUD show];
    [self hudLoading];

    counter = 0;
    //NSString *urlAsString = @"http://gdata.youtube.com/feeds/api/playlists/PLA6F1B1A59147F69D?v=2&alt=jsonc&max-results=50";
    //NSString *urlAsString2 = @"http://gdata.youtube.com/feeds/api/playlists/PLA6F1B1A59147F69D?v=2&alt=jsonc&max-results=50&start-index=51";
    NSString *urlAsString = FWTV_LINK;
    NSString *urlAsString2 = FWTV_LINK2;

    self.urlStrings = @[urlAsString,urlAsString2];
    
    self.allThumbnails = [NSMutableArray array];
    
    self.videoMetaData = [NSMutableArray array];
    
    self.videoID = [NSMutableArray array];
    
    [self getJSONFromURL:self.urlStrings[0]];
    
    // Refresh button
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-landscape.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(slider)];
}

-(void)hudLoading
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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



-(void)getJSONFromURL:(NSString *) urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.myJSON = [JSON valueForKey:@"data"];
        
        [self.allThumbnails addObjectsFromArray:[self.myJSON valueForKeyPath:@"items.video.thumbnail"]];
        
        //NSLog(@"thumb: %@",self.allThumbnails);
        
        [self.videoMetaData  addObjectsFromArray:[self.myJSON valueForKeyPath:@"items.video"]];
        
        [self.videoID addObjectsFromArray:[self.myJSON valueForKeyPath:@"items.video.id"]];
        
        [self.tableView reloadData];

        counter += 1;
        
        if (counter < self.urlStrings.count)
            [self getJSONFromURL:self.urlStrings[counter]];
    }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
         UIAlertView *e = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         e.delegate = self;
         [e show];
         //[SVProgressHUD dismiss];
         //[self.refreshControl endRefreshing];
     }];
    
    
    [operation start];
    //[SVProgressHUD dismiss];
    [hud removeFromSuperview];

    [self.refreshControl endRefreshing];
}

-(void)refresh{
    
    [self.videoMetaData removeAllObjects];
    [self.videoID removeAllObjects];
    [self.allThumbnails removeAllObjects];
    [self hudLoading];
    //[SVProgressHUD show];
    [self getJSONFromURL:self.urlStrings[0]];
    [self.tableView reloadData];

    //[self.refreshControl endRefreshing];
}

-(void)viewDidUnload{
    [hud removeFromSuperview];

    //[SVProgressHUD dismiss];
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
    return [self.videoMetaData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
        
    titles = [self.videoMetaData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [titles objectForKey:@"title"];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    cell.detailTextLabel.text = [titles objectForKey:@"description"];
    cell.detailTextLabel.numberOfLines = 4;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    
    id vUser = [self.allThumbnails objectAtIndex:indexPath.row];
    if (vUser != [NSNull null]) {
        
        NSURL *url = [[NSURL alloc] initWithString:[vUser objectForKey:@"hqDefault"]];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fakeThumbnail.png"]];
        
    }
    else {

        }
    
    NSDictionary *thumbnails = [self.allThumbnails objectAtIndex:indexPath.row];
    NSURL *url = [[NSURL alloc] initWithString:[thumbnails objectForKey:@"hqDefault"]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fakeThumbnail.png"]];
    
    UIImageView *cellOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"cellFW.png"]];
	[cell setBackgroundView:cellOne];
    
    UIImageView *cellTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"news_highlight.jpg"]];
    [cell setSelectedBackgroundView:cellTwo];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.separatorColor = [UIColor clearColor];
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetails"])
    {
        NSDictionary *importVideoMetaData = [self.videoMetaData objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [segue.destinationViewController setImportVideoMetaData:importVideoMetaData];
        
        NSDictionary *importAllThumbnails = [self.allThumbnails objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [segue.destinationViewController setImportThumbnail:importAllThumbnails];
        
        NSString *importVideoID = [self.videoID objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        [segue.destinationViewController setImportVideoID:importVideoID];
        
        NSLog(@"sending video ID %@", importVideoID);
        
    }
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - Table view delegate
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKDetailsViewController *detailViewController = [[KKDetailsViewController alloc] initWithNibName:nil bundle:nil];
    
    NSDictionary *importVideoMetaData = [self.videoMetaData objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [detailViewController setImportVideoMetaData:importVideoMetaData];
    
    NSDictionary *importAllThumbnails = [self.allThumbnails objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [detailViewController setImportThumbnail:importAllThumbnails];
    
    NSString *importVideoID = [self.videoID objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [detailViewController setImportVideoID:importVideoID];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma Orientation



@end
