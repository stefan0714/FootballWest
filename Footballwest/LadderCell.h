//
//  LadderCell.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 5/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LadderCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *teamName;
@property (nonatomic, retain) IBOutlet UILabel *teamPosition;
@property (nonatomic, retain) IBOutlet UILabel *teamValue;
@property (nonatomic, retain) IBOutlet UILabel *compName;
@property (nonatomic, retain) IBOutlet UILabel *currentRound;

@property (nonatomic, retain) IBOutlet UILabel *teamPlayed;
@property (nonatomic, retain) IBOutlet UILabel *teamWon;
@property (nonatomic, retain) IBOutlet UILabel *teamDrawn;
@property (nonatomic, retain) IBOutlet UILabel *teamLost;


@end
