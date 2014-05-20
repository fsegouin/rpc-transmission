//
//  FSTorrent.h
//  rpctransmission
//
//  Created by Florent Segouin on 12/15/13.
//  Copyright (c) 2013 Florent Segouin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTorrent : NSObject

@property (retain, nonatomic) NSNumber *identifier;
@property (retain, nonatomic) NSNumber *status;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSNumber *rateDownload;
@property (retain, nonatomic) NSNumber *rateUpload;
@property (retain, nonatomic) NSNumber *seeders;
@property (retain, nonatomic) NSNumber *leechers;
@property (retain, nonatomic) NSNumber *activityDate;
@property (retain, nonatomic) NSNumber *percentDone;
@property (retain, nonatomic) NSNumber *peersSendingToUs;
@property (retain, nonatomic) NSNumber *peersGettingFromUs;
@property (retain, nonatomic) NSNumber *peersConnected;
@property (retain, nonatomic) NSNumber *eta;
@property (retain, nonatomic) NSNumber *totalSize;
@property (retain, nonatomic) NSNumber *sizeWhenDone;
@property (retain, nonatomic) NSNumber *leftUntilDone;
@property (retain, nonatomic) NSNumber *uploadedEver;
@property (retain, nonatomic) NSNumber *uploadRatio;

@end
