//
//  QNErrorsMapper.m
//  Qonversion
//
//  Created by Surik Sarkisyan on 22.07.2021.
//  Copyright © 2021 Qonversion Inc. All rights reserved.
//

#import "QNErrorsMapper.h"
#import "QNErrors.h"

@implementation QNErrorsMapper

- (NSError *)errorFromRequestResult:(NSDictionary *)result {
  if (![result isKindOfClass:[NSDictionary class]] || ![result[@"data"] isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  BOOL isSuccessRequest = [result[@"success"] boolValue];
  
  if (isSuccessRequest) {
    return nil;
  }
  
  NSDictionary *data = result[@"data"];
  NSNumber *codeNumber = data[@"code"];
  
  if (!codeNumber) {
    return nil;
  }
  
  QNAPIError errorType = [self errorTypeFromCode:codeNumber];
  NSString *errorMessage = [self messageForErrorType:errorType];
  
  NSError *error = [QNErrors errorWithCode:errorType message:errorMessage];
  
  return error;
}

- (NSString *)messageForErrorType:(QNAPIError)errorType {
  return @"";
}

- (QNAPIError)errorTypeFromCode:(NSNumber *)errorCode {
  QNAPIError type = QNAPIErrorUnknown;
  
  switch (errorCode.integerValue) {
    case 10000:
    case 10001:
    case 10007:
    case 10009:
    case 20000:
    case 20009:
    case 20015:
    case 20099:
    case 20300:
    case 20303:
    case 20399:
    case 20200:
    case 20100:
      type = QNAPIErrorInternalError;
      break;
      
    case 10002:
    case 10003:
      type = QNAPIErrorInvalidCredentials;
      break;
      
    case 10004:
    case 10005:
    case 20014:
      type = QNAPIErrorInvalidClientUID;
      break;
      
    case 10006:
      type = QNAPIErrorUnknownClientPlatform;
      break;
      
    case 10008:
      type = QNAPIErrorFraudPurchase;
      break;
      
    case 20005:
      type = QNAPIErrorFeatureNotSupported;
      break;
      
    case 20006:
    case 20007:
    case 20300:
    case 20303:
    case 20109:
    case 20199:
      type = QNAPIErrorAppleStoreError;
      break;
      
    case 20008:
    case 20010:
      type = QNAPIErrorPurchaseInvalid;
      break;
      
    case 20011:
    case 20012:
    case 20013:
      type = QNAPIErrorProjectConfigError;
      break;
      
    case 20104:
      type = QNAPIErrorInvalidStoreCredentials;
      break;
      
    case 20102:
    case 20103:
    case 20105:
    case 20110:
    case 20100:
    case 20107:
    case 20108:
    case 20109:
    case 20110:
    case 21099:
      type = QNAPIErrorReceiptValidation;
      break;
      
    default:
      break;
      
  }
  
  return type;
}

@end
