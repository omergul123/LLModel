//
//  BaseModel.m
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithJSON:(id)JSON
{
    self = [super initWithJSON:JSON];
    if(self) {
        self.mappingDateFormatter = [[NSDateFormatter alloc] init];
        [self.mappingDateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    return self;
}

@end
