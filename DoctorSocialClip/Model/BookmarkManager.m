//
//  BookmarkManager.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "BookmarkManager.h"

enum{
    MODE_ADD = 1, // 新規追加
    MODE_EDIT,    // 編集
    MODE_DELETE   // 削除
};

@implementation BookmarkManager

@synthesize bookmarks = _bookmarks, bookmarkinfo = _bookmarkinfo;
static NSString *FILE_NAME = @"bookmark.dat";

- (id)init {
    self = [super init];
    if (self != nil) {
        _bookmarks = [[NSMutableArray arrayWithCapacity:0] retain]; 
        _bookmarkinfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_bookmarks release], _bookmarks = nil;
    [_bookmarkinfo release], _bookmarkinfo = nil;
    [super dealloc];
}

- (NSMutableDictionary *)passBookmark
{
    return _bookmarkinfo;
}

// 指定した１つのブックマークを取得
- (NSArray *)getOneBookmarkinfo:(NSInteger)bookmarkId
{
    NSArray *someBookmarks= (NSArray *)_bookmarks;
    return [someBookmarks objectAtIndex:bookmarkId];
}

// ブックマークに追加
// xml形式でサーバに渡して登録
- (void)addBookmark:(UIViewController *)viewController
{
//    NSLog(@"bookmark INFO ---  %@", _bookmarkinfo);
    NSString *url = [_bookmarkinfo objectForKey:@"url"];
    NSString *title = [_bookmarkinfo objectForKey:@"title"];
    NSString *tag = [_bookmarkinfo objectForKey:@"tag"];
    NSString *memo = [_bookmarkinfo objectForKey:@"memo"];
        
    NSString *getString =
    [NSString stringWithFormat:
     @"xml_str=<?xml version='1.0' encoding='UTF-8' ?><bookmarks><bookmark><mode>%d</mode><url>%@</url><title>%@</title><tag>%@</tag><memo>%@</memo><user>test-user</user></bookmark></bookmarks>", MODE_ADD, url, title, tag, memo
     ];

    [[HttpConnection instance] sendPostRequest:getString viewController:viewController ModeNum:MODE_ADD];
}

// ブックマーク削除
// xml形式でサーバに渡して削除
- (void)deleteBookmark:(UIViewController *)viewController BookmarkId:(NSString *)bookmarkId
{  
    NSString *getString =
    [NSString stringWithFormat:
     @"xml_str=<?xml version='1.0' encoding='UTF-8' ?><bookmarks><bookmark><mode>%d</mode><id>%@</id></bookmark></bookmarks>", MODE_DELETE, bookmarkId
     ];
    
    [[HttpConnection instance] sendPostRequest:getString viewController:viewController ModeNum:MODE_DELETE];
}


- (id)add:(BookmarkObject*)bookmark {
    [_bookmarks addObject:bookmark];
    NSLog(@"BookmarkOBJ %@", bookmark);
    return self;
}

- (BookmarkObject*)targetAtIndex:(NSInteger)index {
    return [_bookmarks objectAtIndex:index];
}

- (NSInteger)count {
    return [_bookmarks count];
}

@end
