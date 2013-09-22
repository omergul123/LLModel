//
//  User.h
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"

@interface User : BaseModel
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) BOOL publicProfile;
@property (nonatomic) NSInteger loginCount;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSMutableArray *feeds;

@end
