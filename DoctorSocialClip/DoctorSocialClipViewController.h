//
//  DoctorSocialClipViewController.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkViewController.h"
#import "BookmarkManager.h"
#import "BookmarkAddViewController.h"

@interface DoctorSocialClipViewController : UIViewController<UINavigationControllerDelegate, UIWebViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, BookmarkViewDelegate, UIAlertViewDelegate> {
    UIWebView*   _webView;
    UISearchBar* _searchBar;
    
    UIBarButtonItem* _reloadButton;
    UIBarButtonItem* _stopButton;
    UIBarButtonItem* _backButton;
    UIBarButtonItem* _forwardButton;
    UIBarButtonItem* _menuButton;
    UIBarButtonItem* _bookmarkButton;
    UIBarButtonItem* _flexibleSpace;
}

@property (nonatomic, retain) UITextField *urlField;
@property (nonatomic, retain) NSString    *webTitle;
@property (nonatomic, retain) UISearchBar* searchBar;

- (void)showMenuSheet;
- (void)check;
- (void)reloadDidPush;
- (void)stopDidPush;
- (void)backDidPush;
- (void)forwardDidPush;
- (void)updateControlEnabled;
- (void)showBookmark;

@end
