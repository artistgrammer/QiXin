#import "CKViewController.h"

@interface CKViewController ()

@end

@implementation CKViewController
{
    
}

@synthesize filterButton = _filterButton;
@synthesize calendar = _calendar;
@synthesize yearCalendarView = _yearCalendarView;

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Channel >"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
                    ],
      

      [KxMenuItem menuItem:@"Platform >"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
                    ],
      
      [KxMenuItem menuItem:@"Competency >"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
                    ],
      
      [KxMenuItem menuItem:@"Band >"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
                   ],
      
//      [KxMenuItem menuItem:@"Go home"
//                     image:[UIImage imageNamed:@"home_icon"]
//                    
//                    ],
      ];
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)showChannelMenu
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"DMC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      
      [KxMenuItem menuItem:@"HSC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"DPSC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"DCC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"DCC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"E-com"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"MRC"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"HK/TW"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"MS&P"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      [KxMenuItem menuItem:@"Others"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)
       ],
      
      //      [KxMenuItem menuItem:@"Go home"
      //                     image:[UIImage imageNamed:@"home_icon"]
      //
      //                    ],
      ];
    
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:_filterButton.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
    
    NSString* title = ((KxMenuItem*)sender).title;
    
    if ([title isEqualToString:@"Channel >"]) {
        [self showChannelMenu];
        
    }else if ([title isEqualToString:@"Platform >"])
    {
        
    }else if ([title isEqualToString:@"Competency >"])
    {
        
    }else if ([title isEqualToString:@"Band >"])
    {
        
    }
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
//        calendar.frame = CGRectMake(10, 10, 300, 470);
//        [self.view addSubview:calendar];
//
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    self.navigationItem.title = @"CBD Training Calendar";
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
        
        coursesArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
    
}

- (void)btnAction:(id)sender
{
	UIButton * item = (UIButton *)sender;
    
    if (item.tag == 0) {
        
    }
    else if(item.tag == 1)
    {
        if (_calendar.hidden == NO) {
            _calendar.hidden = YES;
            _yearCalendarView.hidden = NO;
            [_yearCalendarView refreshTable];
            
            [item setTitle:@"Day Calendar" forState:UIControlStateNormal];
            [item setTitle:@"Day Calendar" forState:UIControlStateHighlighted];
            [item setTitle:@"Day Calendar" forState:UIControlStateSelected];
        }else{
            _calendar.hidden = NO;
            _yearCalendarView.hidden = YES;
            
            [item setTitle:@"Year Calendar" forState:UIControlStateNormal];
            [item setTitle:@"Year Calendar" forState:UIControlStateHighlighted];
            [item setTitle:@"Year Calendar" forState:UIControlStateSelected];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAllCourses];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    int startY = self.navigationController.navigationBar.frame.size.height;
    int gap = 5;
    int leftrightW = 60;
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [titleView setBackgroundColor:[UIColor blackColor]];
    titleView.alpha = 0.5;
    
    _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(gap, gap, leftrightW, 20)];
    
    [_filterButton setBackgroundColor:[UIColor clearColor]];
    [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [_filterButton setTitle:@"Filter" forState:UIControlStateHighlighted];
    [_filterButton setTitle:@"Filter" forState:UIControlStateSelected];
    _filterButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [_filterButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [_filterButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    _filterButton.tag = 0;
    [titleView addSubview:_filterButton];
    [_filterButton release];
    
    
    UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-leftrightW*2-gap*2,gap,leftrightW*2+gap,20)];
    
    [yeardayBtn setBackgroundColor:[UIColor orangeColor]];
    
    [yeardayBtn setTitle:@"Year Calendar" forState:UIControlStateNormal];
    [yeardayBtn setTitle:@"Year Calendar" forState:UIControlStateHighlighted];
    [yeardayBtn setTitle:@"Year Calendar" forState:UIControlStateSelected];
    yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [yeardayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    yeardayBtn.tag = 1;
    [titleView addSubview:yeardayBtn];
    [yeardayBtn release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(gap*2+_filterButton.frame.size.width,gap,SCREEN_WIDTH-(gap*2+_filterButton.frame.size.width)-(gap*2+yeardayBtn.frame.size.width),20)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.numberOfLines = 0;
    dateLabel.font = [UIFont systemFontOfSize:18];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setText:@"2013"];
    dateLabel.textColor = [UIColor whiteColor];
    
    [titleView addSubview:dateLabel];
    [dateLabel release];
    
    [self.view addSubview:titleView];
    [titleView release];
    /*********************************************************************************************/
    //        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    _calendar = [[CKCalendarView alloc] initWithStartDay:startMonday frame:CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(startY*2+titleView.frame.size.height))];
    [self.view addSubview:_calendar];
    [_calendar release];
    
    
    _yearCalendarView = [[BJTrainingYearCalendarView alloc] initWithFrame:CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(startY*2+titleView.frame.size.height))];
    
    [self.view addSubview:_yearCalendarView];
    _yearCalendarView.hidden = YES;
    
    [_yearCalendarView release];
    /*********************************************************************************************/
    
    //自定义UISegmentedcontrol
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, _calendar.frame.origin.y+_calendar.frame.size.height + 5, SCREEN_WIDTH - 80*2, startY - 10) ];
    [segmentedControl insertSegmentWithTitle:@"ALL Courses" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"My Course" atIndex:1 animated:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = NO;
    segmentedControl.multipleTouchEnabled=NO;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    
    [segmentedControl release];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - request
- (void)loadDataUserProfile
{
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_LOGIN
                                                              contentType:PG_GET_LOGIN_INFO];
    
    [connFacade fetchGets:PG_SERVER_URL_LOGIN];
}

- (void)loadAllCourses
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:@"2014" forKey:@"year"];
    [specialDict setObject:@"2"forKey:@"mode"];
    [specialDict setObject:@""forKey:@"month"];
    
    NSString* channelID = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelID"];
    NSString* job_band = [[NSUserDefaults standardUserDefaults] objectForKey:@"job_band"];
    [specialDict setObject:channelID forKey:@"channelId"];
    [specialDict setObject:job_band forKey:@"band"];
    [specialDict setObject:@"0"forKey:@"isAll"];

    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_GETALLCOURSES
                                                              contentType:PG_GET_ALLCOURSES];
    [connFacade post:PG_SERVER_URL_GETALLCOURSES data:[specialDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ALLCOURSES:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
//                NSDictionary *errorDict = [resultDic objectForKey:@"error"];
//                if (errorDict) {
//                    NSString* err_code = OBJ_FROM_DIC(errorDict, @"err_code");
//                    NSString* err_msg = OBJ_FROM_DIC(errorDict, @"err_msg");
//                    NSString* request_args = OBJ_FROM_DIC(errorDict, @"request_args");
//                }
                
                NSArray *contentArr = [resultDic objectForKey:@"list"];
                
                if (contentArr) {
                    
                    if ([coursesArray count] > 0) {
                        [coursesArray removeAllObjects];
                    }
                    
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
                    for (int i = 0; i < [contentArr count]; i++) {
                        NSDictionary* list_item_dic = [contentArr objectAtIndex:i];
                        
                        BJCourseItem* course_item = [[BJCourseItem alloc] init];
                        course_item.full_course_name = OBJ_FROM_DIC(list_item_dic, @"full_course_name");
                        course_item.courseID = INT_VALUE_FROM_DIC(list_item_dic, @"id");
                        course_item.introduction = OBJ_FROM_DIC(list_item_dic, @"introduction");
                        course_item.ssp = INT_VALUE_FROM_DIC(list_item_dic, @"ssp");
                        course_item.status = OBJ_FROM_DIC(list_item_dic, @"status");
                        course_item.target_slots = INT_VALUE_FROM_DIC(list_item_dic, @"target_slots");
                        course_item.topic = OBJ_FROM_DIC(list_item_dic, @"topic");
                        course_item.training_time_end =  OBJ_FROM_DIC(list_item_dic, @"training_time_end");
                        course_item.training_time_start = OBJ_FROM_DIC(list_item_dic, @"training_time_start");
                        course_item.venue = OBJ_FROM_DIC(list_item_dic, @"venue");
                        course_item.venue_detail = OBJ_FROM_DIC(list_item_dic, @"venue_detail");
                        
                        NSMutableArray* courseItemArray  = [[NSMutableArray alloc] initWithCapacity:10];
                        
                        NSArray* trainer_item_array = [list_item_dic objectForKey:@"trainers"];
                        for (int k = 0; k < [trainer_item_array count]; k++) {
                            BJTrainerItem* trainer_item = [[BJTrainerItem alloc] init];
                            NSDictionary* trainer_item_dic = [trainer_item_array objectAtIndex:k];
                            
                            trainer_item.admin_updated_mobile = OBJ_FROM_DIC(trainer_item_dic, @"admin_updated_mobile");
                            trainer_item.black_list = OBJ_FROM_DIC(trainer_item_dic, @"black_list");
                            
                            BJTrainerChannelItem* trainer_channel_item = [[BJTrainerChannelItem alloc] init];
                            NSDictionary* channel_dic = [trainer_item_dic objectForKey:@"channel"];
                            trainer_channel_item.code = INT_VALUE_FROM_DIC(channel_dic, @"code");
                            trainer_channel_item.channelID = INT_VALUE_FROM_DIC(channel_dic, @"id");
                            trainer_channel_item.name = OBJ_FROM_DIC(channel_dic, @"name");
                            
                            trainer_item.channel = trainer_channel_item;
                            
                            trainer_item.dcc_visitor = INT_VALUE_FROM_DIC(trainer_item_dic, @"dcc_visitor");
                            trainer_item.email = OBJ_FROM_DIC(trainer_item_dic, @"email");
                            trainer_item.email_without_suffix = OBJ_FROM_DIC(trainer_item_dic, @"email_without_suffix");
                            trainer_item.finished_online_course_count = INT_VALUE_FROM_DIC(trainer_item_dic, @"finished_online_course_count");
                            trainer_item.first_name = OBJ_FROM_DIC(trainer_item_dic, @"first_name");
                            trainer_item.fulltext_content = OBJ_FROM_DIC(trainer_item_dic, @"fulltext_content");
                            trainer_item.function = OBJ_FROM_DIC(trainer_item_dic, @"function");
                            trainer_item.gender = OBJ_FROM_DIC(trainer_item_dic, @"gender");
                            
                            BJHeadPhotoItem* trainer_headphoto_item = [[BJHeadPhotoItem alloc] init];
                            NSDictionary* headphoto_dic = [trainer_item_dic objectForKey:@"head_photo"];
                            trainer_headphoto_item.ext = OBJ_FROM_DIC(headphoto_dic, @"ext");
                            trainer_headphoto_item.file_ext = OBJ_FROM_DIC(headphoto_dic, @"file_ext");
                            trainer_headphoto_item.full_path = OBJ_FROM_DIC(headphoto_dic, @"full_path");
                            trainer_headphoto_item.photoID = INT_VALUE_FROM_DIC(headphoto_dic, @"id");
                            trainer_headphoto_item.name = OBJ_FROM_DIC(headphoto_dic, @"name");
                            trainer_headphoto_item.original_name = OBJ_FROM_DIC(headphoto_dic, @"original_name");
                            trainer_headphoto_item.path = OBJ_FROM_DIC(headphoto_dic, @"path");
                            trainer_headphoto_item.temp = INT_VALUE_FROM_DIC(headphoto_dic, @"temp");
                            trainer_headphoto_item.upload_time = OBJ_FROM_DIC(headphoto_dic, @"upload_time");
                            trainer_item.headPhotoItem =  trainer_headphoto_item;
                            
                            trainer_item.head_photo_path = OBJ_FROM_DIC(trainer_item_dic, @"head_photo_path");
                            trainer_item.photoBelowID = INT_VALUE_FROM_DIC(trainer_item_dic, @"id");
                            trainer_item.job_band = INT_VALUE_FROM_DIC(trainer_item_dic, @"job_band");
                            trainer_item.known_as = OBJ_FROM_DIC(trainer_item_dic, @"known_as");
                            trainer_item.last_name = OBJ_FROM_DIC(trainer_item_dic, @"last_name");
                            trainer_item.learn_count = INT_VALUE_FROM_DIC(trainer_item_dic, @"learn_count");
                            trainer_item.location = OBJ_FROM_DIC(trainer_item_dic, @"location");
                            trainer_item.mac = OBJ_FROM_DIC(trainer_item_dic, @"mac");
                            trainer_item.manager_email = OBJ_FROM_DIC(trainer_item_dic, @"manager_email");
                            trainer_item.market = OBJ_FROM_DIC(trainer_item_dic, @"market");
                            trainer_item.mobile = OBJ_FROM_DIC(trainer_item_dic, @"mobile");
                            trainer_item.name = OBJ_FROM_DIC(trainer_item_dic, @"name");
                            trainer_item.online_course_comment_count = INT_VALUE_FROM_DIC(trainer_item_dic, @"online_course_comment_count");
                            trainer_item.point = INT_VALUE_FROM_DIC(trainer_item_dic, @"point");
                            trainer_item.point_rank = INT_VALUE_FROM_DIC(trainer_item_dic, @"point_rank");
                            trainer_item.positive_point = INT_VALUE_FROM_DIC(trainer_item_dic, @"positive_point");
                            trainer_item.super_admin = INT_VALUE_FROM_DIC(trainer_item_dic, @"super_admin");
                            
                            [courseItemArray addObject:trainer_item];
                            [trainer_item release];
                        }
                        
                        course_item.trainerItemArray = courseItemArray;
                        
                        [coursesArray addObject:course_item];
                        [course_item release];
                        
                        if (i == 0) {
                            [_calendar initCalendarLayer:@"2014-06-14" endDate:@"2014-06-14" status:0 title:@"test1" contentIndex:i];
                        }
                     
                    }
                }
                _calendar.coursesArray = coursesArray;
                _yearCalendarView.coursesArray = coursesArray;
//                [_yearCalendarView refreshTable];
                
                NSDictionary *propertyDic = [resultDic objectForKey:@"property"];
//                NSString* is_list = OBJ_FROM_DIC(propertyDic, @"is_list");
//                NSString* is_next = OBJ_FROM_DIC(propertyDic, @"is_next");
//                NSString* obj_name = OBJ_FROM_DIC(propertyDic, @"obj_name");
//                NSString* total_size = OBJ_FROM_DIC(propertyDic, @"total_size");
            }
            break;
        }
        case PG_GET_NEWSLIST:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                if (resultDic) {
                    NSArray* listArray = [resultDic objectForKey:@"list"];
                    
                    NSMutableArray* imagearr = [[NSMutableArray alloc] initWithCapacity:10];
                    
                    if (listArray) {
                        for (int i = 0; i < [listArray count]; i++) {
                            NSDictionary* itemDic = [listArray objectAtIndex:i];
                            NSString* content = [itemDic objectForKey:@"content"];
                            NSString* ID = [itemDic objectForKey:@"id"];
                            NSString* setting_time = [itemDic objectForKey:@"setting_time"];
                            NSString* short_content = [itemDic objectForKey:@"short_content"];
                            NSString* string_time = [itemDic objectForKey:@"string_time"];
                            NSString* title_pic = [itemDic objectForKey:@"title_pic"];
                            NSString* topic = [itemDic objectForKey:@"topic"];
                            NSString* type = [itemDic objectForKey:@"type"];
                        }
                    }
                }
                
            }
            
            break;
        }
        case LOAD_IMAGE_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self fetchContentFromMOC];
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                [[ProjectDBManager instance] upinsertInfomationImageWall:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
            }
            
            break;
        }
            
            
        case LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                
                NSArray *arr = OBJ_FROM_DIC(contentDic, @"list1");
                
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"内容已删除", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            break;
        }
            
        case HOT_ATTENTION_TYPE:
        {
            NSDictionary *resultDic = [result objectFromJSONData];
            NSInteger ret = [JSONParser parserResponseDic:resultDic
                                        connectorDelegate:self
                                                      url:url];
            NSLog(@"resultDic ===== %@",resultDic);
            
            
            if (ret == SUCCESS_CODE)
            {
                
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [super connectDone:result url:url contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end

/*************************BJCouserDataDetail*****************/
@implementation BJTrainerChannelItem

@synthesize code = _code;
@synthesize channelID = _channelID;
@synthesize name = _name;

- (void)dealloc
{
    [_name release];
    
    [super dealloc];
}

@end

@implementation BJHeadPhotoItem

@synthesize ext = _ext;
@synthesize file_ext = _file_ext;
@synthesize full_path = _full_path;
@synthesize photoID = _photoID;
@synthesize name = _name;
@synthesize original_name = _original_name;
@synthesize path = _path;
@synthesize temp = _temp;
@synthesize upload_time = _upload_time;

- (void)dealloc
{
    [_ext release];
    [_file_ext release];
    [_full_path release];
    [_name release];
    [_original_name release];
    [_path release];
    [_upload_time release];
    
    [super dealloc];
}

@end

@implementation BJTrainerItem

@synthesize admin_updated_mobile = _admin_updated_mobile;
@synthesize black_list = _black_list;
@synthesize channel = _channel;
@synthesize dcc_visitor = _dcc_visitor;
@synthesize email = _email;
@synthesize email_without_suffix = _email_without_suffix;
@synthesize finished_online_course_count = _finished_online_course_count;
@synthesize first_name = _first_name;
@synthesize fulltext_content = _fulltext_content;
@synthesize function = _function;
@synthesize gender = _gender;
@synthesize headPhotoItem = _headPhotoItem;
@synthesize head_photo_path = _head_photo_path;
@synthesize photoBelowID = _photoBelowID;
@synthesize job_band = _job_band;
@synthesize known_as = _known_as;
@synthesize last_name = _last_name;
@synthesize learn_count = _learn_count;
@synthesize location = _location;
@synthesize mac = _mac;
@synthesize manager_email = _manager_email;
@synthesize market = _market;
@synthesize mobile = _mobile;
@synthesize name = _name;
@synthesize online_course_comment_count = _online_course_comment_count;
@synthesize point = _point;
@synthesize point_rank = _point_rank;
@synthesize positive_point = _positive_point;
@synthesize super_admin = _super_admin;

- (void)dealloc
{
    [_admin_updated_mobile release];
    [_black_list release];
    [_channel release];
    [_email release];
    [_email_without_suffix release];
    [_first_name release];
    [_fulltext_content release];
    [_function release];
    [_gender release];
    [_headPhotoItem release];
    [_head_photo_path release];
    [_known_as release];
    [_last_name release];
    [_location release];
    [_mac release];
    [_manager_email release];
    [_market release];
    [_mobile release];
    [_name release];
    
    [super dealloc];
}

@end


@implementation BJCourseItem

@synthesize course_status = _course_status;
@synthesize full_course_name = _full_course_name;
@synthesize courseID = _courseID;
@synthesize introduction = _introduction;
@synthesize status = _status;
@synthesize ssp = _ssp;
@synthesize target_slots = _target_slots;
@synthesize topic = _topic;
@synthesize trainerItemArray = _trainerItemArray;
@synthesize training_time_end = _training_time_end;
@synthesize training_time_start = _training_time_start;
@synthesize venue = _venue;
@synthesize venue_detail = _venue_detail;

- (void)dealloc
{
    [_course_status release];
    [_full_course_name release];
    [_status release];
    [_topic release];
    [_trainerItemArray release];
    [_training_time_end release];
    [_training_time_start release];
    [_venue release];
    [_venue_detail release];
    
    [super dealloc];
}

@end