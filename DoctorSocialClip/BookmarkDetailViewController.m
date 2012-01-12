//
//  BookmarkDetailViewController.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 12/01/05.
//  Copyright (c) 2012年 インターリンク株式会社. All rights reserved.
//

#import "BookmarkDetailViewController.h"
#import "DoctorSocialClipViewController.h"

@implementation BookmarkDetailViewController

@synthesize bookmarkArray;
@synthesize doctorSocialClipViewController;


- (void)dealloc
{
    [bookmarkArray release], bookmarkArray = nil;
    [doctorSocialClipViewController release], doctorSocialClipViewController = nil;
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
}

#pragma mark LinkedLabelDelegate
- (void) didTouchOn:(UILabel *)label
{
    //delegate method, called when the label is tapped
//    NSLog(@"[%d] %@",label.tag, label.text);
    NSLog(@"What was touched? is %@", label);

    if (!label.tag) {
        // タップしたURLに遷移
        [doctorSocialClipViewController changeUrlField:[bookmarkArray valueForKey:@"url"]];
    } else {
        // タグの遷移先（同タグに紐づいた一覧取得？）
        
    }

    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"BookmarkInfo %@", bookmarkArray);
    
    textMemo.text = [bookmarkArray valueForKey:@"memo"];
    // textview設定
    textMemo.layer.borderWidth = 1;
    textMemo.layer.cornerRadius = 8; 
    textMemo.layer.borderColor = [[UIColor grayColor] CGColor];    
    
    //　タイトル表示設定
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 20)];
    lblTitle.text = [bookmarkArray valueForKey:@"title"];
    [self.view addSubview:lblTitle];
    [lblTitle release];

    // URL表示設定
    LinkedLabel *lblUrl = [[LinkedLabel alloc] initWithOrigin:CGPointMake(10, 50)
                                                           text:[bookmarkArray valueForKey:@"url"]
                                                           font:[UIFont systemFontOfSize:14.f]];
    [self.view addSubview:lblUrl];
    lblUrl.delegate = self;
    [lblUrl release];
    
    // タグ表示設定
//    NSLog(@"bookmark tag count %@", [bookmarkArray valueForKey:@"tag"]);
    if ([[bookmarkArray valueForKey:@"tag"] length] > 0) {
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320, 20)];
        tagLabel.text = @"タグ";
        [self.view addSubview:tagLabel];
        [tagLabel release];

        // スペース区切りのタグを抽出
        NSArray *separatedArray = [[bookmarkArray valueForKey:@"tag"] componentsSeparatedByString:@" "];
        NSLog(@"separated Array %@", separatedArray);
        for (int i = 0; i < [separatedArray count]; i++) {
            LinkedLabel *lblTags = [[LinkedLabel alloc] initWithOrigin:CGPointMake(10 + (i * 50), 100)
                                                                  text:[separatedArray objectAtIndex:i]
                                                                  font:[UIFont systemFontOfSize:14.f]];
            lblTags.tag = i;
            lblTags.delegate = self;
            [self.view addSubview:lblTags];
            [lblTags release];
        }

    }
    

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
