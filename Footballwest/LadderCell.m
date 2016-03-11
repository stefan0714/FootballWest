//
//  LadderCell.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 5/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "LadderCell.h"

@implementation LadderCell
@synthesize teamName, teamPosition, teamValue;
@synthesize compName, currentRound;
@synthesize teamWon,teamLost, teamDrawn, teamPlayed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
