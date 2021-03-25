//
//  QNIdentityManagerInterface.h
//  Qonversion
//
//  Created by Surik Sarkisyan on 23.03.2021.
//  Copyright © 2021 Qonversion Inc. All rights reserved.
//

@protocol QNIdentityManagerInterface <NSObject>

typedef void (^QNIdentityCompletionHandler)(NSString *_Nullable result, NSError  *_Nullable error);

- (void)identify:(NSString *)userID completion:(QNIdentityCompletionHandler)completion;
- (void)logout;

@end
