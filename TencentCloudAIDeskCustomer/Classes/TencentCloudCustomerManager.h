//
//  TencentCloudCustomerManager.h
//  Pods
//
//  Created by Role Wong on 8/12/24.
//

#ifndef TUICustomerManager_h
#define TUICustomerManager_h

#import "TUICustomerServicePluginMenuView.h"
#import <TDeskChat/TDesk_TUIBaseChatViewController.h>

@interface TencentCloudCustomerManager : NSObject

+ (instancetype) sharedManager;

- (void)loginWithSdkAppID:(int) sdkAppId userID: (NSString *) userID userSig: (NSString *) userSig completion:(void(^)(NSError *error))completion;

- (void)setCustomerServiceUserID:(NSString *)userID;

- (TDeskBaseChatViewController *) getCustomerServiceViewController;

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller;

- (void)presentCustomerServiceViewControllerFromController:(UIViewController *)controller;

- (void)applyTheme: (NSString *)themeID;

- (void)setQuickMessages:(NSArray<TUICustomerServicePluginMenuCellData *> *)menuItems;

- (void)setShowHumanService:(BOOL)show;

- (void)setShowServiceRating:(BOOL)show;

- (void)setShowEndHumanService:(BOOL)show;

- (void)callExperimentalAPI:(NSString *)api param:(NSObject *)param;
 
@end


#endif /* TUICustomerManager_h */
