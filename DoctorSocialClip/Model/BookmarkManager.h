//
//  BookmarkManager.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BookmarkObject.h"
#import "Singleton.h"
#import "HttpConnection.h"

@interface BookmarkManager : Singleton {
    NSMutableArray *_bookmarks;
    NSMutableDictionary *_bookmarkinfo;
}

@property (nonatomic, retain) NSMutableArray *bookmarks;
@property (nonatomic, retain) NSMutableDictionary *bookmarkinfo;

-(void)addBookmark:(UIViewController *)viewController;
-(void)deleteBookmark:(UIViewController *)viewController BookmarkId:(NSString *)bookmarkId;
-(id)add:(BookmarkObject*)bookmark;
-(BookmarkObject*)targetAtIndex:(NSInteger)index;
-(NSInteger)count;
-(NSArray *)getOneBookmarkinfo:(NSInteger)bokmarkId; // 指定した１つのブックマークを取得
-(NSMutableDictionary *)passBookmark;

@end
