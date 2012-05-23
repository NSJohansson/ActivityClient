//
//  BLIPTerminal.m
//  TestApp
//
//  Created by Niklas Johansson on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLIPLocation.h"

@implementation BLIPLocation

@synthesize ID = _ID;
@synthesize locationName = _locationName;
@synthesize timestamp = _timestamp;

+(RKObjectMapping *) mappingForBLIPLocation
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BLIPLocation class]];
    [mapping mapKeyPath:@"location" toAttribute:@"locationName"];
    [mapping mapKeyPath:@"terminal-id" toAttribute:@"ID"];
    [mapping mapKeyPath:@"last-event-timestamp" toAttribute:@"timestamp"];
    
    return mapping;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"\nBLIPTerminal:\nID: %@\nlocationName: %@\ntimestamp: %@\n", self.ID, self.locationName, self.timestamp];
}

@end
