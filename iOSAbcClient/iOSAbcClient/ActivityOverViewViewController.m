//
//  ActivityOverViewViewController.m
//  iOSAbcClient
//
//  Created by pitlab on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityOverViewViewController.h"
#import "ClientData.h"
#import "TestService.h"
#import "ActivityView.h"
#import "ResourceView.h"
#import "math.h"

#define IMG_SIZE 130
#define DEVICE_WIDTH 768
#define DEVICE_HEIGHT 1024

#define ITEMS_PER_ROW 3.0

@interface ActivityOverViewViewController()
-(ActivityView*)viewForActivity:(Activity*)activity :(CGFloat)x :(CGFloat)y :(CGFloat)size;
-(ActivityView*)viewForResource:(Resource*)resource :(CGFloat)x :(CGFloat)y :(CGFloat)size;
-(void)updateView;
-(void)draw;
@end


@implementation ActivityOverViewViewController
@synthesize items = _items;
@synthesize delegate = _delegate;
@synthesize activity = _activity;

-(void)setItems:(NSArray *)items {
    _items = items;
    [self updateView];
}

-(IBAction)longPressDetected:(UILongPressGestureRecognizer*)sender {
    [self.delegate viewShouldBeDismissed];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 2.0;
    [self.view addGestureRecognizer:longPressRecognizer];
    
    [self updateView];
}

-(void)viewDidLoad {
    
}

-(IBAction)tapDetected:(UIGestureRecognizer*)sender {
    if([sender.view isKindOfClass:[ActivityView class]]) {
        ActivityView *activityView = (ActivityView*)sender.view;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        ActivityOverViewViewController *aovvc = [storyboard instantiateViewControllerWithIdentifier:@"ActivityOverViewViewController"];
        aovvc.title = @"Resource Overview";
        aovvc.items = [activityView.activity getResources];
        aovvc.activity = activityView.activity;
        aovvc.delegate = self.delegate;
        
        [self.navigationController pushViewController:aovvc animated:YES];
    } else {
        ResourceView *resourceView = (ResourceView*)sender.view;
        [self.delegate choseResource:resourceView.resource forActivity:self.activity];
    }
}

-(ActivityView*)viewForActivity:(Activity*)activity :(CGFloat)x :(CGFloat)y :(CGFloat)size {
    CGRect viewRect = CGRectMake(x, y, size, size);
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:viewRect];
    activityView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    activityView.activity = activity;
    
    CGRect imgViewRect = CGRectMake((size - IMG_SIZE) / 2, (size - IMG_SIZE) / 2, IMG_SIZE, IMG_SIZE);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [ClientData categoryForActivity:activity]]];
    [activityView addSubview:imgView];
    
    CGRect labelRect = CGRectMake(0, imgViewRect.origin.y + imgViewRect.size.height, viewRect.size.width, (viewRect.size.height - imgViewRect.size.height) / 2);
    UILabel *name = [[UILabel alloc] initWithFrame:labelRect];
    name.text = activity.identity.name;
    name.textAlignment = UITextAlignmentCenter;
    name.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    [activityView addSubview:name];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [activityView addGestureRecognizer:tapRecognizer];
    
    return activityView;
}

-(ResourceView*)viewForResource:(Resource*)resource :(CGFloat)x :(CGFloat)y :(CGFloat)size {
    CGRect viewRect = CGRectMake(x, y, size, size);
    ResourceView *resourceView = [[ResourceView alloc] initWithFrame:viewRect];
    resourceView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    resourceView.resource = resource;
    
    CGRect imgViewRect = CGRectMake((size - IMG_SIZE) / 2, (size - IMG_SIZE) / 2, IMG_SIZE, IMG_SIZE);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewRect];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [ClientData categoryForResource:resource]]];
    [resourceView addSubview:imgView];
    
    CGRect labelRect = CGRectMake(0, imgViewRect.origin.y + imgViewRect.size.height, viewRect.size.width, (viewRect.size.height - imgViewRect.size.height) / 2);
    UILabel *name = [[UILabel alloc] initWithFrame:labelRect];
    name.text = resource.identity.name;
    name.textAlignment = UITextAlignmentCenter;
    name.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    [resourceView addSubview:name];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [resourceView addGestureRecognizer:tapRecognizer];
    
    return resourceView;
}

-(void)updateView {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self draw];
}

-(void)draw {
    float rows, screen_width, screen_height, item_size;

    if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        screen_width = DEVICE_WIDTH; 
        screen_height = DEVICE_HEIGHT;
    } else {
        screen_width = DEVICE_HEIGHT;
        screen_height = DEVICE_WIDTH;
    }
    
    item_size = screen_width / ITEMS_PER_ROW;
    rows = ceil((float)(self.items.count / ITEMS_PER_ROW));
    
    for (int i=0; i<rows; i++) {
        for (int j=0; j<ITEMS_PER_ROW; j++) {
            int cell = ITEMS_PER_ROW * i + j;
            if(cell < self.items.count) {
                id item = [self.items objectAtIndex:cell];
                
                if([item isKindOfClass:[Activity class]]) {
                    Activity *currentActivity = item;
                    ActivityView *viewForActivity = [self viewForActivity:currentActivity :(j*item_size) :(i*item_size) :item_size];
                    [self.view addSubview:viewForActivity];
                } else {
                    Resource *currentResource = item;
                    ResourceView *viewForResource = [self viewForResource:currentResource :(j*item_size) :(i*item_size) :item_size];   
                    
                    [self.view addSubview:viewForResource];
                }
            }
        }
    }
    
    UIScrollView *scrollView = (UIScrollView*)self.view;
    
    scrollView.contentSize = CGSizeMake(ITEMS_PER_ROW * item_size, rows * item_size);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateView];
}

@end
