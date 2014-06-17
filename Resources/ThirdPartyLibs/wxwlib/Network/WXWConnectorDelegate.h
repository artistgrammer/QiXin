
/*!
 @header WXWConnectorDelegate.h
 @abstract 网络代理
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseConstants.h"

@protocol WXWConnectorDelegate <NSObject>

@optional
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType;

- (void)connectDone:(NSData *)result 
                url:(NSString *)url 
        contentType:(NSInteger)contentType;

- (void)connectDone:(NSData *)result 
                url:(NSString *)url 
        contentType:(NSInteger)contentType
closeAsyncLoadingView:(BOOL)closeAsyncLoadingView;

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType;

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url 
          contentType:(NSInteger)contentType;

- (void)traceParserXMLErrorMessage:(NSString *)message url:(NSString *)url;

- (void)parserConnectionError:(NSError *)error;

- (void)saveShowAlertFlag:(BOOL)flag;

- (void)registerSessionExpiredForUrl:(NSString *)url requestType:(NSInteger)requestType;
@end
