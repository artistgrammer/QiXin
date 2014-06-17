//
//  ImageList.m
//  QiXin
//
//  Created by Adam on 14-6-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "ImageList.h"


@implementation ImageList

@dynamic imageID;
@dynamic content;
@dynamic settingTime;
@dynamic shortContent;
@dynamic stringTime;
@dynamic imageURL;
@dynamic topic;
@dynamic type;
@dynamic shortType;
@dynamic isDelete;

//id = 58;
//content = "<p> With all <strong>58</strong> participants, <strong>9</strong>trainers, <strong>11</strong> moderators&rsquo; tremendous support, we&rsquo;ve together make the 1<sup>st</sup> Magic School-GC CBD Colleges Reinvention a success! We got overall score of <strong>4.79 </strong>to the total arrangement, average score of <strong>4.71</strong> cross all topics.</p><p> <img height=\"173\" src=\"/upload/news/pic/89e19478-ac45-40d4-9887-2d60adb149a7.jpg\" style=\"width: 534px; height: 309px\" width=\"260\" /></p>";
//"setting_time" = "2014-05-23 18:33:44";
//"short_content" = "With all 58 participants, 9trainers, 11 moderators\U2019 tremendous support, we\U2019ve together make the 1st ...";
//"string_time" = "2014/05/23 18:33";
//"title_pic" = "/upload/news/pic/2c32e399-55ac-4e51-8425-3aafbd63323b.jpg";
//topic = "GC CBD College II-Selling (May.20th-22nd, 2014)";
//type = 1;
- (void)updateData:(NSDictionary *)dic
{
    self.imageID = @(INT_VALUE_FROM_DIC(dic, @"id"));
    self.content =  STRING_VALUE_FROM_DIC(dic, @"content");
    self.settingTime = STRING_VALUE_FROM_DIC(dic, @"setting_time");
    self.shortContent = STRING_VALUE_FROM_DIC(dic, @"short_content");
    self.stringTime = STRING_VALUE_FROM_DIC(dic, @"string_time");
    self.imageURL =  STRING_VALUE_FROM_DIC(dic, @"title_pic");
    self.topic =  STRING_VALUE_FROM_DIC(dic, @"topic");
//    self.type =  STRING_VALUE_FROM_DIC(dic, @"type");
}

@end
