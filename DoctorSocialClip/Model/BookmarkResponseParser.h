//
//  BookmarkResponseParser.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/22.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkManager.h"

enum {
    BookmarkNetworkStateNotConnected = 0, 
    BookmarkNetworkStateInProgress, 
    BookmarkNetworkStateFinished, 
    BookmarkNetworkStateError,
    BookmarkNetworkStateCanceled, 
};

//@class BookmarkItem;
//@class BookmarkChannel;

@interface BookmarkResponseParser : NSObject <NSXMLParserDelegate,UIAlertViewDelegate>
{
    NSString*           _feedUrlString;
    id                  _delegate; // Assign
    
    NSMutableString *_currentXpath;
    NSMutableArray *_bookmarks;
    NSMutableDictionary *_currentBookmark;
    NSMutableString *_textNodeCharacters;
    
}

// プロパティ
@property (nonatomic, assign) id delegate;

@property (retain , nonatomic) NSMutableString *currentXpath;
@property (retain , nonatomic) NSMutableArray *bookmarks;
@property (retain , nonatomic) NSMutableDictionary *currentBookmark;
@property (retain , nonatomic) NSMutableString *textNodeCharacters;


- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
- (void)showStatusAlert:(NSString *)alertTitle alertMessage:(NSString *)message;


@end

// デリゲートメソッド
@interface NSObject (BookmarkResponseParserDelegate)

- (void)parser:(BookmarkResponseParser*)parser didReceiveResponse:(NSURLResponse*)response;
- (void)parser:(BookmarkResponseParser*)parser didReceiveData:(NSData*)data;
- (void)parserDidFinishLoading:(BookmarkResponseParser*)parser;
- (void)parser:(BookmarkResponseParser*)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(BookmarkResponseParser*)parser;


@end
