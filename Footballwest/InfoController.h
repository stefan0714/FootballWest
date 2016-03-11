//
//  InfoController.h
//  Footballwest
//
//  Created by Adrian Jurcevic on 27/03/13.
//  Copyright (c) 2013 Retailweb Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PaperFoldSwipeHintView.h"

@interface InfoController : UIViewController <MFMailComposeViewControllerDelegate>
{
    CGRect buttonFrame1;
    CGRect buttonFrame2;
    CGRect buttonFrame3;
    CGRect buttonFrame4;
    
    CGRect buttonText1;
    CGRect buttonText2;
    CGRect buttonText3;
    CGRect buttonText4;

    CGRect viewFrame;
}

@property (nonatomic, retain) PaperFoldSwipeHintView *ps;

-(void)legalButton;
-(void)callButton;
-(void)shareApp;
-(void)sendMail;
@end
