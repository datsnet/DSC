//
//  DoctorSocialClipAppDelegate.h
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "StyleSheet.h"


@class DoctorSocialClipViewController;

@interface DoctorSocialClipAppDelegate : UIResponder <UIApplicationDelegate, UISearchBarDelegate> {
    UIWindow*               _window;
    UINavigationController* _navigationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DoctorSocialClipViewController *viewController;

@end
