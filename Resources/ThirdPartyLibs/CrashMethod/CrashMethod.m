
#import "CrashMethod.h"
#import "JILFTPUpload.h"
#import "FileUtils.h"
#import "SSZipArchive.h"
#import "NSData+JITIOSLib.h"
#import "CommonMethod.h"

@implementation CrashMethod
static CrashMethod *instance = nil;

+ (CrashMethod *)getInstance {

    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}


+ (BOOL)uploadCrashFileToFTP:(NSString *)FTPURL withLocalFile:(NSString *)localFile withUserId:(NSString *)withUserId
{
    if ([FileUtils fileExistsAtPath:localFile]) {
//        NSString *path = [NSString stringWithFormat:@"%@/%@/upload/%@",
//                          clientId, unitId,
//                          [localFile lastPathComponent]];
        NSString *path = [NSString stringWithFormat:@"%@", [localFile lastPathComponent]];
        
        BOOL succ = [JILFTPUpload uploadFile:localFile
                                toRemoteFile:[NSString stringWithFormat:@"%@%@", FTPURL, path]];
        return succ ;
        
    }
    
    return FALSE;
}

+ (void)uploadCrashReportWithThread:(NSString *)userId
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", nil];
    [NSThread detachNewThreadSelector:@selector(uploadCrashReport:) toTarget:self withObject:dict];
}

+ (void)uploadCrashReport:(NSDictionary *)dict
{
    NSString *userId = [dict objectForKey:@"userId"];
    
    NSString *originalCacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    originalCacheFolder = [NSString stringWithFormat:@"%@/%@/%@", originalCacheFolder,@"com.plausiblelabs.crashreporter.data",  [[NSBundle mainBundle] bundleIdentifier] ];
    NSString *crashFileName = @"live_report.plcrash";
    NSString *crashFile = [NSString stringWithFormat:@"%@/%@", originalCacheFolder,crashFileName];
    
    if ([FileUtils fileExistsAtPath:crashFile]) {
        
        NSString *currentTime = [[CommonMethod getDateFromNow:0] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        currentTime = [currentTime stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        currentTime = [currentTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        
//        NSString *renamedCrashFileName = [NSString stringWithFormat:@"%@_%@_%@_%@.crash", customerId, unitId, currentTime, [CommonMethod GetUUID]];
        
        NSString *renamedCrashFileNameZipped = [NSString stringWithFormat:@"%@_%@_%@.crash.zip", userId, currentTime , [CommonMethod GetUUID]];
              
//        NSString *renamedCrashFile = [NSString stringWithFormat:@"%@/%@", originalCacheFolder,renamedCrashFileName];
        NSString *renamedCrashFileZipped = [NSString stringWithFormat:@"%@/%@", originalCacheFolder,renamedCrashFileNameZipped];
        
        
//        BOOL isCopied = [FileUtils copyFileAt:crashFile toDir:renamedCrashFile];
//        [FileUtils rm:crashFile];
        
        BOOL isZipped = [SSZipArchive createZipFileAtPath:renamedCrashFileZipped withFilesAtPaths:[NSArray arrayWithObjects:crashFile, nil]];
        
        if (isZipped) {
//            [FileUtils rm:crashFile];
//            [self uploadFile:CRASH_FTP_URL withFileName:renamedCrashFileZipped withUserId:userId];
        }
    }
}

+ (BOOL) uploadFile:(NSString *)FTPURL withFileName:(NSString *)fileName withUserId:(NSString *)userId
{
    BOOL result = [CrashMethod uploadCrashFileToFTP:FTPURL withLocalFile:fileName withUserId:userId];
    
    if (result) {
        [FileUtils rm:fileName];
    } else {
        NSLog(@"zipped error :%@", fileName);
    }
    
    return result;
}

@end
