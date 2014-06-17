
/*!
 @header WXWSyncConnectorFacade.h
 @abstract 网络同步
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <Foundation/Foundation.h>
#import "WXWConnector.h"
#import "GlobalConstants.h"

@interface WXWSyncConnectorFacade : WXWConnector {

}

#pragma mark - upload log
- (NSData *)uploadLog:(NSString *)logContent logFileName:(NSString*)logFileName;
- (NSData *)uploadLogData:(NSData *)data logFileName:(NSString*)logFileName;
- (NSData *)uploadLogData:(NSDictionary *)dic data:(NSData *)data logFileName:(NSString*)logFileName;
- (NSData *)uploadLog:(NSString *)logContent;
- (void)fetchGets:(NSString *)url;

@end
