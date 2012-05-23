//
//  ActivityOverViewViewController.h
//  iOSAbcClient
//
//  Created by pitlab on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"
#import "Activity.h"

@protocol ActivityOverViewDelegate
-(void)viewShouldBeDismissed;
-(void)viewShouldBeDismissedWithActivity:(Activity*)activity;
-(void)choseResource:(Resource*)resource forActivity:(Activity*)activity;
@end

@interface ActivityOverViewViewController : UIViewController
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, strong) id <ActivityOverViewDelegate> delegate;
@end
