//
//  AppDelegate.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 6/01/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "BrowserViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PaperFoldMenuControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) MenuViewController *menuController;

//Fixtures
@property (strong, nonatomic) NSString *fixtureURL;
@property (strong, nonatomic) NSString *ladderURL;
@property (strong, nonatomic) NSString *ladderValue;

//Browser
- (BOOL)openURL:(NSURL*)url;

-(void)animateSplashScreen;

@end



