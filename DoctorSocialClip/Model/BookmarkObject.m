//
//  BookmarkObject.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "BookmarkObject.h"

@implementation BookmarkObject

@synthesize url  = _url;
@synthesize tag  = _tag;
@synthesize memo = _memo;
@synthesize user = _user;

-(void)dealloc {
    _url  = nil, [_url release];
    _tag  = nil, [_tag release];
    _memo = nil, [_memo release];
    _user = nil, [_user release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        _url  = [decoder decodeObjectForKey:@"url"];
        _tag  = [decoder decodeObjectForKey:@"tag"];
        _memo = [decoder decodeObjectForKey:@"memo"];
        _user = [decoder decodeObjectForKey:@"user"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_url forKey:@"url"];
    [encoder encodeObject:_tag forKey:@"tag"];
    [encoder encodeObject:_memo forKey:@"memo"];
    [encoder encodeObject:_user forKey:@"user"];
}

@end
