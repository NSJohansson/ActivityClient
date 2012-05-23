//
//  TestService.m
//  iOSAbcClient
//
//  Created by pitlab on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestService.h"

@interface TestService()
@property (nonatomic) BOOL shouldDeleteAll;
@end

@implementation TestService
@synthesize manager = _manager;
@synthesize shouldDeleteAll = _shouldDeleteAll;


static TestService *singleton = nil;

+(TestService*)sharedService {
    if(singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

//+(TestService*)sharedService {
//   static TestService *singleton = nil;
//    @synchronized(self) {
//        if(singleton == nil) {
//            singleton = [[TestService alloc] init];
//        }
//    }
//    return singleton;
//}

-(void) setSerialization: (RKObjectMappingProvider*) mappingProvider {
    [mappingProvider setSerializationMapping:[[Action mappingForAction] inverseMapping] forClass:[Action class]];
    [mappingProvider setSerializationMapping:[[Activity mappingForActivity] inverseMapping] forClass:[Activity class]];
    [mappingProvider setSerializationMapping:[[Actor mappingForActor] inverseMapping] forClass:[Actor class]];
    [mappingProvider setSerializationMapping:[[Collaborator mappingForCollaborator] inverseMapping] forClass:[Collaborator class]];
    [mappingProvider setSerializationMapping:[[Credentials mappingForCredentials] inverseMapping] forClass:[Credentials class]];
    [mappingProvider setSerializationMapping:[[History mappingForHistory] inverseMapping] forClass:[History class]];
    [mappingProvider setSerializationMapping:[[Identity mappingForIdentity] inverseMapping] forClass:[Identity class]];
    [mappingProvider setSerializationMapping:[[Metadata mappingForMetadata] inverseMapping] forClass:[Metadata class]];
    [mappingProvider setSerializationMapping:[[Participant mappingForParticipant] inverseMapping] forClass:[Participant class]];
    [mappingProvider setSerializationMapping:[[Resource mappingForResource] inverseMapping] forClass:[Resource class]];
    [mappingProvider setSerializationMapping:[[Role mappingForRole] inverseMapping] forClass:[Role class]];
    [mappingProvider setSerializationMapping:[[Service mappingForService] inverseMapping] forClass:[Service class]];
    [mappingProvider setSerializationMapping:[[Workflow mappingForWorkflow] inverseMapping] forClass:[Workflow class]];
    [mappingProvider setSerializationMapping:[[FileDetails mappingForFileDetails] inverseMapping] forClass:[FileDetails class]];
    [mappingProvider setSerializationMapping:[[FileBatch mappingForFileBatch] inverseMapping] forClass:[FileBatch class]];
}

-(void) setObjectMapping: (RKObjectMappingProvider*) mappingProvider {   
    [mappingProvider setMapping:[Action mappingForAction] forKeyPath:@"Actions"];
    [mappingProvider setMapping:[Activity mappingForActivity] forKeyPath:@"Activity"];
    [mappingProvider setMapping:[Actor mappingForActor] forKeyPath:@"Actor"];
    [mappingProvider setMapping:[Collaborator mappingForCollaborator] forKeyPath:@"Collaborator"];
    [mappingProvider setMapping:[Credentials mappingForCredentials] forKeyPath:@"Credentials"];
    [mappingProvider setMapping:[History mappingForHistory] forKeyPath:@"History"];
    [mappingProvider setMapping:[Identity mappingForIdentity] forKeyPath:@"Identity"];
    [mappingProvider setMapping:[Metadata mappingForMetadata] forKeyPath:@"Meta"];
    [mappingProvider setMapping:[Participant mappingForParticipant] forKeyPath:@"Participant"];
    [mappingProvider setMapping:[Resource mappingForResource] forKeyPath:@"Resource"];
    [mappingProvider setMapping:[Role mappingForRole] forKeyPath:@"Role"];
    [mappingProvider setMapping:[Service mappingForService] forKeyPath:@"Service"];
    [mappingProvider setMapping:[Workflow mappingForWorkflow] forKeyPath:@"Workflow"];
    [mappingProvider setMapping:[FileDetails mappingForFileDetails] forKeyPath:@"FileDetails"];
    [mappingProvider setMapping:[FileBatch mappingForFileBatch] forKeyPath:@"FileBatch"];
    [mappingProvider addObjectMapping:[Activity mappingForActivity]];
    [mappingProvider addObjectMapping:[Action mappingForAction]];
    [mappingProvider addObjectMapping:[Resource mappingForResource]];
    [mappingProvider addObjectMapping:[FileDetails mappingForFileDetails]];
}

-(RKObjectManager*)manager
{
    if(_manager == nil) 
    {
        _manager = [RKObjectManager objectManagerWithBaseURL:@"https://activitycloud.cloudapp.net/activitymanager.svc/rest"];
        _manager.client.disableCertificateValidation = YES;
        [_manager.router routeClass:[Activity class] toResourcePath:@"/Activities/:identity.ID"];
        [_manager.router routeClass:[Activity class] toResourcePath:@"/Activities" forMethod:RKRequestMethodPOST];

        [self setObjectMapping:_manager.mappingProvider];
        [self setSerialization:_manager.mappingProvider];
    }
    return _manager;
}

-(void) getAllActivities: (id<RKObjectLoaderDelegate>) delegate {    
    RKObjectMapping* activityMapping = [self.manager.mappingProvider objectMappingForClass:[Activity class]];
    [self.manager loadObjectsAtResourcePath:@"/Activities" objectMapping:activityMapping delegate:delegate];
}

-(void) deleteAllActivities{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    self.shouldDeleteAll = YES;
    [self getAllActivities:self];
}

-(void) deleteActivity: (NSString*) ID : (id<RKObjectLoaderDelegate>) delegate {
    Activity *act = [[Activity alloc] init];
    act.identity.ID = ID;
    [self.manager deleteObject:act mapResponseWith:[[FileBatch mappingForFileBatch] inverseMapping] delegate:delegate];
}

-(void) updateActivity: (Activity*) act withId:(NSString *)ID : (id<RKObjectLoaderDelegate>) delegate
{
    //act.identity.ID = ID;
    [self.manager setSerializationMIMEType:RKMIMETypeJSON];
    [self.manager setAcceptMIMEType:RKMIMETypeJSON];
    [self.manager putObject:act mapResponseWith:[[FileBatch mappingForFileBatch] inverseMapping] delegate:delegate];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if(self.shouldDeleteAll) {
        for (Activity *obj in objects) {
            if([obj isKindOfClass:[Activity class]]) {
                [self deleteActivity:obj.identity.ID:self];
            }
        }
        self.shouldDeleteAll = NO;
    }
}

-(void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {

}

@end
