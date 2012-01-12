//
//  DoctorSocialClipAppDelegate.m
//  DoctorSocialClip
//
//  Created by インターリンク インターリンク on 11/12/21.
//  Copyright (c) 2011年 インターリンク株式会社. All rights reserved.
//

#import "DoctorSocialClipAppDelegate.h"

#import "DoctorSocialClipViewController.h"

@implementation DoctorSocialClipAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.window = self.window;
    
    [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[TTWebController class]];
    [map from:@"tt://root" toViewController:NSClassFromString(@"DoctorSocialClipViewController")];
    [map from:@"tt://nib/(loadFromNib:)" toSharedViewController:self];
    [map from:@"tt://nib/(loadFromNib:)/(withClass:)" toSharedViewController:self];
    [map from:@"tt://viewController/(loadFromVC:)" toSharedViewController:self];
    [map from:@"tt://modal/(loadFromNib:)" toModalViewController:self];
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://root"]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_navigationController);
    TT_RELEASE_SAFELY(_window);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];
    [newController autorelease];
    
    return newController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Loads the given viewcontroller from the the nib with the same name as the
 * class
 */
- (UIViewController*)loadFromNib:(NSString*)className {
    return [self loadFromNib:className withClass:className];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Loads the given viewcontroller by name
 */
- (UIViewController *)loadFromVC:(NSString *)className {
    UIViewController * newController = [[ NSClassFromString(className) alloc] init];
    [newController autorelease];
    
    return newController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}
@end