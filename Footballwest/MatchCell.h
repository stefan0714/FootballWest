//
//  MatchCell.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 4/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *homeNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *homeScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *awayNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *awayScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *VenueLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@end
