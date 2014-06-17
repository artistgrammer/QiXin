//
//  IdentityAuthViewController.m
//  Project
//
//  Created by Vshare on 14-5-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "IdentityAuthViewController.h"
#import "HomeContainerViewController.h"
#import "UIColor+expanded.h"
#import <MobileCoreServices/MobileCoreServices.h>


typedef enum
{
  IDENTITY_CARD_BTN_TAG = 10,
  IDENTITY_DEGREE_BTN_TAG,
  IDENTITY_COMMIT_BTN_TAG,
}IDentityType;


@interface IdentityAuthViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@end

@implementation IdentityAuthViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight
{
    if (self = [super initWithMOC:MOC]) {
        self.parentVC =(HomeContainerViewController *) pVC;
        _viewHeight= viewHeight;
        self.title = @"认证";
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTopicLbl];
   
    [self setIdentityControl];
    
    [self.view addSubview:[self createCommitBtn]];
}


#pragma mark - Create Control

- (void)createTopicLbl
{
    float hGap = 32.5f;
    float sGap = 7.0f;
    float lblHeight = 18.0f;
    
    NSMutableArray *topicArr = [[NSMutableArray alloc]initWithObjects:@"公司为实名制",@"请提交身份认证信息", nil];
    for (int i = 0; i < 2; i ++)
    {
        UILabel *lbl = [[[UILabel alloc]init] autorelease];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont systemFontOfSize:18]];
        [lbl setText:[topicArr objectAtIndex:i]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBounds:CGRectMake(0, 0, SCREEN_WIDTH, lblHeight)];
        [lbl setCenter:CGPointMake(SCREEN_WIDTH/2, hGap + lblHeight/2 + (lblHeight + sGap)*i)];
        [self.view addSubview:lbl];
    }
    [topicArr release];
}


- (void)setIdentityControl
{
    float hGap = 108.0f;
    float gap = 11.0f;
    float lblHeight = 15.5f;
    float sGap = 162.0f;
    
    UIImage *img = [UIImage imageNamed:@"Identity_card.png"];
    float width = img.size.width;
    float height = img.size.height;

    NSMutableArray *titleArr = [[NSMutableArray alloc]initWithObjects:@"名片",@"学生证或学位信息", nil];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i + 10];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn setBounds:CGRectMake(0, 0, width, height)];
        [btn setCenter:CGPointMake(SCREEN_WIDTH/2, hGap + height/2 + sGap*i)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UILabel *lbl = [[[UILabel alloc]init] autorelease];
        [lbl setText:[titleArr objectAtIndex:i]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor colorWithHexString:@"0x333333"]];
        [lbl setBounds:CGRectMake(0, 0, SCREEN_WIDTH, lblHeight)];
        [lbl setCenter:CGPointMake(SCREEN_WIDTH/2, hGap + height + gap + lblHeight/2 + sGap*i)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:lbl];
    }
    [titleArr release];
    
}

- (UIButton *)createCommitBtn
{
    float hGap = 18.5f;
    UIImage *btnImg = [UIImage imageNamed:@"Identity_commit.png"];
    float btnWidth = btnImg.size.width;
    float btnHeight = btnImg.size.height;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTag:IDENTITY_COMMIT_BTN_TAG];
    [btn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [btn setBounds:CGRectMake(0, 0, btnWidth, btnHeight)];
    [btn setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 64 - hGap - btnHeight/2)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - ImagePicker Methods

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)canUserPickVideosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0)
    {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType])
        {
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)takePhotoFromCamera
{
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[[NSMutableArray alloc] init] autorelease];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self.navigationController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的设备不支持照相功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
}

- (void)takePhotoFromLibrary
{
    // 从相册中选取
    if ([self isPhotoLibraryAvailable])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[[NSMutableArray alloc] init] autorelease];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self.navigationController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
    }
}

#pragma mark - Action Event

- (void)showActionSheet
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
    [choiceSheet release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self takePhotoFromCamera];
    }
    else if (buttonIndex == 1)
    {
        [self takePhotoFromLibrary];
    }
}


- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case IDENTITY_CARD_BTN_TAG:
        {
            NSLog(@"Card Click");
            [self showActionSheet];
        }
            break;
        case IDENTITY_DEGREE_BTN_TAG:
        {
            NSLog(@"Degree Click");
            [self showActionSheet];
        }
            break;
        case IDENTITY_COMMIT_BTN_TAG:
        {
            NSLog(@"Commit Click");
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
