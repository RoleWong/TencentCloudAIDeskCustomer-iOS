//
//  TencentCloudCustomerConfigManager.m
//  AFNetworking
//
//  Created by Role Wong on 8/12/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerManager.h"
#import <TDeskCore/TDesk_TUILogin.h>
#import "TUICustomerServicePluginPrivateConfig.h"
#import <TDeskChat/TDesk_TUIC2CChatViewController.h>
#import "TUICustomerServicePluginDataProvider.h"
#import "TDeskCore/TDesk_TUIThemeManager.h"
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginProductInfo.h"
#import "TDeskChat/TDesk_TUIChatConfig.h"
#import "TencentCloudAIDeskCustomer/TencentCloudCustomerLoggerObjC.h"
#import "TUICustomerServicePluginConfigDelegate.h"

@implementation TencentCloudCustomerManager

+ (instancetype)sharedManager {
    static TencentCloudCustomerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)loginWithSdkAppID:(int)sdkAppId userID:(NSString *)userID userSig:(NSString *)userSig completion:(void(^)(NSError *error))completion {
    
    OTSpan *loginSpan = [TencentCloudCustomerLoggerObjC.sharedLoggerManager reportLogin:sdkAppId userID:userID userSig:userSig];
    
    [self initUIKit];
    
    [TDeskLogin login:sdkAppId userID:userID userSig:userSig succ:^{
        NSLog(@"登录成功");
        [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:@"login success"];
        completion(nil);
        [loginSpan end];
    } fail:^(int code, NSString *msg) {
        [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"login error:%@",msg]];
        [loginSpan end];
        NSError *error = [NSError errorWithDomain:@"com.tencent.qcloud.customeruikit"
                                                 code:code
                                             userInfo:msg ? @{NSLocalizedDescriptionKey: msg} : nil];
        completion(error);
    }];
}

- (void)setCustomerServiceUserID:(NSString *)userID{
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"setCustomerServiceUserID:%@",userID]];
    NSArray *customerServiceUserID = @[userID];
    cusomterServiceConfig.customerServiceAccounts = customerServiceUserID;
}

- (TDeskBaseChatViewController *) getCustomerServiceViewController{
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:@"getCustomerServiceViewController"];
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    TDeskChatConversationModel *conversationData = [[TDeskChatConversationModel alloc] init];
    conversationData.userID = cusomterServiceConfig.customerServiceAccounts.firstObject;
    conversationData.conversationID = [NSString stringWithFormat:@"c2c_%@", conversationData.userID];

    TDeskBaseChatViewController *chatVC = nil;
    chatVC = [[TDeskC2CChatViewController alloc] init];
    chatVC.conversationData = conversationData;
    
    return chatVC;
}

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:@"pushToCustomerServiceViewControllerFromController"];
    [controller.navigationController pushViewController:[self getCustomerServiceViewController] animated:YES];
}

- (void)presentCustomerServiceViewControllerFromController:(UIViewController *)controller {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:@"presentCustomerServiceViewControllerFromController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self getCustomerServiceViewController]];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [controller presentViewController:navController animated:YES completion:nil];
}

- (void) applyTheme: (NSString *)themeID {
    NSBundle *customerBundle = [NSBundle bundleForClass:[self class]];
    NSString *customerThemePath = [customerBundle pathForResource:@"TencentCloudAIDeskCustomerTheme.bundle" ofType:nil];
    
    TDeskRegisterThemeResourcePath(customerThemePath, TUIThemeModuleChat);
    [TDeskShareThemeManager applyTheme:themeID forModule:TUIThemeModuleChat];
    
    TDeskRegisterThemeResourcePath(customerThemePath, TUIThemeModuleCustomerService);
    [TDeskShareThemeManager applyTheme:themeID forModule:TUIThemeModuleCustomerService];
    
    [TDeskShareThemeManager applyTheme:@"light" forModule:TUIThemeModuleTIMCommon];
}

- (void)setQuickMessages:(NSArray<TUICustomerServicePluginMenuCellData *> *)menuItems{
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"setQuickMessages:%lu",menuItems.count]];
    [TUICustomerServicePluginDelegate sharedInstance].customMenuItems = menuItems;
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

- (void)setShowHumanService:(BOOL)show {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"setShowHumanService:%@", show ? @"YES" : @"NO"]];
    
    TUICustomerServicePluginPrivateConfig *privateConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    privateConfig.enableShowHumanService = show;
    
    if (!show) {
        [TUICustomerServicePluginConfig sharedInstance].showHumanServiceMenuItem = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TUICustomerServiceMenuItemUpdatedNotification" object:nil];
    }
}

- (void)setShowServiceRating:(BOOL)show {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"setShowServiceRating:%@", show ? @"YES" : @"NO"]];
    
    TUICustomerServicePluginPrivateConfig *privateConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    privateConfig.enableShowServiceRating = show;
    
    if (!show) {
        [TUICustomerServicePluginConfig sharedInstance].showServiceRatingMenuItem = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TUICustomerServiceMenuItemUpdatedNotification" object:nil];
    }
}

- (void)setShowEndHumanService:(BOOL)show {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"setShowEndHumanService:%@", show ? @"YES" : @"NO"]];
    
    TUICustomerServicePluginPrivateConfig *privateConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    privateConfig.enableShowEndHumanService = show;
    
    if (!show) {
        [TUICustomerServicePluginConfig sharedInstance].showEndHumanServiceMenuItem = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TUICustomerServiceMenuItemUpdatedNotification" object:nil];
    }
}

- (void)callExperimentalAPI:(NSString *)api param:(NSObject *)param {
    [TencentCloudCustomerLoggerObjC.sharedLoggerManager logInfo:[NSString stringWithFormat:@"callExperimentalAPI:%@",api]];
    [[V2TIMManager sharedInstance] callExperimentalAPI:api param:param succ:^(NSObject *result) {
        NSLog(@"setTestEnvironment succ");
    } fail:^(int code, NSString *desc) {
        NSLog(@"setTestEnvironment fail");
    }];
}

- (void) initUIKit{
    [self applyTheme:@"customer_light"];
    [TDeskMessageCellLayout incommingMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingImageMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingImageMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingVideoMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingVideoMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingVoiceMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingVoiceMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskChatConfig defaultConfig].enablePopMenuReplyAction = NO;
    [TDeskChatConfig defaultConfig].enablePopMenuEmojiReactAction = NO;
    
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

@end
