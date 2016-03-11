//
//  LadderViewController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 3/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LadderCell.h"
#import "MBProgressHUD.h"

//#import "PaperFoldMenuController.h"

typedef enum {
	etNone1 = 0,
	etItem1
} eElementType1;

//@interface LadderViewController : PaperFoldMenuController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
@interface LadderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *parsedItems;
    eElementType1 elementType1;
    NSURLConnection *xmlConnection;
}

@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) IBOutlet LadderCell *lc;

//AppDelegate
@property (nonatomic, strong) NSString* urlLadder;

//Elements
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamPosition;
@property (nonatomic, retain) NSString *teamValue;
@property (nonatomic, retain) NSString *compName;
@property (nonatomic, retain) NSString *currentRound;

//XML
@property (nonatomic, retain) NSMutableString *xmlValue;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSMutableArray *xmlParseData;
@property (nonatomic, retain) NSMutableDictionary *currentItem;


@end
