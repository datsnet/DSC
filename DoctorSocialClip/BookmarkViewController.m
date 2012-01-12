//
//  BookmarkViewController.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "BookmarkViewController.h"
#import "DoctorSocialClipViewController.h"

@implementation BookmarkViewController

@synthesize bookmarks=_bookmarks, websitetitle=_websitetitle, doctorSocialClipViewController,delegate;

UITableView *_tableView;
UITableViewCellEditingStyle _editingStyle;
NSIndexPath *_indexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"first view %@", doctorSocialClipViewController);

    // ナビゲーション設定
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" 
                                                                   style:UIBarButtonItemStyleDone 
                                                                  target:self 
                                                                  action:@selector(closeButtonTapped:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    self.navigationItem.title = @"ブックマーク";
    
    // ツールバー設定
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    NSArray *toolbarButtons = [NSArray arrayWithObjects:editButton, nil];
    self.navigationController.toolbarHidden = NO;
    [self setToolbarItems:toolbarButtons];
    
    
    // xmlからブックマーク情報取得
    BookmarkResponseParser *bookmarkResponseParser = [[BookmarkResponseParser alloc] init];

    NSURL *url = [[NSURL URLWithString:@"http://interlink:interlink@docomo-doctor-social.karatto.info/getBookmark.php?mode=2"] autorelease];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    
    
    // 仮にxmlファイルから読ませる
    // アプリにtest.xmlが含まれているとする
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"];
//    NSURL *url = [NSURL fileURLWithPath:path];

    NSError *parseError = nil;
    
    [bookmarkResponseParser parseXMLFileAtURL:url parseError:&parseError];
    NSLog(@"ERRROR --- %@", parseError);
}


- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)editButtonTapped:(id)sender
{
    [tableview setEditing:YES animated:YES];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                            target:self 
                                                            action:@selector(buttonDidPushDone:)] autorelease];
    NSArray *items = [[[NSArray alloc] initWithObjects:doneButton, nil] autorelease];
    [self.navigationController.toolbar setItems:items];

}

// 編集完了ボタン押下
- (void)buttonDidPushDone:(UIBarButtonItem*)button
{
    [tableview setEditing:NO animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    NSArray *toolbarButtons = [NSArray arrayWithObjects:editButton, nil];
    self.navigationController.toolbarHidden = NO;
    [self setToolbarItems:toolbarButtons];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[[BookmarkManager instance] bookmarks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *cellIdentifier = @"Cell";
    websitetitle = [[BookmarkManager instance] bookmarks];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }

    bookmarks = (NSMutableDictionary*)[websitetitle objectAtIndex:indexPath.row];
    cell.textLabel.text = [bookmarks objectForKey:@"title"];
    cell.detailTextLabel.text = [bookmarks objectForKey:@"memo"];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    NSLog(@"detailTextLabel %@", [bookmarks objectForKey:@"memo"]);
    
    return cell;
}

// 詳細ページへ遷移
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"detail was tapped");
//        NSLog(@"BookmarkInfo %@", [[BookmarkManager instance] bookmarks]);
    BookmarkDetailViewController *bookmarkDetailVC = [[BookmarkDetailViewController alloc] initWithNibName:@"BookmarkDetailViewController" bundle:nil];
    NSLog(@"doctorSocialClipViewController from Bookmark View Controller -- %@", doctorSocialClipViewController);
    bookmarkDetailVC.doctorSocialClipViewController = doctorSocialClipViewController;
    bookmarkDetailVC.bookmarkArray = [[BookmarkManager instance] getOneBookmarkinfo:indexPath.row];
    [self.navigationController pushViewController:bookmarkDetailVC animated:YES];
    [bookmarkDetailVC release];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if( delegate != nil )
	{
		if( [delegate conformsToProtocol:@protocol(BookmarkViewDelegate)] )
		{
			///関数の実装があるか
			if( [delegate respondsToSelector:@selector(changeUrlField:)] )
			{
                NSMutableArray *array = [[BookmarkManager instance] bookmarks];

                NSMutableDictionary *url = [array objectAtIndex:indexPath.row];
                NSString *strUrl = [url objectForKey:@"url"];

                [delegate changeUrlField:strUrl];
                [self dismissModalViewControllerAnimated:YES];
			}
		}
	}
    
    [doctorSocialClipViewController textFieldShouldReturn:doctorSocialClipViewController.urlField];
    [self.parentViewController dismissModalViewControllerAnimated:true];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // テーブルセルの削除を別メソッドで行うため、情報を格納
    _tableView    = [tableView retain];
    _editingStyle = editingStyle;
    _indexPath    = [indexPath retain];
    
    // delete処理開始
    [[BookmarkManager instance] deleteBookmark:self BookmarkId:[[websitetitle objectAtIndex:indexPath.row] objectForKey:@"id"]];
    HttpConnection *httpConnection = [HttpConnection instance];
    httpConnection.delegate = self;
}

// HttpConnectionのデリゲートメソッド
- (void)deleteSelectedRow
{
    // サーバからブックマークの削除が行えた場合紐付くテーブルセルを削除
    if (_editingStyle == UITableViewCellEditingStyleDelete) {
        [websitetitle removeObjectAtIndex:_indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:_indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView release];
        [_indexPath release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    // e.g. self.myOutlet = nil;
    [doctorSocialClipViewController release];
    doctorSocialClipViewController = nil;
    [bookmarks release], bookmarks = nil;
}

@end
