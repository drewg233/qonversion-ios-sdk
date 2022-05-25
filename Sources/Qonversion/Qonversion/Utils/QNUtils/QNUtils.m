#import <CoreGraphics/CoreGraphics.h>

#import "QNUtils.h"
#import "QNErrors.h"

@implementation QNUtils

+ (BOOL)isEmptyString:(NSString *)string {
  return string == nil || [string isKindOfClass:[NSNull class]] || [string length] == 0;
}

+ (NSString *)convertHexData:(NSData *)tokenData {
    const unsigned char *bytes = (const unsigned char *)tokenData.bytes;
    NSMutableString *hex = [NSMutableString new];
    for (NSInteger i = 0; i < tokenData.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    return [hex copy];
}

+ (BOOL)isCacheOutdated:(NSTimeInterval)cacheDataTimeInterval {
  CGFloat dayInSeconds = 60.0 * 60.0 * 24.0;
  NSDate *currentDate = [NSDate date];
  return (currentDate.timeIntervalSince1970 - cacheDataTimeInterval) > dayInSeconds;
}

+ (BOOL)isPermissionsOutdatedForDefaultState:(BOOL)defaultState cacheDataTimeInterval:(NSTimeInterval)cacheDataTimeInterval {
  if (defaultState) {
    CGFloat cacheLifetimeInSeconds = 60.0 * 5.0;
    NSDate *currentDate = [NSDate date];
    return (currentDate.timeIntervalSince1970 - cacheDataTimeInterval) > cacheLifetimeInSeconds;
  } else {
    return [self isCacheOutdated:cacheDataTimeInterval];
  }
}

+ (NSDate *)dateFromTimestamp:(NSNumber *)timestamp {
  NSDate *date;
  
  if (timestamp && [timestamp isKindOfClass:[NSNumber class]]) {
    date = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
  }
  
  return date;
}

@end
