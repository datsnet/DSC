//
//  BookmarkResponseParser.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/22.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

//#import "BookmarkItem.h"
//#import "BookmarkChannel.h"
#import "BookmarkResponseParser.h"


@implementation BookmarkResponseParser

// プロパティ
@synthesize delegate = _delegate;

@synthesize currentXpath = _currentXpath;
@synthesize bookmarks = _bookmarks;
@synthesize currentBookmark = _currentBookmark;
@synthesize textNodeCharacters = _textNodeCharacters;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
        
    return self;
}

- (void)dealloc
{
    // インスタンス変数を解放する
    _delegate = nil;
    [_currentXpath release], _currentXpath = nil;
    [_bookmarks release], _bookmarks = nil;
    [_currentBookmark release], _currentBookmark = nil;
    [_textNodeCharacters release], _textNodeCharacters = nil;

    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- パース --
//--------------------------------------------------------------//

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{
    NSLog(@"URL %@", URL);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    NSError *parseError = [parser parserError];  
    if (parseError && error) {  
        *error = parseError;
        NSLog(@"error --- %@", parseError);
        [self showStatusAlert:@"通信失敗" alertMessage:@"ブックマークを取得できませんでした"];
    }  

    [[BookmarkManager instance] setBookmarks:self.bookmarks];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
                                        namespaceURI:(NSString *)namespaceURI 
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict
{

    [self.currentXpath appendString: elementName];
    [self.currentXpath appendString: @"/"];
    
    self.textNodeCharacters = [[[NSMutableString alloc] init] autorelease];
    
    if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/"]) {
        self.currentBookmark = [[[NSMutableDictionary alloc] init] autorelease];
    }

}  

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    self.currentXpath = [[[NSMutableString alloc]init] autorelease];
    self.bookmarks = [[[NSMutableArray alloc] init] autorelease];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName  
{
    NSString *textData = [self.textNodeCharacters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/"]) {
        [self.bookmarks addObject:self.currentBookmark];
        self.currentBookmark = nil;
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/id/"]) {
        [self.currentBookmark setValue:textData forKey:@"id"];
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/url/"]) {
        [self.currentBookmark setValue:textData forKey:@"url"];
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/title/"]) {
        [self.currentBookmark setValue:textData forKey:@"title"];
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/tag/"]) {
        [self.currentBookmark setValue:textData forKey:@"tag"];
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/memo/"]) {
        [self.currentBookmark setValue:textData forKey:@"memo"];
    } else if ([self.currentXpath isEqualToString: @"bookmarks/bookmark/user/"]) {
        [self.currentBookmark setValue:textData forKey:@"user"];
    }

    int delLength = [elementName length] + 1;
    int delIndex = [self.currentXpath length] - delLength;
    
    [self.currentXpath deleteCharactersInRange:NSMakeRange(delIndex,delLength)];
}  

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string  
{  
    [self.textNodeCharacters appendString:string];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [_bookmarks release], _bookmarks = nil;
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    [_bookmarks release], _bookmarks = nil;
}

// 通信終了時アラート表示
- (void)showStatusAlert:(NSString *)alertTitle alertMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

// アラートビューボタン押下
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {

    }
}

@end
