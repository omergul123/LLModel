//
//  Feed.m
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithJSON:(id)JSON
{
    self = [super initWithJSON:JSON];
    if(self) {
        
        NSDictionary *mapping = @{@"feedId":@"id",
                                  @"title":@"title",
                                  @"createdAt":@"created_at"};
        
        [self setValuesWithMapping:mapping andJSON:JSON];
        
        // check if there are any errors
        if(self.mappingErrors.count > 0) {
            [self logAllMappingErrors];
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@ - %@ - %@",
                     self.feedId,
                     self.title,
                     [self.mappingDateFormatter stringFromDate:self.createdAt]];
    
    return str;
}

@end
