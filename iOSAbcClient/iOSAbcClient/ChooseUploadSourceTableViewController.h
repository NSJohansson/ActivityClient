//
//  ChooseUploadSourceTableViewController.h
//  iOSAbcClient
//
//  Created by pitlab on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Resource.h"
#import "ModalViewDelegate.h"
#import "DropboxTableViewController.h"
#import "ChooseCategoryTableViewController.h"

@protocol CreateResourceDelegate <NSObject>
-(void)createdResource:(Resource*)resource;
-(void)canceledCreation:(id)sender;
@end

@interface ChooseUploadSourceTableViewController : UITableViewController <DropboxTableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DBRestClientDelegate, ChooseCategoryDelegate, UITextFieldDelegate>
@property (nonatomic, strong) id <ModalViewDelegate> modalViewDelegate;
@property (nonatomic, strong) id <CreateResourceDelegate> createResourceDelegate;
@end
