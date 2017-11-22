//
//  SCFileUploadItem.m
//  Test
//
//  Created by Luka Li on 2017/11/22.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCFileUploadItem.h"

@interface SCFileUploadItem ()

@end

@implementation SCFileUploadItem

- (void)upload
{
    NSData *data = [self uploadingData];
    if (!data.length) {
        [self notifyStatusChanged:SCFileUploadStatusFailed];
        return;
    }
    
    [self notifyStatusChanged:SCFileUploadStatusUploading];
    
    /*
     Upload code.
     
     on success:
     
     self.attachURL = uploadURL;
     [self uploadFinished];
     [self notifyStatusChanged:SCFileUploadStatusFinished];
     
     on failure:
     
     self.attachURL = nil;
     [self notifyStatusChanged:SCFileUploadStatusFailed];
     
     on progress:
     
     [self notifyProgressChanged:progress];
     */
}

- (NSData *)uploadingData
{
    NSAssert(NO, @"Must Override");
    return nil;
}

- (void)uploadFinished
{
    
}

- (SCFileUploadContentType)contentType
{
    return SCFileUploadContentTypeOther;
}

- (void)notifyStatusChanged:(SCFileUploadStatus)status
{
    self.status = status;
    if (self.onStatusChange) {
        self.onStatusChange(status);
    }
}

- (void)notifyProgressChanged:(float)progress
{
    if (progress < 0) {
        progress = 0;
    }
    
    if (progress > 1) {
        progress = 1;
    }
    
    self.progress = progress;
    if (self.onProgressChange) {
        self.onProgressChange(progress);
    }
}

@end

