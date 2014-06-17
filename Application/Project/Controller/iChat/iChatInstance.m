//
//  iChatInstance.m
//  Project
//
//  Created by Peter on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "iChatInstance.h"
#import "QPlusAPI.h"
#import "QPlusDataBase.h"
#import "QPlusProgressHud.h"
#import "GlobalConstants.h"
#import "WXWUIUtils.h"
#import "TextConstants.h"
#import "WXWCommonUtils.h"
#import "TextPool.h"
#import "WXWTextPool.h"
#import "GoHighDBManager.h"
#import "CommunicationViewController.h"
#import "CommunicatChatViewController.h"
#import "CommunicationMessageListViewController.h"
#import "CommunicationFriendListViewController.h"
#import "WXWDebugLogOutput.h"

@interface iChatInstance ()<QPlusGeneralDelegate, QPlusSingleChatDelegate, QPlusProgressDelegate, QPlusPlaybackDelegate, QPlusGroupDelegate>

@property (nonatomic, assign) NSMutableArray *listenerArray;

@end

@implementation iChatInstance {
    NSString *_loginUserId;
    BOOL isInChat;
}

@synthesize listenerArray = _listenerArray;

static iChatInstance *instance = nil;

+ (iChatInstance *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            [instance initData];
            [instance initQplusApi];
        }
    }
    
    return instance;
}

- (void)initData
{
    _listenerArray = [[NSMutableArray alloc] init];
    
    self.index = 0;
}

//---------
//init api
-(void)initQplusApi {
    
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //[defaults setObject: @"112.5.254.118" forKey: kKeyLoginServer];
        //    [defaults setObject: @"120.193.11.114" forKey: kKeyLoginServer];
//        [defaults setObject: @"jitmarketing.f3322.org" forKey: kKeyLoginServer];
        [defaults setObject: @"112.124.68.147" forKey: kKeyLoginServer];
        [defaults setInteger:8888 forKey:kKeyLoginPort];
        [defaults synchronize];
                
        [QPlusAPI initWithAppKey:APP_KEY];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception);
    }
    @finally {
        
    }

}

-(void)dologin:(NSString *)userId {
    
    _loginUserId = userId;
    [self initQplusApi];
    //    _selfId = [[AppManager instance] getUserIdFromLocal];
    [QPlusDataBase initialize];
    [QPlusDataBase clearDatabase];
    
    
    [QPlusProgressHud showLoading];
    [QPlusAPI removeAllListeners];
    
    [QPlusAPI addSingleChatListener:self];
    [QPlusAPI addGroupListener:self];
    [QPlusAPI addGeneralListener:self];
    [QPlusAPI loginWithUserID:userId];
}

- (void)dologout
{
    [QPlusAPI removeAllListeners];
    [QPlusAPI stopPlayVoice];
    [QPlusAPI logout];
    
    isInChat = FALSE;
}

- (void)onGetFriendList:(NSArray *)friendList {
    if (friendList != nil) {
        [QPlusDataBase initFriendList:friendList];
        //        [self refreshList];
    }
}


- (void)onLoginSuccess:(BOOL)isRelogin {
    
    if(isInChat) {
        return ;
    }
    
    isInChat = YES;
    
    [QPlusAPI setAutoRelogin:YES];
    
    [QPlusProgressHud hideLoading];
    [QPlusDataBase setLoginUserID:_loginUserId];
    
//    [QPlusAPI addSingleChatListener:self];
//    [QPlusAPI addGroupListener:self];
//    [QPlusAPI addGeneralListener:self];
    
    //    [QPlusAPI setAutoRelogin:YES];
}

- (void)onLoginCanceled {
    [QPlusProgressHud hideLoading];
    if(isInChat) {
        return ;
    }
}

- (void)onLoginFailed:(QPlusLoginError)error {
    [QPlusProgressHud hideLoading];
    
    if(isInChat) {
        return ;
    }
    
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatLoginFail, nil)
                                     msgType:INFO_TY
                          belowNavigationBar:YES];
}

-(void)imRelogin
{
    [QPlusAPI logout];
    [QPlusAPI loginWithUserID:_loginUserId];
}

- (void)onLogout:(QPlusLoginError)error {
    
    if(isInChat) {
        [self imRelogin];
    } else {
        if (error != 0) {
            [QPlusAPI removeAllListeners];
            
            //ICchatLogoutFail
            [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatLogoutFail, nil)
                                             msgType:INFO_TY
                                  belowNavigationBar:YES];
        }
    }
}

#pragma mark -- receive message
-(void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString *)tarID
{
    
    if (msgList.count) {
        
        for (int i = 0; i < msgList.count; ++i) {
            QPlusMessage *message = [msgList objectAtIndex:i];
            
//            if (message.type == VOICE)
                [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
        }
        
        for (id lis in self.listenerArray) {
            if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
                CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
                [vc onGetHistoryMessageList:msgList targetType:type targetID:tarID];
                
            }
        }
    }
    
}

- (void)onPlayStart
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onPlayStart];
        }
    }
}

- (void)onPlaying:(float)duration
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onPlaying:duration];
        }
    }
}

- (void)onPlayStop
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onPlayStop];
        }
    }
}

- (void)onError
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onError];
        }
    }
}


//--------------------
- (void)onStartVoice:(QPlusMessage *)voiceMessage
{
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationViewController class]]) {
            CommunicationViewController *vc = (CommunicationViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onStartVoice:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicationMessageListViewController class]]) {
            
            CommunicationMessageListViewController *vc = (CommunicationMessageListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicationFriendListViewController class]]) {
            
            CommunicationFriendListViewController *vc = (CommunicationFriendListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
    }
}

- (void)onRecording:(QPlusMessage *)voiceMessage size:(int)dataSize duration:(long)duration
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationViewController class]]) {
            CommunicationViewController *vc = (CommunicationViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onRecording:voiceMessage size:dataSize duration:duration];
        }   
    }
}

- (void)onRecordError:(QPlusRecordError)error
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onRecordError:error];
        }
    }
}

- (void)onStopVoice:(QPlusMessage *)voiceMessage
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onStopVoice:voiceMessage];
        }
    }
}

- (void)onSendMessage:(QPlusMessage *)message result:(BOOL)isSuccessful
{
    if (message.type == TEXT) {
        debugLog(@"onSendMessage:index:%d, type:%d:text:%@", ++self.index, message.type, message.text);
        if ([message.text isEqualToString:DELETE_GROUP_MESSAGE]) {
//            int a  =0;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message.receiverID, @"groupId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO object:nil userInfo:dict];
            
            return;
        }
    }
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onSendMessage:message result:isSuccessful];
        }
    }
}

- (void)onReceiveMessage:(QPlusMessage *)message
{
    debugLog(@"onReceiveMessage:sender:%@, type:%d text:%@",message.senderID, message.type,message.text);
    
    if (message.type == TEXT) {
        
        if ([message.text isEqualToString:DELETE_GROUP_MESSAGE]) {
            
            for (id lis in self.listenerArray) {
                if ([lis isKindOfClass:[CommunicationViewController class]]) {
                    CommunicationViewController *vc = (CommunicationViewController *)lis;
                    [vc onDeleteGroupMesssage:message];
                }
                if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
                    
                    CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
                    [vc onDeleteGroupMesssage:message];
                }
            }
            
//            QPlusMessage *msg = [[[QPlusMessage alloc] init] autorelease];
//            msg.type = message.type;
//            msg.isRoomMsg = message.isRoomMsg;
//            msg.date = message.date;
//            msg.mediaObject = message.mediaObject;
//            msg.isPrivate = message.isPrivate;
//            msg.senderID = message.senderID;
//            msg.receiverID = message.receiverID;
//            
//            msg.text =LocaleStringForKey(NSGroupDeleted, nil);
            [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
            
            [[GoHighDBManager instance] deleteGroup:[message.receiverID intValue]];
            return;
        }
        
        
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
    }
    else if ( message.type == VOICE)
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
    else
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:1];
    
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationViewController class]]) {
            CommunicationViewController *vc = (CommunicationViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[CommunicationMessageListViewController class]]) {
            
            CommunicationMessageListViewController *vc = (CommunicationMessageListViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[CommunicationFriendListViewController class]]) {
            
            CommunicationFriendListViewController *vc = (CommunicationFriendListViewController *)lis;
            [vc onReceiveMessage:message];
        }
    }
    
}

- (void)onGetRes:(QPlusMessage *)message result:(BOOL)isSuccessful {
    for (id lis in self.listenerArray) {
        
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onGetRes:message result:isSuccessful];
        }
        
    }
}

- (void)onProgressUpdate:(QPlusMessage *)msgObejct percent:(float)percent
{
    for (id lis in self.listenerArray) {
        
        if ([lis isKindOfClass:[CommunicatChatViewController class]]) {
            
            CommunicatChatViewController *vc = (CommunicatChatViewController *)lis;
            [vc onProgressUpdate:msgObejct percent:percent];
        }
        
    }
    
}


-(void)sendDeleteGroupMessage:(NSString *)groupId
{
    debugLog(@"sendDeleteGroupMessage: groupID:%@", groupId);
    
    [QPlusAPI sendText:DELETE_GROUP_MESSAGE inGroup:groupId];
//    [QPlusAPI sendPicMsg:nil grou];
    
}
#pragma mark -- listener

- (void)registerListener:(id)listener
{
    for (id lis in self.listenerArray) {
        if (lis == listener) {
            return;
        }
    }
    
    [self.listenerArray addObject:listener];
}

- (void)unRegisterListener:(id)listener
{
    for (id lis in _listenerArray) {
        if (lis == listener) {
            [self.listenerArray removeObject:listener];
            break;
        }
    }
}

@end
