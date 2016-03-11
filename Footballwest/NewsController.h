//
//  NewsController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 13/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
//#import "BrowserViewController.h"
#import "NewsBrowserController.h"
#import "PaperFoldSwipeHintView.h"

//#define NEWS_URL @"http://www.footballwest.com.au/index.php?id=1&type=100&tx_ttnews[cat]=2&no_cache=1"
#define NEWS_URL @"http://www.footballwest.com.au/index.php?id=2&type=100"

@interface NewsController : UITableViewController <MWFeedParserDelegate>
{
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
}

@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

@end
