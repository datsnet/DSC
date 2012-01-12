//
//  BookmarkAddViewController.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/26.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "DoctorSocialClipViewController.h"
#import  <QuartzCore/QuartzCore.h>

@interface BookmarkAddViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UILabel*           tagTitle;
    IBOutlet UILabel*           tagUrl;
    IBOutlet UILabel*           tagEntry;
    IBOutlet UILabel*           tagExplain;
    IBOutlet UITextField*       tagTextField;
    IBOutlet UITextView*        tagTextView;
    IBOutlet UINavigationBar*   navBar;
    IBOutlet UINavigationItem*  navItem;
    IBOutlet UIBarButtonItem*   cancelButton;
    IBOutlet UIBarButtonItem*   addBookmarkButton;
    IBOutlet UIScrollView*      scrollView;
    BOOL                        _observing;  // キーボード設定用
    NSString *_url;
    NSString *_bookmarkTitle;
    NSString *_tag;
    NSString *_memo;
    NSString *_user;
    
    UIActivityIndicatorView* _indicator;
}
@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSString* bookmarkTitle;
@property (nonatomic,retain) NSString* tag;
@property (nonatomic,retain) NSString* memo;
@property (nonatomic,retain) NSString* user;


- (IBAction)cancelAddBookmarkButtonTapped:(id)sender;
- (IBAction)addBookmarkButtonTapeed:(id)sender;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keybaordWillHide:(NSNotification*)notification;
- (void)doneDidPush;
- (BOOL)setBookmarkValue:(NSString*)url title:(NSString*)title;
- (void)setBookmarkInfoToManager;
- (void)showConfirmAlert;

@end
