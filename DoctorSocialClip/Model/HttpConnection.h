//
//  HttpConnection.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/26.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
//#import "BookmarkViewController.h"
@class BookmarkViewController;
@protocol HttpConnectionDelegate <NSObject>

// ブックマークリストからブックマークを選択
// サーチバーにブックマークURLを通知
- (void)deleteSelectedRow;

@end


@interface HttpConnection : Singleton<NSURLConnectionDelegate, UIAlertViewDelegate>
{
    NSMutableData*   buffer;
    UIActivityIndicatorView *_indicator;
    UIViewController* _viewController;
    NSInteger   _modeNum;
    BOOL    _deleteCheckFlg;
}

@property (nonatomic, assign) id<HttpConnectionDelegate> delegate;

- (void)sendGetRequest:(NSString *)urlstr;
- (void)sendPostRequest:(NSString *)param viewController:(UIViewController *)viewController ModeNum:(NSInteger)modeNum;
- (void)showStatusAlert:(NSString *)alertTitle alertMessage:(NSString *)message;
- (BOOL)deleteCheck;
- (void)searchRequest:(NSString*)strSearchWord webview:(UIWebView*)webView;

@end
