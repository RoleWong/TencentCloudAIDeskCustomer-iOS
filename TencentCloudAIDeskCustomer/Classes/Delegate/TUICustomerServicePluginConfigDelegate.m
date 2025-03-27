//
//  TUICustomerServicePluginConfigDelegate.m
//  TUICustomer
//
//  Created by Role Wong on 8/15/24.
//

#import <Foundation/Foundation.h>
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginConfigDelegate.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import <TDeskCommon/TDesk_TIMDefine.h>

@implementation TUICustomerServicePluginDelegate

+ (instancetype)sharedInstance {
    static TUICustomerServicePluginDelegate *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSArray<TUICustomerServicePluginMenuCellData *> *)pluginConfig:(TUICustomerServicePluginConfig *)config shouldUpdateOldMenuItems:(NSArray *)oldItems {
    NSMutableArray *combinedItems = [NSMutableArray arrayWithArray:[self defaultMenuItems]];
    [combinedItems addObjectsFromArray:self.customMenuItems];
    return combinedItems;
}

#pragma mark - Private
- (NSArray *)defaultMenuItems {
    NSMutableArray *dataSource = [NSMutableArray new];
    
    TUICustomerServicePluginMenuCellData *toHuman = [TUICustomerServicePluginMenuCellData new];
    NSString *toHumanMsg = TDeskIMCommonLocalizableString(TUICustomerHumanService);
    toHuman.title = toHumanMsg;
    toHuman.icon = TUICustomerServicePluginBundleThemeImage(@"to_human_img", @"to_human");
    toHuman.onClick = ^{
        [TUICustomerServicePluginDataProvider sendTextMessage:toHumanMsg];
    };
    
    [dataSource addObject:toHuman];
    return [dataSource copy];
}

@end
