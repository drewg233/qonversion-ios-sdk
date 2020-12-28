#import "QNRequestBuilder.h"
#import "QNAPIConstants.h"

@implementation QNRequestBuilder

- (NSURLRequest *)makeInitRequestWith:(NSDictionary *)parameters {
  return [self makePostRequestWith:kInitEndpoint andBody:parameters];
}

- (NSURLRequest *)makePropertiesRequestWith:(NSDictionary *)parameters {
  return [self makePostRequestWith:kPropertiesEndpoint andBody:parameters];
}

- (NSURLRequest *)makeAttributionRequestWith:(NSDictionary *)parameters {
  return [self makePostRequestWith:kAttributionEndpoint andBody:parameters];
}

- (NSURLRequest *)makePurchaseRequestWith:(NSDictionary *)parameters {
  return [self makePostRequestWith:kPurchaseEndpoint andBody:parameters];
}

- (NSURLRequest *)makeUserActionPointsRequestWith:(NSString *)parameter apiKey:(NSString *)apiKey {
  NSString *endpoint = [NSString stringWithFormat:kActionPointsEndpointFormat, parameter];
  return [self makeGetRequestWith:endpoint apiKey:apiKey];
}

- (NSURLRequest *)makeScreensRequestWith:(NSString *)parameters apiKey:(NSString *)apiKey {
  NSString *endpoint = [NSString stringWithFormat:@"%@%@", kScreensEndpoint, parameters];
  return [self makeGetRequestWith:endpoint apiKey:apiKey];
}

- (NSURLRequest *)makeScreenShownRequestWith:(NSString *)parameter body:(NSDictionary *)body apiKey:(NSString *)apiKey {
  NSString *endpoint = [NSString stringWithFormat:kScreenShowEndpointFormat, parameter];
  return [self makePostRequestWith:endpoint andBody:body apiKey:apiKey];
}

// MARK: Private

- (NSURLRequest *)makeGetRequestWith:(NSString *)endpoint apiKey:(NSString *)apiKey {
  NSString *urlString = [kAPIBase stringByAppendingString:endpoint];
  NSURL *url = [[NSURL alloc] initWithString:urlString];

  NSMutableURLRequest *request = [self baseGetRequestWithURL:url];
  NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", apiKey];
  [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
  
  return [request copy];
}

- (NSURLRequest *)makePostRequestWith:(NSString *)endpoint andBody:(NSDictionary *)body apiKey:(NSString *)apiKey {
  NSString *urlString = [kAPIBase stringByAppendingString:endpoint];
  NSURL *url = [NSURL.alloc initWithString:urlString];

  NSMutableURLRequest *request = [self basePostRequestWithURL:url];
  
  if (apiKey.length > 0) {
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", apiKey];
    [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
  }
  
  NSMutableDictionary *mutableBody = body.mutableCopy ?: [NSMutableDictionary new];

  request.HTTPBody = [NSJSONSerialization dataWithJSONObject:mutableBody options:0 error:nil];
  
  return [request copy];
}

- (NSURLRequest *)makePostRequestWith:(NSString *)endpoint andBody:(NSDictionary *)body {
  return [self makePostRequestWith:endpoint andBody:body apiKey:nil];
}

- (NSMutableURLRequest *)basePostRequestWithURL:(NSURL *)url {
  return [self baseRequestWithURL:url type:@"POST"];
}

- (NSMutableURLRequest *)baseGetRequestWithURL:(NSURL *)url {
  return [self baseRequestWithURL:url type:@"GET"];
}

- (NSMutableURLRequest *)baseRequestWithURL:(NSURL *)url type:(NSString *)type {
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
  
  request.HTTPMethod = type;
  [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  
  return request;
}

@end
