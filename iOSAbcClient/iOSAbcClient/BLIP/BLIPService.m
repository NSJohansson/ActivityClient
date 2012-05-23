//
//  BLIPExamples.m
//  TestApp
//
//  Created by Niklas Johansson on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLIPService.h"
#import "BLIPLocation.h"

@interface BLIPService()

@property (nonatomic, strong) RKObjectManager *BLIPclient;
@property (nonatomic, strong) NSString *MACaddress;

@end

@implementation BLIPService

@synthesize BLIPclient = _BLIPclient;
@synthesize MACaddress = _MACaddress;

-(RKObjectManager*)BLIPclient
{
    if(_BLIPclient == nil) 
    {   
        _BLIPclient = [RKObjectManager objectManagerWithBaseURL:@"http://pit.itu.dk:7331"];
        _BLIPclient.client.disableCertificateValidation = YES;
        
        [_BLIPclient.mappingProvider setSerializationMapping:[[BLIPLocation mappingForBLIPLocation] inverseMapping] forClass:[BLIPLocation class]];
        [_BLIPclient.mappingProvider addObjectMapping:[BLIPLocation mappingForBLIPLocation]];
        
        Class<RKParser> parser = [[RKParserRegistry sharedRegistry] parserClassForMIMEType:@"application/json"]; 
        [[RKParserRegistry sharedRegistry] setParserClass:parser forMIMEType:@"text/plain"]; 
    }
    return _BLIPclient;
}

-(NSString*) MACaddress
{
    if(_MACaddress == nil) _MACaddress = @"60:C5:47:35:4D:62";
    
    return _MACaddress;
}

-(void) getLocation: (id<RKObjectLoaderDelegate>) delegate
{
    
    RKObjectMapping* locationMapping = [self.BLIPclient.mappingProvider objectMappingForClass:[BLIPLocation class]];

    [self.BLIPclient loadObjectsAtResourcePath:[@"/location-of/" stringByAppendingString:self.MACaddress] objectMapping:locationMapping delegate:delegate];

//    [self.BLIPclient loadObjectsAtResourcePath:[@"/location-of/" stringByAppendingString:@"001F5B7A71E0"] objectMapping:locationMapping delegate:delegate];
}

-(void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"\n\n objectLoader didLoadObjects\n\n");
    
    for (NSObject *obj in objects) {
        if([obj isKindOfClass:[BLIPLocation class]])
        {
            NSLog(@"\n%@\n",[obj description]);
        }
        else
        {
            NSLog(@"\n%@\n",[obj description]);
        }
    }
}   

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSLog(@"\n\n objectLoader didFailWithError\n\n");
    
    NSString *msg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    NSLog(@"log : %@",msg);
}

@end
