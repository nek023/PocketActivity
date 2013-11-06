//
//  PocketActivity.h
//  PocketActivity
//
//  Created by Tanaka Katsuma on 2013/11/06.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PocketActivity;

@protocol PocketActivityDelegate <NSObject>

@optional
- (void)pocketActivity:(PocketActivity *)pocketActivity willStartSavingURL:(NSURL *)url;
- (void)pocketActivity:(PocketActivity *)pocketActivity didFinishSavingURL:(NSURL *)url;
- (void)pocketActivity:(PocketActivity *)pocketActivity didFailToSaveURL:(NSURL *)url error:(NSError *)error;

@end

@interface PocketActivity : UIActivity

@property (nonatomic, weak) id<PocketActivityDelegate> delegate;

+ (BOOL)isPocketInstalled;

@end
