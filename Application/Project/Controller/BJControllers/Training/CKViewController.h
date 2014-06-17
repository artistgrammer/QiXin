#import <UIKit/UIKit.h>

#import "RootViewController.h"
#import "KxMenu.h"
#import "BJTrainingYearCalendarView.h"
#import "CKCalendarView.h"

@interface CKViewController : RootViewController
{
    NSMutableArray* coursesArray;
}

@property (nonatomic, retain) UIButton *filterButton;

@property (nonatomic, retain) CKCalendarView *calendar;

@property (nonatomic, retain) BJTrainingYearCalendarView *yearCalendarView;


- (id)initWithMOC:(NSManagedObjectContext *)MOC;

@end

/*
 
 {
 "course_status" = "-5";
 "full_course_name" = "College III-Selling(GZ)(Apr.2-4)";
 id = 70;
 introduction = "College III - Selling is a 3 days' learning journey with focusing on how to further build team leaders/sales masters' selling capability. The target audience of College III-Selling will be Band III managers or top senior Band II managers who have strong interest in further strengthen selling capability and potential business needs. We will cover the topics of Selling with Fiance Acumen, How to Lead a MFT to Sell, Strategy Development, Strategic Thinking, SBD-Learershp, Strategic Communication, Strategic Relationship Management, Options Based Negotiation, Lead TS/JBP, Dialogue, and etc. in College III-Selling.";
 ssp = 0;
 status = "-1";
 "target_slots" = 40;
 topic = "College III-Selling";
 trainers =             (
 {
 "admin_updated_mobile" = "";
 "black_list" = N;
 channel =                     {
 code = 1;
 id = 14;
 name = HQ;
 };
 "dcc_visitor" = 0;
 email = "YIN.SA@PG.COM";
 "email_without_suffix" = "YIN.SA";
 "finished_online_course_count" = 0;
 "first_name" = CHANGLI;
 "fulltext_content" = "Yin CHANGLI Sally YIN.SA@PG.COM";
 function = CBD;
 gender = Female;
 "head_photo" =                     {
 ext = "image/pjpeg";
 "file_ext" = png;
 "full_path" = "/upload/user/photo/f30bd03a-0e71-4e4e-a7f2-c691b6d1d617.png";
 id = 766;
 name = "f30bd03a-0e71-4e4e-a7f2-c691b6d1d617.jpg";
 "original_name" = "927e4f7f-1f98-4943-ab88-de3e14a3267e.jpg";
 path = "/user/photo";
 temp = 1;
 "upload_time" = "2013-07-12 17:24:57";
 };
 "head_photo_path" = "/upload/user/photo/f30bd03a-0e71-4e4e-a7f2-c691b6d1d617.png";
 id = 2443;
 "job_band" = 2;
 "known_as" = Sally;
 "last_name" = Yin;
 "learn_count" = 20;
 location = "";
 mac = 1;
 "manager_email" = "shang.ca@pg.com";
 market = "";
 mobile = "";
 name = "Sally Yin";
 "online_course_comment_count" = 1;
 point = 113;
 "point_rank" = 55;
 "positive_point" = 114;
 "super_admin" = 1;
 }
 );
 "training_time_end" = "2014-08-15";
 "training_time_start" = "2014-08-13";
 venue = Guangzhou;
 "venue_detail" = TBD;
 }
 **/
@interface BJTrainerChannelItem : NSObject
{
    
}
@property (nonatomic, assign)int code;
@property (nonatomic, assign)int channelID;
@property (nonatomic, retain)NSString* name;
@end

@interface BJHeadPhotoItem : NSObject
{
    
}
@property (nonatomic, retain)NSString* ext;
@property (nonatomic, retain)NSString* file_ext;
@property (nonatomic, retain)NSString* full_path;
@property (nonatomic, assign)int photoID;
@property (nonatomic, retain)NSString* name;
@property (nonatomic, retain)NSString* original_name;
@property (nonatomic, retain)NSString* path;
@property (nonatomic, assign)int temp;
@property (nonatomic, retain)NSString* upload_time;
@end

@interface BJTrainerItem : NSObject
{
    
}
@property (nonatomic, retain)NSString* admin_updated_mobile;
@property (nonatomic, retain)NSString* black_list;
@property (nonatomic, retain)BJTrainerChannelItem* channel;
@property (nonatomic, assign)int dcc_visitor;
@property (nonatomic, retain)NSString* email;
@property (nonatomic, retain)NSString* email_without_suffix;
@property (nonatomic, assign)int finished_online_course_count;
@property (nonatomic, retain)NSString* first_name;
@property (nonatomic, retain)NSString* fulltext_content;
@property (nonatomic, retain)NSString* function;
@property (nonatomic, retain)NSString* gender;
@property (nonatomic, retain)BJHeadPhotoItem* headPhotoItem;
@property (nonatomic, retain)NSString* head_photo_path;
@property (nonatomic, assign)int photoBelowID;

@property (nonatomic, assign)int job_band;
@property (nonatomic, retain)NSString* known_as;
@property (nonatomic, retain)NSString* last_name;
@property (nonatomic, assign)int learn_count;
@property (nonatomic, retain)NSString* location;
@property (nonatomic, retain)NSString* mac;
@property (nonatomic, retain)NSString* manager_email;
@property (nonatomic, retain)NSString* market;
@property (nonatomic, retain)NSString* mobile;
@property (nonatomic, retain)NSString* name;
@property (nonatomic, assign)int online_course_comment_count;
@property (nonatomic, assign)int point;
@property (nonatomic, assign)int point_rank;
@property (nonatomic, assign)int positive_point;
@property (nonatomic, assign)int super_admin;


@end

@interface BJCourseItem : NSObject
{
    
}

@property (nonatomic, retain)NSString* course_status;
@property (nonatomic, retain)NSString* full_course_name;
@property (nonatomic, assign)int courseID;
@property (nonatomic, retain)NSString* introduction;
@property (nonatomic, assign)int ssp;
@property (nonatomic, retain)NSString* status;
@property (nonatomic, assign)int target_slots;
@property (nonatomic, retain)NSString* topic;
@property (nonatomic, retain)NSMutableArray* trainerItemArray;

@property (nonatomic, retain)NSString* training_time_end;
@property (nonatomic, retain)NSString* training_time_start;
@property (nonatomic, retain)NSString* venue;
@property (nonatomic, retain)NSString* venue_detail;

@end