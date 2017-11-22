//
//  SCFileUploadItem.h
//  Test
//
//  Created by Luka Li on 2017/11/22.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCFileUploadStatus) {
    SCFileUploadStatusIdle,
    SCFileUploadStatusUploading,
    SCFileUploadStatusFinished,
    SCFileUploadStatusFailed,
};

typedef NS_ENUM(NSUInteger, SCFileUploadContentType) {
    SCFileUploadContentTypeOther,
    // add if needed.
};

typedef void(^SCFileUploadStatusChangedCallback)(SCFileUploadStatus status);
typedef void(^SCFileUploadProgressChangedCallback)(float progress);

@interface SCFileUploadItem : NSObject

@property (nonatomic, assign) SCFileUploadStatus status;
@property (nonatomic, assign) float progress;

@property (nonatomic, copy) SCFileUploadStatusChangedCallback onStatusChange;
@property (nonatomic, copy) SCFileUploadProgressChangedCallback onProgressChange;

/**
 Uploaded file URL when upload finished.
 */
@property (nonatomic, copy) NSString *attachURL;

/**
 Override to write upload implemention.
 */
- (void)upload;

/**
 Override to return data that you want to upload.
 */
- (NSData *)uploadingData;

/**
 Upload finished callback. Override to do something else.
 */
- (void)uploadFinished;

/**
 Use if needed.
 */
- (SCFileUploadContentType)contentType;

#pragma mark - Private

/**
 Basically no need to call.
 */
- (void)notifyStatusChanged:(SCFileUploadStatus)status;
- (void)notifyProgressChanged:(float)progress;

@end
