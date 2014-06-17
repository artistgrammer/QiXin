//
//  CommonUtils.m
//  Project
//
//  Created by Peter on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommonUtils.h"
#import "TextConstants.h"
#import "UIDevice+Hardware.h"
#import "WXApi.h"

#define BUFFER_SIZE 1024 * 100

@implementation CommonUtils

#pragma mark - user default local storage
+ (void)saveIntegerValueToLocal:(NSInteger)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                              forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveLongLongIntegerValueToLocal:(long long)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                              forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveStringValueToLocal:(NSString *)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value
                                              forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveBoolValueToLocal:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)fetchIntegerValueFromLocal:(NSString *)key {
    NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nil == number) {
        return 0;
    } else {
        return number.intValue;
    }
}

+ (long long)fetchLonglongIntegerValueFromLocal:(NSString *)key {
    NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return number.longLongValue;
}

+ (NSString *)fetchStringValueFromLocal:(NSString *)key {
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)fetchBoolValueFromLocal:(NSString *)key {
    NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return number.boolValue;
}

+ (void)removeLocalInfoValueForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - date time
+ (NSString *)currentHourTime {
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH"];
	NSString *dateString = [dateFormat stringFromDate:today];
	[dateFormat release];
	dateFormat = nil;
	return dateString;
}

+ (NSString *)currentHourMinSecondTime {
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [dateFormat stringFromDate:today];
	[dateFormat release];
	dateFormat = nil;
	return dateString;
}

+ (NSDate *)convertDateTimeFromUnixTS:(NSTimeInterval)unixDate {
	return [NSDate dateWithTimeIntervalSince1970:unixDate];
}

+ (NSTimeInterval)convertToUnixTS:(NSDate *)date {
	return [date timeIntervalSince1970];
}

+ (NSString *)simpleFormatDateWithYear:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //	switch ([self currentLanguage]) {
    //		case ZH_HANS_TY:
    //		{
    //			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"yyyy年 MM月 dd日"];
    //            }
    //
    //			break;
    //		}
    //		case EN_TY:
    //		{
    //            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"dd MMM yyyy"];
    //            }
    //
    //			break;
    //		}
    //		default:
    //			break;
    //	}
	
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
	NSString *timeline = [formatter stringFromDate:date];
    //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	[formatter release];
	formatter = nil;
	
	//return timelineResult;
    return timeline;
}

+ (NSString *)simpleFormatDate:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //	switch ([self currentLanguage]) {
    //		case ZH_HANS_TY:
    //		{
    //			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"MM月 dd日 HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"MM月 dd日"];
    //            }
    //
    //			break;
    //		}
    //		case EN_TY:
    //		{
    //            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"dd MMM HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"dd MMM"];
    //            }
    //
    //			break;
    //		}
    //		default:
    //			break;
    //	}
    
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"MM/dd HH:mm"];
    } else {
        [formatter setDateFormat:@"MM/dd"];
    }
	
	NSString *timeline = [formatter stringFromDate:date];
    //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	[formatter release];
	formatter = nil;
	
	//return timelineResult;
    return timeline;
}

+ (NSString *)getQuantumTimeWithDateFormat:(NSString *)timeline {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    //Set the AM and PM symbols
    //Specify only 1 M for month, 1 d for day and 1 h for hour
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate *orderDate = [dateFormatter dateFromString:eventList.startTime];
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[timeline floatValue] / 1000];
    
    //        NSDate *nowtime = [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    
    //下单 与目前相隔多少秒
    
    int time = [[NSDate date] timeIntervalSinceDate:orderDate];
    
    NSString *timeStr = @"";
    
    if (time > 0) {
        if (time / 60 / 60 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟前",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时前",time / 60.f/ 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天前",time / 60.f / 60.f / 24.f];
        }
    }else {
        time *= -1;
        if (time / 60 /60  <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟后",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时后",time / 60.f / 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天后",time / 60.f / 60.f / 24.f];
        }
    }
    return timeStr;
}

+ (NSString *)getElapsedTime:(NSDate *)timeline {
    
    NSUInteger desiredComponents = NSDayCalendarUnit | NSHourCalendarUnit
    | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                         fromDate:timeline
                                                                           toDate:[NSDate date]
                                                                          options:0];
    // format to be used to generate string to display
    NSInteger number = 0;
    NSString *elapsedTime = nil;
    
    if ([elapsedTimeUnits day] > 0) {
        
        elapsedTime = [CommonUtils simpleFormatDate:timeline secondAccuracy:NO];
        
    } else if ([elapsedTimeUnits hour] > 0) {
        number = [elapsedTimeUnits hour];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHoursAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHourAgoTitle, nil)];
        }
        
    } else if ([elapsedTimeUnits minute] > 0) {
        number = [elapsedTimeUnits minute];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinAgoTitle, nil)];
        }
    } else if ([elapsedTimeUnits second] > 0) {
        number = [elapsedTimeUnits second];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecAgoTitle, nil)];
        }
    } else if ([elapsedTimeUnits second] <= 0) {
        
        elapsedTime = [NSString stringWithFormat:@"1 %@", LocaleStringForKey(NSSecAgoTitle, nil)];
    }
    
    return elapsedTime;
}

+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset {
	NSDateComponents *components = [[NSDateComponents alloc] init];
    
	[components setDay:offset];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *newDate = [gregorian dateByAddingComponents:components
                                                 toDate:nowDate
                                                options:0];
	
	[components release];
	components = nil;
	[gregorian release];
	gregorian = nil;
	
	return newDate;
}

+ (NSDate *)getTodayMidnight {
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.day = 1;
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    components = [gregorian components:unitFlags fromDate:tomorrow];
    [components setHour:-16]; // maybe timezone caused the offset, set hour offset to -16
    [components setMinute:0];
    
    NSDate *todayMidnight = [gregorian dateFromComponents:components];
    
    return todayMidnight;
}


+ (NSInteger)getElapsedDayCount:(NSDate *)date {
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                         fromDate:date
                                                                           toDate:currentDate
                                                                          options:0];
    return [elapsedTimeUnits day];
}

#pragma mark - Share to WeChat
+ (BOOL)shareByWeChat:(NSInteger)scene
                title:(NSString *)title
                image:(NSString *)image
          description:(NSString *)description
                  url:(NSString *)url {
    
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    
    // avoid length larger than the specification
    if (title.length > MAX_WECHAT_MAX_TITLE_CHAR_COUNT) {
        title = [title substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_TITLE_CHAR_COUNT)];
        
        NSMutableString *reducedTitle = [NSMutableString stringWithString:title];
        [reducedTitle appendString:@"..."];
        message.title = reducedTitle;
    } else {
        message.title = title;
    }
    
    if (description.length > MAX_WECHAT_MAX_DESC_CHAR_COUNT) {
        description = [description substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_DESC_CHAR_COUNT)];
        NSMutableString *reducedDesc = [NSMutableString stringWithString:description];
        [reducedDesc appendString:@"..."];
        message.description = reducedDesc;
    } else {
        message.description = description;
    }
    
    [message setThumbImage:[UIImage imageNamed:image]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"";
    ext.url = url;
    
    /*
     Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
     memset(pBuffer, 0, BUFFER_SIZE);
     NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
     free(pBuffer);
     ext.fileData = data;
     */
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    return [WXApi sendReq:req];
}

//+ (BOOL)sharePostByWeChat:(Post *)post
//                    scene:(NSInteger)scene
//                      url:(NSString *)url
//                    image:(UIImage *)image {
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    
//    NSString *title = [NSString stringWithFormat:@"dsfadfafdfdsafdsa"/*LocaleStringForKey(NSSharedFromiAlumniTitle, nil), post.elapsedTime, post.authorName*/];
//    
//    // avoid length larger than the specification
//    if (title.length > MAX_WECHAT_MAX_TITLE_CHAR_COUNT) {
//        title = [title substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_TITLE_CHAR_COUNT)];
//        
//        NSMutableString *reducedtitle = [NSMutableString stringWithString:title];
//        [reducedtitle appendString:@"..."];
//        
//        message.title = reducedtitle;
//    } else {
//        message.title = title;
//    }
//    
//    NSString *desc = post.content;
//    if (desc.length > MAX_WECHAT_MAX_DESC_CHAR_COUNT) {
//        desc = [desc substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_DESC_CHAR_COUNT)];
//        
//        NSMutableString *reducedDesc = [NSMutableString stringWithString:desc];
//        [reducedDesc appendString:@"..."];
//        message.description = reducedDesc;
//    } else {
//        message.description = desc;
//    }
//    
//    if (image) {
//        if (post.thumbnailImageUrl && post.thumbnailImageUrl.length > 0) {
//            NSData *imageData = nil;
//            if ([post.thumbnailImageUrl rangeOfString:@".png"].length > 0) {
//                imageData = UIImagePNGRepresentation(image);
//            } else if ([post.thumbnailImageUrl rangeOfString:@".jpg"].length > 0) {
//                imageData = UIImageJPEGRepresentation(image, 0.1f);
//            }
//            
//            // If the image data size is larger than 32k, then sharing action
//            // will failed. So if the size is larger than 32k, then no need to
//            // set the thumb image.
//            if (imageData.length < MAX_WECHAT_ATTACHED_IMG_SIZE) {
//                message.thumbData = imageData;
//            }
//        }
//    }
//    
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.extInfo = @"";
//    ext.url = url;
//    
//    /*
//     Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
//     memset(pBuffer, 0, BUFFER_SIZE);
//     NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
//     free(pBuffer);
//     ext.fileData = data;
//     
//     message.mediaObject = ext;
//     
//     SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
//     req.bText = NO;
//     req.message = message;
//     req.scene = scene;
//     [WXApi sendReq:req];
//     */
//    return [self sendToWechatWithExtObject:ext message:message];
//}

+ (BOOL)sendToWechatWithExtObject:(WXAppExtendObject *)ext message:(WXMediaMessage *)message {
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    return [WXApi sendReq:req];
    
}

#pragma mark - validate json data
+ (id)validateResult:(NSDictionary *)contentDic dicKey:(NSString *)key
{
    if (nil == contentDic) {
        return nil;
    }
    
    if (nil == key || key.length == 0) {
        return nil;
    }
    
    if ([contentDic isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    id result = [contentDic objectForKey:key];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if (result) {
            if ([@"null" isEqualToString:result]) {
                return nil;
            } else {
                return result;
            }
        } else {
            return nil;
        }
    }
}


#pragma mark - validate password format
+ (BOOL)passwordFormatIsValidated:(NSString *)passwordStr {
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    NSRange range = [passwordStr rangeOfCharacterFromSet:notAllowedChars];
    if (range.location != NSNotFound && range.length > 0) {
        
        ShowAlert(nil, nil,
                  LocaleStringForKey(NSPwdFormatIncorrectMsg, nil),
                  LocaleStringForKey(NSSureTitle, nil));
        
        return NO;
    } else {
        return YES;
    }
}


+ (NSString *)deviceModel {
	UIDevice *device = [[[UIDevice alloc] init] autorelease];
	return [device platformString];
}
+ (NSString *)documentsDirectory {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}
+ (CGFloat)currentOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [CommonUtils imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

#pragma mark - crop image
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
