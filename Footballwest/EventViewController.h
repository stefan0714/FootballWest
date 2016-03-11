//
//  EventViewController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 22/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PaperFoldSwipeHintView.h"

typedef enum {
	etNone2 = 0,
	etItem2
} eElementType2;

@interface EventViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, NSXMLParserDelegate>
{
    //NSInteger eventCount;
    //NSMutableArray *parsedItems;
    eElementType2 elementType2;
    NSURLConnection *xmlConnection;
}
@property (nonatomic, retain) NSString *eventDate;
@property (nonatomic, retain) NSString *eventHeadline;
@property (nonatomic, retain) NSString *eventText;
@property (nonatomic, retain) NSString *eventCost;
@property (nonatomic, retain) NSString *eventMore;
@property (nonatomic, retain) NSString *eventResURL;
@property (nonatomic, retain) NSString *eventResEmail;
@property (nonatomic, retain) NSString *eventImage;

//@property (nonatomic, retain) NSArray *itemsToDisplay;

//NSXML
@property (nonatomic, retain) NSMutableString *xmlValue;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSMutableArray *xmlParseData;
@property (nonatomic, retain) NSMutableDictionary *currentItem;

@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

@end
