//
//  FSTorrentsViewController.h
//  rpctransmission
//
//  Created by Florent Segouin on 12/11/13.
//  Copyright (c) 2013 Florent Segouin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLRPCConnectionDelegate.h"

@interface FSTorrentsViewController : UITableViewController <NSURLConnectionDelegate>

@property (retain, nonatomic) NSArray *torrentsArray;
@property (retain, nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end
