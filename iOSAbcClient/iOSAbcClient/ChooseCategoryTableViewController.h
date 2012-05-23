//
//  ChooseCategoryTableViewController.h
//  iOSAbcClient
//
//  Created by pitlab on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseCategoryDelegate <NSObject>
-(void)choseCategory:(NSString*)category;
@end

@interface ChooseCategoryTableViewController : UITableViewController
@property (nonatomic, strong) id <ChooseCategoryDelegate> delegate;
@property (nonatomic, strong) NSArray *categories;
@end
