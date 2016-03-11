//
//  MenuViewController.m
//  Footballwest
//
//  Created by Adrian Jurcevic on 13/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuList;

- (id)initWithMenuWidth:(float)menuWidth numberOfFolds:(int)numberOfFolds
{
    self = [super initWithMenuWidth:menuWidth numberOfFolds:numberOfFolds];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOnlyAllowEdgeDrag:NO];
    
    UIView *tableBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [tableBgView setBackgroundColor:[UIColor darkGrayColor]];
    //[tableBgView setBackgroundColor:[UIColor colorWithRed:0.170 green:0.166 blue:0.175 alpha:1.000]];
    [self.menuTableView setBackgroundView:tableBgView];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.menuTableView setShowsVerticalScrollIndicator:NO];
    [self performSelector:@selector(reloadMenu)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)paperFoldMenuController:(PaperFoldMenuController *)paperFoldMenuController didSelectViewController:(UIViewController *)viewController
{
    
}

/**
 * Override the method to customize cells
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.menuTableView)
    {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            [[cell textLabel] setTextColor:[UIColor whiteColor]];
            [[cell textLabel] setHighlightedTextColor:[UIColor blackColor]];
            [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellFW.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [cell setBackgroundView:bgView];
            UIImageView *sBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"custom_tile_bg.jpg"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [cell setSelectedBackgroundView:sBgView];
            
        }
        
        UIViewController *viewController = self.viewControllers[indexPath.row];
        [cell.textLabel setText:viewController.title];
        
        if (indexPath.row==self.selectedIndex)
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        return cell;
    }
    else return nil;
}

@end
