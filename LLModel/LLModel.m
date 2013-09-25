//
//  LLModel.m
//  LouvreModel
//
//  Created by Ömer Faruk Gül on 9/17/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "LLModel.h"
#import "PropertyUtil.h"

@interface LLModel ()
@property (strong, nonatomic) NSDictionary *reverseMappedJSON;
@end

@implementation LLModel

- (id) initWithJSON:(id)JSON
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isStringNull:(NSString *)str
{
    if(nil == str || NSNull.null == (id)str)
        return YES;
    else
        return NO;
}

- (NSError *)createError:(NSString *)errorStr
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:errorStr forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"LLModel" code:200 userInfo:details];
    return error;
}

- (void)logAllMappingErrors
{
    for(NSError *error in self.mappingErrors) {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (NSString *)description
{
    NSString *str = @"";
    
    NSDictionary *properties = [PropertyUtil classPropsFor:self.class];
    for(NSString *propertyName in properties) {
         id value = [self valueForKey:propertyName];
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", propertyName, value]];
    }
    
    return str;
}

- (NSDictionary *)reverseMapping
{
    NSMutableDictionary *JSON = [NSMutableDictionary dictionary];
    
    NSString *mappedJSONKey;
    NSString *mappedJSONType;
    
    NSDictionary *properties = [PropertyUtil classPropsFor:self.class];
    
    for (NSString* propertyName in self.mapping) {
        id mappingValue = [self.mapping objectForKey:propertyName];
        
        if([mappingValue isKindOfClass:NSDictionary.class]) {
            mappedJSONKey = [mappingValue valueForKey:@"key"];
            mappedJSONType = [mappingValue valueForKey:@"type"];
        } else {
            mappedJSONKey = mappingValue;
        }
        
        NSString *propertyType = [properties valueForKey:propertyName];

        id value = [self valueForKey:propertyName];
        
        // NSDate
        if([propertyType isEqualToString:@"NSDate"]) {
            
            if(!self.mappingDateFormatter) {
                continue;
            }
            
            value = [self.mappingDateFormatter stringFromDate:value];
        }
        // NSURL
        else if([propertyType isEqualToString:@"NSURL"]) {
            NSURL *url = value;
            value = [url absoluteString];
        }
        // NSArray, NSMutableArray
        else if([propertyType isEqualToString:@"NSArray"] ||
                [propertyType isEqualToString:@"NSMutableArray"]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for(id LLObject in value) {
                SEL selector = NSSelectorFromString(@"reverseMapping");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[LLModel class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:LLObject];
                [invocation invoke];
                NSDictionary *returnValue;
                [invocation getReturnValue:&returnValue];
                
                [arr addObject:returnValue];
            }
            
            value = arr;
            
        }
        // Other LLModel or an unidentified value
        else {
            BOOL isLLModel = [NSClassFromString(propertyType) isSubclassOfClass:[LLModel class]];
            if(isLLModel) {
                SEL selector = NSSelectorFromString(@"reverseMapping");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[LLModel class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:value];
                [invocation invoke];
                NSDictionary *returnValue;
                [invocation getReturnValue:&returnValue];
                
                value = returnValue;

            }
            else {
                // do nothing
            }
        }

        
        [JSON setValue:value forKey:propertyName];
    }
    
    self.reverseMappedJSON = JSON;
    
    return self.reverseMappedJSON;
}

- (void)setValuesWithMapping:(NSDictionary *)mapping andJSON:(id)JSON
{
    NSLog(@"Beginning setting!");
    self.mapping = mapping;
    self.mappingErrors = [NSMutableArray array];
    
    NSLog(@"Before properties!");
    NSDictionary *properties = [PropertyUtil classPropsFor:self.class];
    
    NSLog(@"After properties!");
    
    for(NSString *propertyName in properties) {
        
        if([propertyName isEqualToString:@"mappingError"])
            continue;
        
        NSString *mappedJSONKey;
        NSString *mappedJSONType;
        
        NSString *propertyType = [properties valueForKey:propertyName];
        
        id mappingValue = [mapping valueForKey:propertyName];
        
        if([mappingValue isKindOfClass:NSDictionary.class]) {
            mappedJSONKey = [mappingValue valueForKey:@"key"];
            mappedJSONType = [mappingValue valueForKey:@"type"];
        } else {
            mappedJSONKey = mappingValue;
        }
        
        // Check if there is mapping for the property
        if([self isStringNull:mappedJSONKey]) {
            // No mapping so just continue
            continue;
        }
        
        
        // Get JSON value for the mapped key
        id value = [JSON valueForKeyPath:mappedJSONKey];
        
        NSLog(@"Looking for : %@ -- %@ -- %@", propertyType, mappedJSONKey, value);
        
        // char
        if([propertyType isEqualToString:@"c"]) {
            char val = [value charValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // double
        else if([propertyType isEqualToString:@"d"]) {
            double val = [value doubleValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // float
        else if([propertyType isEqualToString:@"f"]) {
            float val = [value floatValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // integer
        else if([propertyType isEqualToString:@"i"]) {
            int val = [value intValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // long
        else if([propertyType isEqualToString:@"l"]) {
            long val = [value longValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // short
        else if([propertyType isEqualToString:@"s"]) {
            short val = [value shortValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // NSString
        else if([propertyType isEqualToString:@"NSString"]) {
            NSString *val = [NSString stringWithFormat:@"%@", value];
            [self setValue:val forKey:propertyName];
        }
        // NSNumber
        else if([propertyType isEqualToString:@"NSNumber"]) {
            NSInteger val = [value integerValue];
            [self setValue:@(val) forKey:propertyName];
        }
        // NSDate
        else if([propertyType isEqualToString:@"NSDate"]) {
            
            if(!self.mappingDateFormatter) {
                NSString *errorStr = [NSString stringWithFormat:@"No date formetter is defined. Property '%@' could not be assigned.", propertyName];
                NSError *error = [self createError:errorStr];
                [self.mappingErrors addObject:error];
                continue;
            }
            
            NSString *str = [NSString stringWithFormat:@"%@", value];
            NSDate *val = [self.mappingDateFormatter dateFromString:str];
            [self setValue:val forKey:propertyName];
        }
        // NSURL
        else if([propertyType isEqualToString:@"NSURL"]) {
            NSString *str = [NSString stringWithFormat:@"%@", value];
            NSURL *val = [NSURL URLWithString:str];
            [self setValue:val forKey:propertyName];
        }
        // NSArray, NSMutableArray
        else if([propertyType isEqualToString:@"NSArray"] ||
                [propertyType isEqualToString:@"NSMutableArray"]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for(id JSONObject in value) {
                LLModel *val = [[NSClassFromString(mappedJSONType) alloc] initWithJSON:JSONObject];
                [arr addObject:val];
            }
            
            [self setValue:arr forKey:propertyName];
            
        }
        // Other LLModel or an unidentified value
        else {
            BOOL isLLModel = [NSClassFromString(propertyType) isSubclassOfClass:[LLModel class]];
            if(isLLModel) {
                LLModel *val = [[NSClassFromString(propertyType) alloc] initWithJSON:value];
                [self setValue:val forKey:propertyName];
            }
            else {
                NSString *errorStr = [NSString stringWithFormat:@"Property '%@' could not be assigned any value.", propertyName];
                NSError *error = [self createError:errorStr];
                [self.mappingErrors addObject:error];
            }
        }
        
    }

}

@end
