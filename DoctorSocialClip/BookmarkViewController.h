//
//  BookmarkViewController.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkManager.h"
#import "BookmarkResponseParser.h"
#import "BookmarkDetailViewController.h"

@class DoctorSocialClipViewController;
@class HttpConnection;
@protocol BookmarkViewDelegate <NSObject>

// ブックマークリストからブックマークを選択
// サーチバーにブックマークURLを通知
- (void)changeUrlField:(NSString *)setUrl;

@end

@interface BookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpConnectionDelegate> {
    NSMutableDictionary *bookmarks;
    NSMutableArray *websitetitle;
    DoctorSocialClipViewController *doctorSocialClipViewController;
    IBOutlet UITableView *tableview;
}

@property (nonatomic, retain) NSMutableDictionary *bookmarks;
@property (nonatomic, retain) NSMutableArray *websitetitle;
@property (nonatomic, retain) DoctorSocialClipViewController *doctorSocialClipViewController;
@property (nonatomic, assign) id<BookmarkViewDelegate> delegate;
- (void)cancelButtonTapped;
- (void)closeButtonTapped:(id)sender;
- (void)editButtonTapped:(id)sender;
- (void)buttonDidPushDone:(UIBarButtonItem*)button;
@end
