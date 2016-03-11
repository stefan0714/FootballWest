//
//  AppDelegate.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 6/01/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"
#import "iVersion.h"

#import "NewsController.h"
#import "VenueViewController.h"
#import "KKViewController.h"
#import "EventViewController.h"
#import "InfoController.h"
#import "FixtureViewController.h"

#define FACEBOOK_URL    @"http://www.facebook.com/FootballWest"
#define TWITTER_URL    @"http://www.twitter.com/footballwest"
#define PARTNER_URL    @"http://www.footballwest.com.au/index.php?id=35"
//#define CLUB_URL    @"http://www.myfootballclub.com.au/index.php?id=63"
#define CLUB_URL    @"http://www.foxsportspulse.com/assoc_page.cgi?c=1-8273-0-201262-0&a=CLUBS"
//#define PHOTO_URL    @"http://www.footballwest.tv/gallery/"
#define INSTAGRAM_URL    @"http://instagram.com/footballwest"

@implementation AppDelegate

@synthesize fixtureURL, ladderURL, ladderValue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _menuController = [[MenuViewController alloc] initWithMenuWidth:200.0 numberOfFolds:2];
    [_menuController setDelegate:self];
    [self.window setRootViewController:_menuController];
    
    NSMutableArray *viewControllers = [NSMutableArray array];

    //View Controllers
    //Fixtures
    FixtureViewController *fc = [[FixtureViewController alloc] init];
    [fc setTitle:[NSString stringWithFormat:@"%@",FIXTURE]];
    UINavigationController *fn = [[UINavigationController alloc] initWithRootViewController:fc];
    //[[fn navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav50.png"] forBarMetrics:UIBarMetricsDefault];
    [viewControllers addObject:fn];

    //News
    NewsController *newsc = [[NewsController alloc] init];
    [newsc setTitle:[NSString stringWithFormat:@"%@",NEWS]];
    UINavigationController *newsnav = [[UINavigationController alloc] initWithRootViewController:newsc];
    //[[newsnav navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav70.png"] forBarMetrics:UIBarMetricsDefault];
    [viewControllers addObject:newsnav];

    //Video
    KKViewController *vidc = [[KKViewController alloc] initWithStyle:UITableViewStylePlain];
    [vidc setTitle:[NSString stringWithFormat:@"%@",VIDEO]];
    UINavigationController *videonav = [[UINavigationController alloc] initWithRootViewController:vidc];
    //[[videonav navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav70.png"] forBarMetrics:UIBarMetricsDefault];
    [viewControllers addObject:videonav];
    
    //Events
    //EventViewController *eventc = [[EventViewController alloc] init];
    //[eventc setTitle:[NSString stringWithFormat:@"%@",EVENT]];
    //UINavigationController *eventnav = [[UINavigationController alloc] initWithRootViewController:eventc];
    //[[eventnav navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav50.png"] forBarMetrics:UIBarMetricsDefault];
    //[viewControllers addObject:eventnav];
    
    //Venue
    VenueViewController *vc = [[VenueViewController alloc] init];
    [vc setTitle:[NSString stringWithFormat:@"%@",VENUE]];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    //[[nc navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav70.png"] forBarMetrics:UIBarMetricsDefault];
    [viewControllers addObject:nc];

    //WEBLINKS
    //Photo
    //NSURL *photourl = [NSURL URLWithString:PHOTO_URL];
    //BrowserViewController *bvc4 = [[BrowserViewController alloc] initWithUrls:photourl];
    //[bvc4 setTitle:[NSString stringWithFormat:@"%@",PHOTO]];
    //UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:bvc4];
    //[viewControllers addObject:nc4];
    
    //Clubs
    NSURL *curl = [NSURL URLWithString:CLUB_URL];
    BrowserViewController *bvc3 = [[BrowserViewController alloc] initWithUrls:curl];
    [bvc3 setTitle:[NSString stringWithFormat:@"%@",CLUB]];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:bvc3];
    [viewControllers addObject:nc3];
    
    //Partner
    NSURL *purl = [NSURL URLWithString:PARTNER_URL];
    BrowserViewController *bvc2 = [[BrowserViewController alloc] initWithUrls:purl];
    [bvc2 setTitle:[NSString stringWithFormat:@"%@",PARTNER]];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:bvc2];
    [viewControllers addObject:nc2];
    
    //Facebook
    NSURL *surl = [NSURL URLWithString:FACEBOOK_URL];
    BrowserViewController *bvc1 = [[BrowserViewController alloc] initWithUrls:surl];
    [bvc1 setTitle:[NSString stringWithFormat:@"%@",FACEBOOK]];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:bvc1];
    [viewControllers addObject:nc1];

    //Twitter
    NSURL *twiturl = [NSURL URLWithString:TWITTER_URL];
    BrowserViewController *bvc5 = [[BrowserViewController alloc] initWithUrls:twiturl];
    [bvc5 setTitle:[NSString stringWithFormat:@"%@",TWITTER]];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:bvc5];
    [viewControllers addObject:nc5];
    
    //Instagram
    NSURL *iurl = [NSURL URLWithString:INSTAGRAM_URL];
    BrowserViewController *bvc7 = [[BrowserViewController alloc] initWithUrls:iurl];
    [bvc7 setTitle:[NSString stringWithFormat:@"%@",IG]];
    UINavigationController *nc7 = [[UINavigationController alloc] initWithRootViewController:bvc7];
    [viewControllers addObject:nc7];

    
    //Information
    InfoController *infoc = [[InfoController alloc] init];
    [infoc setTitle:[NSString stringWithFormat:@"%@",ABOUT]];
    UINavigationController *infonav = [[UINavigationController alloc] initWithRootViewController:infoc];
    //[[infonav navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav70.png"] forBarMetrics:UIBarMetricsDefault];
    [viewControllers addObject:infonav];

    
    [_menuController setViewControllers:viewControllers];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self animateSplashScreen];

    return YES;
}

- (void)paperFoldMenuController:(PaperFoldMenuController *)paperFoldMenuController didSelectViewController:(UIViewController *)viewController
{

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)animateSplashScreen
{
    
    //fade time
//#warning change back to 3.7
    CFTimeInterval animation_duration = 3.7;
    
    CGRect splashFrame = self.window.bounds;
    //SplashScreen
    UIImageView * splashView = [[UIImageView alloc] initWithFrame:splashFrame];
    splashView.image = [UIImage imageNamed:@"Advertising_launch_page1_large.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    //Animation (fade away with zoom effect)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation_duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:splashView];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    splashView.alpha = 0.0;
    if (IS_IPHONE_5) {
        splashView.frame = CGRectMake(-20, -20, 360, 670);
    }
    else{
    splashView.frame = CGRectMake(-20, -20, 360, 520);
    }
    [UIView commitAnimations];
    
}


- (BOOL)openURL:(NSURL*)url
{
    BrowserViewController *bvc = [[BrowserViewController alloc] initWithUrls:url];
    [self.menuController.navigationController pushViewController:bvc animated:YES];
    
    return YES;
}

+ (void)initialize
{
	[iRate sharedInstance].onlyPromptIfLatestVersion = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self animateSplashScreen];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
