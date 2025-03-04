
# TencentCloudAIDeskCustomer

[![CI Status](https://img.shields.io/travis/24520036/TencentCloudAIDeskCustomer.svg?style=flat)](https://travis-ci.org/24520036/TencentCloudAIDeskCustomer)
[![Version](https://img.shields.io/cocoapods/v/TencentCloudAIDeskCustomer.svg?style=flat)](https://cocoapods.org/pods/TencentCloudAIDeskCustomer)
[![License](https://img.shields.io/cocoapods/l/TencentCloudAIDeskCustomer.svg?style=flat)](https://cocoapods.org/pods/TencentCloudAIDeskCustomer)
[![Platform](https://img.shields.io/cocoapods/p/TencentCloudAIDeskCustomer.svg?style=flat)](https://cocoapods.org/pods/TencentCloudAIDeskCustomer)


**Tencent Cloud Desk Customer UIKit** is a UIKit Framework for integrating AI-powered customer service chat on the customer side of Tencent Cloud Desk, providing efficient and seamless communication with both AI and human agents.


Follow the steps below to integrate and use the framework.

### Step 1: Add to Your Project

To integrate **TencentCloudAIDeskCustomer** into your project, add the following line to your `Podfile`:

```ruby
pod 'TencentCloudAIDeskCustomer'
```

Then, run the following command to install the pod:

```bash
pod install
```

### Step 2: Logging In and Setting Customer Service User ID

Before using the customer service feature, you need to log in and set the customer service user ID. You can do this at any point before initiating a customer service chat.

Add the following code at the appropriate point in your app’s lifecycle:

```objc
- (void)login:(NSString *)userID userSig:(NSString *)sig {
    [[TencentCloudCustomerManager sharedManager] loginWithSdkAppID:public_SDKAPPID userID:userID userSig:sig completion:^(NSError *error) {
        if (!error) {
            // Set customer service user ID after login
            [[TencentCloudCustomerManager sharedManager] setCustomerServiceUserID:CUSTOMER_SERVICE_USER_ID];
        }
    }];
}
```

You can find more details about generating a `UserSig` in [this documentation](https://www.tencentcloud.com/document/product/1047/34385).

### Step 3: Initiating the Customer Service Chat

Once you have logged in and set the customer service user ID, you can easily open the customer service page from any view controller.

Here’s an example of how to add a button to open the customer service chat:

```objc
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a button to start customer service chat
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Customer Service" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

// Action to initiate the customer service chat
- (void)chatButtonTapped {
    [[TencentCloudCustomerManager sharedManager] pushToCustomerServiceViewControllerFromController:self];
}

@end
```

### Summary

- **Add TencentCloudAIDeskCustomer to your project** via CocoaPods.
- **Log in** with your `userID` and `UserSig`, then set the `CUSTOMER_SERVICE_USER_ID`.
- **Open the customer service page** from any view controller using `pushToCustomerServiceViewControllerFromController:`.


### Learn More

For comprehensive documentation, visit the [**Tencent Cloud Desk Documentation**](https://www.tencentcloud.com/document/product/1047/63268).
