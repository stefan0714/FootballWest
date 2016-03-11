//
//  MatchDetailsViewController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 28/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCell.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

typedef enum {
	etNone = 0,
	etItem
} eElementType;

@interface MatchDetailsViewController : UITableViewController <NSXMLParserDelegate, UIActionSheetDelegate, UIAlertViewDelegate, EKEventEditViewDelegate, EKCalendarChooserDelegate, EKEventViewDelegate>
{
    eElementType elementType;
    NSURLConnection *xmlConnection;
    UIActionSheet *actionSheet;
    EKEventStore *eventStore;
}

@property (nonatomic, retain) NSString *stringName; 

//XML
@property (nonatomic, retain) NSString *mAwayTeam;
@property (nonatomic, retain) NSString *mAwayScore;
@property (nonatomic, retain) NSString *mHomeTeam;
@property (nonatomic, retain) NSString *mHomeScore;
@property (nonatomic, retain) NSString *mVenueName;
@property (nonatomic, retain) NSString *mMatchTime;
@property (nonatomic, retain) NSDate *mMatchDate;
@property (nonatomic, retain) NSString *mAddress;
@property (nonatomic, retain) NSString *mLat;
@property (nonatomic, retain) NSString *mLong;

//NSXML
@property (nonatomic, retain) NSMutableString *xmlValue;
@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSMutableArray *xmlParseData;
@property (nonatomic, retain) NSMutableDictionary *currentItem;
@property (nonatomic, retain) NSDictionary *dictionary;


@property (nonatomic, retain) IBOutlet MatchCell *mc;
@property (nonatomic, strong) NSString* urlText;
@property (nonatomic, strong) NSString* venueLat;
@property (nonatomic, strong) NSString* venueLong;
@property (nonatomic, strong) NSString* venueAddress;

//AppDelegate
@property (nonatomic, strong) NSString* urlFixture;


@end
