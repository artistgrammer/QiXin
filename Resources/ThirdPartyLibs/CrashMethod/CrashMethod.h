
/*!
 @header CrashMethod.h
 @abstract Crash上传
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <Foundation/Foundation.h>

#define CRASH_FTP_URL @"ftp://cpos.app:ftp.secret=15@www.o2omarketing.cn:8103/"

@interface CrashMethod : NSObject

+ (CrashMethod *)getInstance;

//+ (BOOL)uploadCrashFileToFTP:(NSString *)FTPURL withLocalFile:(NSString *)localFile withClientId:(NSString *)clientId withUnitId:(NSString *)unitId;

+ (void)uploadCrashReportWithThread:(NSString *)userId;

+ (void)uploadCrashReport:(NSString *)userId;

@end
