//
//  PocketActivity.m
//  PocketActivity
//
//  Created by Tanaka Katsuma on 2013/11/06.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "PocketActivity.h"

// PocketAPI
#import "PocketAPI.h"

@interface PocketActivity ()

@property (nonatomic, strong) NSURL *URL;

@end

@implementation PocketActivity

- (NSString *)activityType
{
    return @"com.getpocket.PocketActivity";
}

- (UIImage *)activityImage
{
    NSString *imageName = @"PocketActivityImage";
    
    // Check whether it runs on iOS 7 or not
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        imageName = [imageName stringByAppendingString:@"-iOS7"];
    }
    
    // Check whether it runs on iPhone or iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        imageName = [imageName stringByAppendingString:@"~iphone"];
    } else {
        imageName = [imageName stringByAppendingString:@"~ipad"];
    }
    
    return [UIImage imageNamed:imageName];
}

- (NSString *)activityTitle
{
    return @"Pocket";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    self.URL = nil;
    
    // Find URL object
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            self.URL = activityItem;
            return;
        }
    }
}

- (void)performActivity
{
    if (self.URL) {
        // Send to Pocket
        [[PocketAPI sharedAPI] saveURL:self.URL
                               handler:^(PocketAPI *API, NSURL *URL, NSError *error) {
                                   if (error) {
                                       // Delegate
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(pocketActivity:didFailToSaveURL:error:)]) {
                                           [self.delegate pocketActivity:self didFailToSaveURL:URL error:error];
                                       }
                                   } else {
                                       // Delegate
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(pocketActivity:didFinishSavingURL:)]) {
                                           [self.delegate pocketActivity:self didFinishSavingURL:URL];
                                       }
                                   }
                                   
                                   // Notifies the system that the activity has finished
                                   [self activityDidFinish:YES];
                               }];
    } else {
        // Notifies the system that the activity has finished
        [self activityDidFinish:YES];
    }
}


#pragma mark - Helper

+ (BOOL)isPocketInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pocket://"]];
}

- (void)openPocketOnAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/pocket-formerly-read-it-later/id309601447?mt=8"]];
}

@end
