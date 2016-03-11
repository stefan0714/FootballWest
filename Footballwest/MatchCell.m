//
//  MatchCell.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 4/04/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "MatchCell.h"

@implementation MatchCell
@synthesize homeNameLabel;
@synthesize homeScoreLabel;
@synthesize awayNameLabel;
@synthesize awayScoreLabel;
@synthesize VenueLabel;
@synthesize dateLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //CGRect homeFrame = CGRectMake(20, 20, 20, 20);
        //homeNameLabel = [[UILabel alloc] initWithFrame:homeFrame];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


/*
 UILabel *homeNameLabel;
 UILabel *homeScoreLabel;
 UILabel *awayNameLabel;
 UILabel *awayScoreLabel;
 UILabel *VenueLabel;
 UILabel *dateLabel;
 UILabel *timeLabel;
 UILabel *vsLabel;
*/