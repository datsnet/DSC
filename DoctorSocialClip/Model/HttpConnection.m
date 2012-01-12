//
//  HttpConnection.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/26.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "HttpConnection.h"

@implementation HttpConnection

enum{
    MODE_ADD = 1, // 新規追加
    MODE_EDIT,    // 編集
    MODE_DELETE   // 削除
};

// ステータスコード
NSInteger _statusCode;

@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
    [delegate release];
}

- (void)sendGetRequest:(NSString *)urlstr {
    NSString* webStringURL = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSLog(@"REQUEST %@", request);
    
    if (conn) {
        buffer = [[NSMutableData data] retain];
    } else {
        // error handling
        [self showStatusAlert:@"通信エラー" alertMessage:@"エラーが発生しました。後ほどやり直してください"];
    }
}

// POSTリクエスト
// 追加・編集・削除時
- (void)sendPostRequest:(NSString *)param viewController:(UIViewController *)viewController ModeNum:(NSInteger)modeNum  
{
    NSString *urlStr = @"http://interlink:interlink@docomo-doctor-social.karatto.info/setBookmark.php";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *myRequestData = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url]; 
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (conn) {
        buffer = [[NSMutableData data] retain];
        
        // 新規追加・編集・削除のモード指定
        switch (modeNum) {
            case MODE_ADD:
                _modeNum = MODE_ADD;
                break;
            case MODE_EDIT:
                _modeNum = MODE_EDIT;
                break;
            case MODE_DELETE:
                _modeNum = MODE_DELETE;
                break;
            default:
                break;
        }
        
        // インジケーターを表示させる
        _viewController = viewController;
        _indicator = [[[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        _indicator.frame = CGRectMake(0, 0, 50, 50);
        _indicator.center = _viewController.view.center;
        [viewController.view addSubview:_indicator];
        [_indicator startAnimating];
    } else {
        // error handling
        [self showStatusAlert:@"通信エラー" alertMessage:@"エラーが発生しました。後ほどやり直してください"];
    }
}

- (void)searchRequest:(NSString *)strSearchWord webview:(UIWebView *)webView
{
    NSURL *url = [NSURL URLWithString:strSearchWord];
    if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {
        // http://、 https://しか入力がなかった時
        if (![url host]) {
            NSLog(@"url host --- %@", [url host]);
            [self showStatusAlert:@"" alertMessage:@"検索ワード、または適切なURLを入力してください"];
            return;
        }
    } else {
        NSString *query = [[strSearchWord stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:
               [NSString stringWithFormat:@"http://www.google.co.jp/search?q=%@", query]];
    }

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSURLResponse *res = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    if (!data || error) {
        NSLog(@"failed to get data.");
        [self showStatusAlert:@"通信エラー" alertMessage:@"エラーが発生しました。後ほどやり直してください"];
        return;
    }
    
    [webView loadRequest:request];    
    [request release];
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res {
    NSHTTPURLResponse *hres = (NSHTTPURLResponse *)res;
    _statusCode = [hres statusCode];
    NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
    NSLog(@"Expected ContentLength: %qi", [hres expectedContentLength]);
    NSLog(@"MIMEType: %@", [hres MIMEType]);
    NSLog(@"Suggested File Name: %@", [hres suggestedFilename]);
    NSLog(@"Text Encoding Name: %@", [hres textEncodingName]);
    NSLog(@"URL: %@", [hres URL]);
    NSLog(@"Received Response. Status Code: %d", [hres statusCode]);
    NSLog(@"Response --- %@",[hres allHeaderFields]);
    NSDictionary *dict = [hres allHeaderFields];
    NSArray *keys = [dict allKeys];
    for (int i = 0; i < [keys count]; i++) {
        NSLog(@"    %@: %@",
              [keys objectAtIndex:i],
              [dict objectForKey:[keys objectAtIndex:i]]);
    }
    [buffer setLength:0];
}


- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData {
    [buffer appendData:receivedData];
    NSLog(@"receivedData %@", receivedData);
}


- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    [_indicator stopAnimating];
    [buffer release];
    [self showStatusAlert:@"" alertMessage:@"エラーが発生しました。後ほどやり直してください"];
    NSLog(@"Connection failed: %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSString *contents = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", contents);
    [_indicator stopAnimating];
    
    NSString *title;
    NSString *message;
    
    if (_statusCode == 200) {
    
        switch (_modeNum) {
            case MODE_ADD:
                title   = @"";
                message = @"登録に成功しました";
                break;
            case MODE_EDIT:
                title   = @"";
                message = @"登録に成功しました";
                break;
            case MODE_DELETE:
                title   = @"";
                message = @"削除に成功しました";
                
                // デリート成功時に表示されているテーブルセルも削除
                if( delegate != nil ) {
                    if( [delegate conformsToProtocol:@protocol(HttpConnectionDelegate)] ) {
                        ///関数の実装があるか
                        if( [delegate respondsToSelector:@selector(deleteSelectedRow)] ) {                        
                            [delegate deleteSelectedRow];
                        }
                    }
                }        
                break;
            default:
                break;
        }
    } else {
        title = @"";
        message = @"エラーが発生しました。後ほどやり直してください";
    }
    [self showStatusAlert:title alertMessage:message];
    
    [buffer release];
}

- (BOOL)deleteCheck
{
    return _deleteCheckFlg;
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
        if (_modeNum == MODE_ADD && _statusCode == 200) {
            [_viewController dismissModalViewControllerAnimated:YES];
        }
    }
}

@end
