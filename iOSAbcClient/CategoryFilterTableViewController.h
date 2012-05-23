//
//  CategoryFilterTableViewController.h
//  iOSAbcClient
//
//  Created by pitlab on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryFilterDelegate <NSObject>
-(void)choseFilter:(NSString*)filter;
@end

@interface CategoryFilterTableViewController : UITableViewController
@property (nonatomic, strong) id <CategoryFilterDelegate> delegate;
@property (nonatomic, strong) NSArray *categories;
@end
