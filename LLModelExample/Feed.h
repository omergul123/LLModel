//
//  Feed.h
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/23/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "BaseModel.h"

@interface Feed : BaseModel
@property (strong, nonatomic) NSNumber *feedId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *createdAt;
@end
