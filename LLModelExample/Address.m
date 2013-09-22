//
//  Address.m
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "Address.h"

@implementation Address
- (id)initWithJSON:(id)JSON
{
    self = [super initWithJSON:JSON];
    if(self) {
        
        NSDictionary *mapping = @{@"addressId":@"id",
                                  @"title":@"title"};
        
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
    NSString *str = [NSString stringWithFormat:@"%@ - %@",
                     self.addressId,
                     self.title];
    
    return str;
}

@end
