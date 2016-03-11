//
//  FixtureViewController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 28/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
// http://119.252.88.88/fbtw/complist?as_id=8273

#import <UIKit/UIKit.h>
#import "PaperFoldSwipeHintView.h"
#import "PaperFoldView.h"

@interface FixtureViewController : UITableViewController 

@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, strong) NSDictionary *fixtureTitles;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, readwrite) NSInteger currentLevel;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSArray *tableDataSource;

//complist
@property (nonatomic, retain) NSString *compFixURL;
@property (nonatomic, retain) NSString *compLadURL;
@property (nonatomic, retain) NSString *clusterURL;
@property (nonatomic, retain) NSString *ladderV;


@end
