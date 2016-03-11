//
//  VenueViewController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 14/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "PaperFoldSwipeHintView.h"

@interface VenueViewController : UITableViewController 
{
    BOOL isLatLong;
}

@property (nonatomic,readonly,getter = isReady) BOOL ready;
@property (nonatomic, strong) NSDictionary *venueData;
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, retain) NSString *venueName;
@property (nonatomic, retain) NSString *cellAddAll;
@property (nonatomic, retain) NSString *latString;
@property (nonatomic, retain) NSString *longString;

@property (nonatomic, strong) NSDictionary *venueTitles;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSString* urlText;

@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

-(void)sortTable;

@end
