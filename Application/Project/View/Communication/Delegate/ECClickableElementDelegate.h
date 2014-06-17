//
//  ECClickableElementDelegate.h
//  Project
//
//  Created by Peter on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ECClickableElementDelegate <NSObject>

@optional
- (void)openImage:(UIImage *)image;
- (void)openImageUrl:(NSString *)imageUrl;
- (void)openImageUrl:(NSString *)imageUrl imageCaption:(NSString *)imageCaption;
- (void)openUrl:(NSString *)url;
- (void)openProfile:(NSString*)userId userType:(NSString*)userType;
- (void)openTraceMap;
- (void)addComment;
- (void)deletePost;
- (void)goPostClub:(id)sender;

#pragma mark - photo in post/Q&A
- (void)editPhoto;
- (void)clearPhoto;

#pragma mark - user list
- (void)openLikers;
- (void)openCheckinAlumnus;

#pragma mark - user profile
- (void)browsePoints;
- (void)browseFavoriteItems;
- (void)browseSentFeeds;
- (void)browseSentAnswers;
- (void)editProfile;
- (void)showBigPhoto:(NSString *)url;

#pragma mark - profile
- (void)addPhoto;
- (void)browseComments;
- (void)browseAlbum;
- (void)updateUsername:(NSString *)username;
- (void)share;
- (void)openKnownAlumnus;
- (void)openWithMeConnections;
- (void)addToAddressbook;
- (void)sendDirectMessage;
- (void)changeSaveStatus;
- (void)saveImage:(UIImage *)image;

#pragma mark - name card
- (void)showIndustries;

#pragma makr - tap gesture handler
- (void)tapGestureHandler;

#pragma mark - comment
- (void)sendComment:(NSString *)content;
- (void)deleteComment:(NSString *)commentId;

#pragma mark - arrange sub views
- (void)disableSubViewsOndemand;
- (void)enableSubViewOndemand;

#pragma mark - shake winner
- (void)showWinnersAndAwards;

#pragma mark - close key board
- (void)hideKeyboard;

@end
