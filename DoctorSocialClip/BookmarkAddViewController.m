//
//  BookmarkAddViewController.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/26.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "BookmarkAddViewController.h"

@implementation BookmarkAddViewController

@synthesize url  = _url;
@synthesize bookmarkTitle = _bookmarkTitle;
@synthesize tag  = _tag;
@synthesize memo = _memo;
@synthesize user = _user;

const int CONFIRM_ALERT_TAG = 1; // アラートビュー識別用タグ　登録ボタン押下

BOOL _textFieldFlg; // テキストフィールドとテキストビューを見分けるためのフラグ

- (void)dealloc {

    [tagEntry release];
    [tagExplain release];
    [tagTextField release];
    [tagTextView release];
    [navBar release];
    [navItem release];
    [cancelButton release];
    [addBookmarkButton release];
    [scrollView release];
    _url  = nil, [_url release];
    _bookmarkTitle = nil, [_bookmarkTitle release];
    _tag  = nil, [_tag release];
    _memo = nil, [_memo release];
    _user = nil, [_user release];

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // タイトル設定
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"このページをクリップする";
	[label setFont:[UIFont boldSystemFontOfSize:12.0]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor whiteColor]];
    navItem.titleView = label;
	[label release];
    
    // textview設定
    tagTextView.layer.borderWidth = 1;
    tagTextView.layer.cornerRadius = 8; 
    tagTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    

    // ビューのスクロール範囲を設定
    [scrollView setContentSize:self.view.frame.size];
    [scrollView flashScrollIndicators];
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = NO;
    
    // ブックマーク対象ページタイトルを設定
    tagTitle.text = _bookmarkTitle;
    tagUrl.text   = _url;

}

- (void)viewWillAppear:(BOOL)animated
{
    // super
    [super viewWillAppear:animated];
    
    // Start observing
    if (!_observing) {
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(keyboardWillShow:)
                       name:UIKeyboardWillShowNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(keybaordWillHide:)
                       name:UIKeyboardWillHideNotification
                     object:nil];
        
        _observing = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // super
    [super viewWillDisappear:animated];
    
    // Stop observing
    if (_observing) {
        NSNotificationCenter *center;
        center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self
                          name:UIKeyboardWillShowNotification
                        object:nil];
        [center removeObserver:self
                          name:UIKeyboardWillHideNotification
                        object:nil];
        
        _observing = NO;
    }
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSLog(@"textfieldFlg = %d", _textFieldFlg);
    if (!_textFieldFlg) {
        // Get userInfo
        NSDictionary *userInfo;
        userInfo = [notification userInfo];
    
        // Calc overlap of keyboardFrame and textViewFrame
        CGFloat overlap;
        CGRect keyboardFrame;
        CGRect textViewFrame;
        keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardFrame = [scrollView.superview convertRect:keyboardFrame fromView:nil];
        textViewFrame = tagTextView.frame;
        overlap = MAX(0.0f, CGRectGetMaxY(textViewFrame) - CGRectGetMinY(keyboardFrame));
    
        // Calc insets of scrollView
        UIEdgeInsets insets;
        insets = UIEdgeInsetsMake(0.0f, 0.0f, overlap, 0.0f);
    
        // Animate insets of scrollView
        NSTimeInterval duration;
        UIViewAnimationCurve animationCurve;
        void (^animations)(void);
        duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        animations = ^(void) {
            // Set insets of scrollView
            scrollView.contentInset = insets;
            scrollView.scrollIndicatorInsets = insets;
        };
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:animations
                         completion:nil];
    
        // Scroll to bottom
        CGRect rect;
        rect.origin.x = 0.0f;
        rect.origin.y = scrollView.contentSize.height - 1.0f;
        rect.size.width = CGRectGetWidth(scrollView.frame);
        rect.size.height = 1.0f;
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

- (void)keybaordWillHide:(NSNotification*)notification
{
    if (!_textFieldFlg) {
        // Get userInfo
        NSDictionary *userInfo;
        userInfo = [notification userInfo];
    
        // Animate insets of scrollView
        NSTimeInterval duration;
        UIViewAnimationCurve animationCurve;
        void (^animations)(void);
        duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        animations = ^(void) {
            // Set insets of scrollView
            scrollView.contentInset = UIEdgeInsetsZero;
            scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
        };
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:animations
                         completion:nil];
        } else {
            _textFieldFlg = NO;
        }
}

// textView編集時にナビゲーションバーにdoneボタン追加
- (void)textViewDidBeginEditing:(UITextView *)textView 
{
    navItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidPush)] autorelease];
}

// 編集終了時doneボタン削除
- (void)textViewDidEndEditing:(UITextView *)textView
{
    navItem.rightBarButtonItem = nil;
    navItem.rightBarButtonItem = addBookmarkButton;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    // テキストビュー押下と画面位置が連動して動いてしまうため、テキストフィールドだけ動けなくするフラグをたてる
    return _textFieldFlg = YES;
}

// textView編集ボタン押下
- (void)doneDidPush
{
    [tagTextView resignFirstResponder];
}

// 画面を閉じる
- (IBAction)cancelAddBookmarkButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// ブックマーク登録ボタン押下
- (void)showConfirmAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"確認" message:@"登録してもよろしいでしょうか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    alertView.tag = CONFIRM_ALERT_TAG;
    [alertView show];
    [alertView release];
}

// アラートビューボタン押下
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CONFIRM_ALERT_TAG) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            NSLog(@"pushed cancel button");
        } else if (buttonIndex == 1) {
            _tag  = tagTextField.text;
            _memo = tagTextView.text;
            
            [self setBookmarkInfoToManager];
        }
    }
}

// 登録処理開始
- (IBAction)addBookmarkButtonTapeed:(id)sender
{
    [self showConfirmAlert];
}

- (BOOL)setBookmarkValue:(NSString*)url title:(NSString*)title
{
    if (url) {
        _url   = url;
        
        if(title == nil || [title isEqualToString:@""]) { 
            _bookmarkTitle = nil;
        } else {
            _bookmarkTitle = title;
        }
        
        return true;
    }
    return false;
}

- (void)setBookmarkInfoToManager
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] 
                                 initWithObjectsAndKeys:
                                _url, @"url",
                              _bookmarkTitle, @"title",
                                _tag, @"tag",
                               _memo, @"memo", nil];
        
    [[BookmarkManager instance] setBookmarkinfo:info];
    [[BookmarkManager instance] addBookmark:self];
}

// textfieldキーボードを閉じる
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Hide keyboard
    [textField resignFirstResponder];
    
    return YES;
}

// textviewキーボード閉じるボタン押下
-(void)closeKeyboard:(id)sender{
    [tagTextView resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
