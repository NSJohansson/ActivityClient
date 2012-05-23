//
//  BLIPExamples.h
//  TestApp
//
//  Created by Niklas Johansson on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

@interface BLIPService : NSObject <RKObjectLoaderDelegate>

-(void) getLocation: (id<RKObjectLoaderDelegate>) delegate;

@end
