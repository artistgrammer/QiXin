
/*!
 @header PYMethod.h
 @abstract 拼音解析
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface PYMethod : NSObject

+ (NSString*)getPinYin:(NSString *)nsstrHZ;
+ (NSString *)firstCharOfNamePinyin:(NSString *)nsstrHZ;

@end

