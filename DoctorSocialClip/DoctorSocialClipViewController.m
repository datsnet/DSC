//
//  DoctorSocialClipViewController.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "DoctorSocialClipViewController.h"

@implementation DoctorSocialClipViewController
@synthesize urlField, webTitle, searchBar = _searchBar;

const int SHOW_MENU_SHEET_TAG = 1; // アクションシート識別用タグ　メニューボタン押下

- (void)dealloc {
    if ( _webView.loading ) [_webView stopLoading];
    _webView.delegate = nil; //< Appleのドキュメントにrelease前にこれが必要と記載されている
    [_webView release]; 
    [_reloadButton release]; 
    [_stopButton release]; 
    [_backButton release]; 
    [_forwardButton release]; 
    [urlField release];
    [webTitle release];
    [_searchBar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Searchバーの設定
    _searchBar = [[UISearchBar alloc] init];  
    _searchBar.delegate = self;  
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"";
    _searchBar.text = @"http://";
    self.navigationItem.titleView = _searchBar;  
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
    
    [_searchBar release];
    
    // ツールバーにボタンを追加
    _reloadButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(reloadDidPush)];
    _stopButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(stopDidPush)];
    _menuButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                      target:self 
                                      action:@selector(showMenuSheet)];
    
    _bookmarkButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks 
                                                  target:self 
                                                  action:@selector(showBookmark)];    
    
    _backButton =
    [[UIBarButtonItem alloc] initWithTitle:@"<"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(backDidPush)];
    _forwardButton =
    [[UIBarButtonItem alloc] initWithTitle:@">"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(forwardDidPush)];
    
    
    _flexibleSpace =           // ボタンスペース用
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray* buttons =
    [NSArray arrayWithObjects:_backButton,_flexibleSpace,_forwardButton,_flexibleSpace,_bookmarkButton,_flexibleSpace,_menuButton,_flexibleSpace,_reloadButton,_flexibleSpace,_stopButton, nil];
    [self setToolbarItems:buttons animated:YES];
    [self.navigationController setToolbarHidden:NO animated:NO];

    // UIWebViewの設定
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.frame = self.view.bounds;
    _webView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];

}

// Bookmarkリストを表示
- (void)showBookmark
{
    BookmarkViewController *bookmarkVC = [[BookmarkViewController alloc] init];
    bookmarkVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    bookmarkVC.delegate = self;
    bookmarkVC.doctorSocialClipViewController = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkVC];
    [self presentModalViewController:navigationController animated:YES];
    [bookmarkVC release];
}

// メニューリスト表示
- (void)showMenuSheet
{
    UIActionSheet* sheet = [[[UIActionSheet alloc] init] autorelease];
    sheet.delegate = self;
    sheet.tag = SHOW_MENU_SHEET_TAG;
    [sheet addButtonWithTitle:@"ブックマークに追加"];
    [sheet addButtonWithTitle:@"メニュー２"];
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = 2;
    [sheet showInView:self.view];
}

// 　メニュー表示
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SHOW_MENU_SHEET_TAG) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            NSLog(@"pushed cancel button");
        } else if (buttonIndex == 0) {
            NSString *url   = [[NSString alloc] initWithString:_searchBar.text];
            NSString *title = [[NSString alloc] initWithString:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
            
            BookmarkAddViewController *bookmarkAddVC = [[BookmarkAddViewController alloc] initWithNibName:@"BookmarkAddViewController" bundle:nil];
            if ([bookmarkAddVC setBookmarkValue:url  title:title]) {
                [self.navigationController presentModalViewController:bookmarkAddVC animated:YES];
                [bookmarkAddVC release];
            } else {
                // url取得失敗
                NSLog(@"URL取得に失敗しました。");
            }
        }
    }
    
}

- (void)changeUrlField:(NSString *)strUrl;
{
    _searchBar.text = strUrl;
    NSURL *url = [NSURL URLWithString:[_searchBar text]];    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

// webページ読み込み開始時
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    _searchBar.text = [url absoluteString];
    
    return YES;
}

// サーチバークリック時
- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar 
{
    [[HttpConnection instance] searchRequest:_searchBar.text webview:_webView];

    [activeSearchBar resignFirstResponder];
}


-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    [_searchBar resignFirstResponder];
}

// 戻る、進むボタンができない状態だったらボタンを灰色にして押せなくする
- (void)check 
{
	_backButton.enabled = _webView.canGoBack;
	_forwardButton.enabled = _webView.canGoForward;
}

- (void)reloadDidPush {
    [_webView reload]; //< ページの再読み込み
}

- (void)stopDidPush {
    if ( _webView.loading ) {
        [_webView stopLoading]; //< 読み込み中止
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } 
}

- (void)backDidPush {
    if ( _webView.canGoBack ) {
        [_webView goBack]; //< 前のページに戻る
    } 
}

- (void)forwardDidPush {
    if ( _webView.canGoForward ) {
        [_webView goForward]; //< 次のページに進む
    } 
}

- (void)updateControlEnabled {
    // インジケータやボタンの状態を一括で更新する
    [UIApplication sharedApplication].networkActivityIndicatorVisible = _webView.loading;
    _stopButton.enabled = _webView.loading;
    _backButton.enabled = _webView.canGoBack;
    _forwardButton.enabled = _webView.canGoForward;
}

- (void)viewWillDisappear:(BOOL)animated {
    // 画面を閉じるときにステータスバーのインジケータを確実にOFFにしておく
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView*)webView 
{
	[self check];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView 
{
	[self check];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
