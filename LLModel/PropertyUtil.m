//
//  PropertyUtil.m
//  LouvreModel
//
//  Created by Ömer Faruk Gül on 9/18/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "PropertyUtil.h"
#import "objc/runtime.h"

@implementation PropertyUtil

static const char * property_getTypeString( objc_property_t property )
{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
    
	static char buffer[256];
	const char * e = strchr( attrs, ',' );
	if ( e == NULL )
		return ( NULL );
    
	int len = (int)(e - attrs);
	memcpy( buffer, attrs, len );
	buffer[len] = '\0';
    
	return ( buffer );
}



+ (NSDictionary *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            //const char *propType = getPropertyType(property);
            const char *propType = property_getTypeString(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            
            NSRange range = [propertyType rangeOfString:@"T@\""];
            NSRange range2 = [propertyType rangeOfString:@"T"];
            if (range.location != NSNotFound) {
                NSRange subStrRange = NSMakeRange(range.length, propertyType.length - (range.length + 1));
                propertyType = [propertyType substringWithRange:subStrRange];
            }
            else if (range2.location != NSNotFound) {
                NSRange subStrRange = NSMakeRange(range2.length, propertyType.length - (range2.length));
                propertyType = [propertyType substringWithRange:subStrRange];
            }
            
            //NSLog(@"Prop type & name: %@ -- %@", propertyType, propertyName);
            
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

@end
