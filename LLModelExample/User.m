//
//  User.m
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithJSON:(id)JSON
{
    self = [super initWithJSON:JSON];
    if(self) {
        
        NSDictionary *mapping = @{@"userId":@"id",
                                  @"firstName":@"first_name",
                                  @"lastName":@"last_name",
                                  @"username":@"username",
                                  @"publicProfile":@"public_profile",
                                  @"loginCount":@"login_count",
                                  @"createdAt":@"created_at",
                                  @"address":@"address",
                                  @"feeds":@{@"key":@"feeds",@"type":@"Feed"}};
        
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
    NSString *str = [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %d - %d - %@",
                     self.userId,
                     self.firstName,
                     self.lastName,
                     self.username,
                     self.publicProfile,
                     self.loginCount,
                     [self.mappingDateFormatter stringFromDate:self.createdAt]];
    
    return str;
}

@end
