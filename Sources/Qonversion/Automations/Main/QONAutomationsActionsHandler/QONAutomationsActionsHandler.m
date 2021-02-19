//
//  QONAutomationsActionsHandler.m
//  Qonversion
//
//  Created by Surik Sarkisyan on 23.09.2020.
//  Copyright © 2020 Qonversion Inc. All rights reserved.
//

#import "QONAutomationsActionsHandler.h"
#import "QONActionResult.h"
#if !TARGET_OS_TV
#import <WebKit/WebKit.h>
#endif

static NSString *const kQonversionSchemeRegEx = @"^(qon-)\\w";
static NSString *const kAutomationsHost = @"automation";
static NSString *const kActionHost = @"action";

static NSString *const kLinkAction = @"url";
static NSString *const kDeeplinkAction = @"deeplink";
static NSString *const kPurchaseAction = @"purchase";
static NSString *const kRestoreAction = @"restore";
static NSString *const kNavigationAction = @"navigate";
static NSString *const kCloseAction = @"close";

@interface QONAutomationsActionsHandler()

@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *actionsTypesDictionary;

@end

@implementation QONAutomationsActionsHandler

#if !TARGET_OS_TV

- (instancetype)init {
  self = [super init];
  
  if (self) {
    _actionsTypesDictionary = @{
      kLinkAction: @(QONActionResultTypeURL),
      kDeeplinkAction: @(QONActionResultTypeDeeplink),
      kCloseAction: @(QONActionResultTypeClose),
      kPurchaseAction: @(QONActionResultTypePurchase),
      kRestoreAction: @(QONActionResultTypeRestore),
      kNavigationAction: @(QONActionResultTypeNavigation),
    };
  }
  
  return self;
}

- (BOOL)isActionShouldBeHandled:(WKNavigationAction *)action {
  NSURLComponents *components = [NSURLComponents componentsWithString:action.request.URL.absoluteString];
  NSRange range = [components.scheme rangeOfString:kQonversionSchemeRegEx options:NSRegularExpressionSearch];
  
  return range.location != NSNotFound && [components.host isEqualToString:kAutomationsHost];
}

- (QONActionResult *)prepareDataForAction:(WKNavigationAction *)action {
  NSURLComponents *components = [NSURLComponents componentsWithString:action.request.URL.absoluteString];
  QONActionResultType type = QONActionResultTypeUnknown;
  NSMutableDictionary *value = [NSMutableDictionary new];
  
  for (NSURLQueryItem *item in [components queryItems]) {
      if ([item.name isEqualToString:@"action"]) {
        type = self.actionsTypesDictionary[item.value].integerValue ?: type;
      } else if ([item.name isEqualToString:@"data"]) {
        value[@"value"] = item.value;
      }
  }
  
  QONActionResult *formattedAction = [QONActionResult new];
  formattedAction.type = type;
  formattedAction.parameters = [value copy];
  
  return formattedAction;
}

#endif

@end
