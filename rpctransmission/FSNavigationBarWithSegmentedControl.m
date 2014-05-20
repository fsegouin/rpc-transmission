//
//  FSNavigationBarWithSegmentedControl.m
//  rpctransmission
//
//  Created by Florent Segouin on 12/14/13.
//  Copyright (c) 2013 Florent Segouin. All rights reserved.
//

#import "FSNavigationBarWithSegmentedControl.h"

@implementation FSNavigationBarWithSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.superview.bounds.size.width, 88.0f);
}

- (void)didAddSubview:(UIView *)subview
{
    
    [super didAddSubview:subview];
    
    [self setTitleVerticalPositionAdjustment:-44.0f forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[FSNavigationBarWithSegmentedControl class], nil] setBackgroundVerticalPositionAdjustment:-44.0f
                                                                                                                            forBarMetrics:UIBarMetricsDefault];
    
    if ([subview isKindOfClass:[UISegmentedControl class]])
    {
        CGRect frame = subview.frame;
        frame.origin.y += 44.0f;
        subview.frame = frame;
        subview.center = CGPointMake(self.superview.bounds.size.width/2, subview.center.y);
    }
}

- (void)updateNavBar:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UISegmentedControl class]]) {
//            if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//                subview.center = self.
//            else
//                subview.center = CGPointMake(160.f, subview.center.y);
            subview.center = CGPointMake(self.superview.bounds.size.width/2, subview.center.y);
//            if (!UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//                [self setFrame:CGRectMake(0, 0, 1024, 108)];
//            else
//                [self setFrame:CGRectMake(0, 0, 768, 108)];
//            [self sizeToFit];
//            NSLog(@"Bounds Width : %f", self.width);
        }
    }
}

//- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
//    NSLog(@"Pushed !");
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
