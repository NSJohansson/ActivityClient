//
//  DropboxTableViewController.h
//  iOSAbcClient
//
//  Created by pitlab on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>
#import <UIKit/UIKit.h>

@protocol DropboxTableViewDelegate <NSObject>
-(void)canceled:(id)sender;
-(void)choseFileWithPublicPath:(NSString*)path;
@end

@interface DropboxTableViewController : UITableViewController <DBRestClientDelegate>
@property (nonatomic, strong) id <DropboxTableViewDelegate> delegate;
@property (nonatomic, strong) NSString *path;
@end
