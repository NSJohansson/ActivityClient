//
//  TestService.h
//  iOSAbcClient
//
//  Created by pitlab on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"
#import "Action.h"
#import "Activity.h"
#import "Actor.h"
#import "Collaborator.h"
#import "Credentials.h"
#import "History.h"
#import "Identity.h"
#import "Metadata.h"
#import "Participant.h"
#import "Resource.h"
#import "Role.h"
#import "Service.h"
#import "Workflow.h"
#import "FileBatch.h"
#import "FileDetails.h"

@interface TestService : NSObject <RKObjectLoaderDelegate>

@property (nonatomic, strong) RKObjectManager *manager;

+(TestService*)sharedService;
-(void) getAllActivities: (id<RKObjectLoaderDelegate>) delegate;
-(void) deleteAllActivities;
-(void) deleteActivity:(NSString*)ID : (id<RKObjectLoaderDelegate>)delegate;
-(void) addActivity: (Activity*) act : (id<RKObjectLoaderDelegate>) delegate;
-(void) updateActivity: (Activity*) act withId:(NSString *)ID : (id<RKObjectLoaderDelegate>) delegate;

@end
