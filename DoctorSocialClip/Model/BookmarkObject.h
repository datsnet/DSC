//
//  BookmarkObject.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface BookmarkObject : Singleton <NSCoding> {
    NSString *_url;
    NSString *_tag;
    NSString *_memo;
    NSString *_user;
}

@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSString* tag;
@property (nonatomic,retain) NSString* memo;
@property (nonatomic,retain) NSString* user;

@end
