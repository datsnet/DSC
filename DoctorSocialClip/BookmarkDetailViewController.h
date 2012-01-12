//
//  BookmarkDetailViewController.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 12/01/05.
//  Copyright (c) 2012年 インターリンク株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkManager.h"
#import "LinkedLabel.h"
#import  <QuartzCore/QuartzCore.h>
@class DoctorSocialClipViewController;

@interface BookmarkDetailViewController : UIViewController<LinkedLabelDelegate> {
    IBOutlet UIButton    *buttonMemo;
    IBOutlet UITextView  *textMemo;
    DoctorSocialClipViewController *doctorSocialClipViewController;
}
@property (nonatomic, retain) NSArray *bookmarkArray;
@property (nonatomic, retain) DoctorSocialClipViewController *doctorSocialClipViewController;

@end
