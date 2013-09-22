//
//  LLModel.h
//  LouvreConnect
//
//  Created by Ömer Faruk Gül on 9/17/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLModel : NSObject

@property (strong, nonatomic) NSDateFormatter *mappingDateFormatter;
@property (strong, nonatomic) NSMutableArray *mappingErrors;

- (id) initWithJSON:(id)JSON;
- (void) setValuesWithMapping:(NSDictionary *)mapping andJSON:(id)JSON;

- (void)logAllMappingErrors;

@end
