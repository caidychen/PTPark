//
//  SOBaseItem.m
//  SOKit
//
//  Created by so on 16/5/30.
//  Copyright © 2016年 com.. All rights reserved.
//

#import <objc/runtime.h>
#import "SOBaseItem.h"

/**
 *  @brief  存储调用类的属性名称列表
 */
static NSMutableDictionary * _soItemPropertyKeyListDictionary = nil;

/**
 *  @brief  需要忽略的属性名称，NSObject的属性，避免死循环
 */
static NSArray * _soItemPropertyKeyIgnoreKeys = nil;

/**
 *  @brief  将属性组装成字典
 */
id SOObjectParseItem(id value) {
    //空值不向下做处理
    if(!value) {
        return (nil);
    }
    //如果是字典，直接返回
    if([value isKindOfClass:[NSDictionary class]]) {
        return (value);
    }
    //如果是item，继续分解
    if([value isKindOfClass:[SOBaseItem class]]) {
        return ([(SOBaseItem *)value dictionary]);
    }
    //如果是数组，遍历分解
    if([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *mtlArr = [NSMutableArray array];
        for(id obj in value) {
            id p = SOObjectParseItem(obj);
            if (p) {
                [mtlArr addObject:p];
            }
        }
        return (mtlArr);
    }
    //如果是单一属性，则直接返回
    return (value);
}

NSArray <NSString *> * SOPropertyKeyList(Class cls) {
    @synchronized (cls) {
        if(!cls || ![cls isSubclassOfClass:[SOBaseItem class]]) {
            return (nil);
        }
        NSString *clsName = NSStringFromClass(cls);
        if(!clsName) {
            return (nil);
        }
        if(!_soItemPropertyKeyListDictionary) {
            _soItemPropertyKeyListDictionary = [[NSMutableDictionary alloc] init];
        }
        NSMutableArray *pts = _soItemPropertyKeyListDictionary[clsName];
        if(pts) {
            return (pts);
        }
        pts = [[NSMutableArray alloc] init];
        while (cls != NULL && ![cls isEqual:[NSObject class]]) {
            @autoreleasepool {
                unsigned int outCount = 0;
                objc_property_t *property_list = class_copyPropertyList(cls, &outCount);
                for(unsigned int i = 0; i < outCount; i ++) {
                    objc_property_t p = property_list[i];
                    const char *p_name = property_getName(p);
                    NSString *key = [NSString stringWithUTF8String:p_name];
                    if(key && ![_soItemPropertyKeyIgnoreKeys containsObject:key]) {
                        [pts insertObject:key atIndex:0];
                    }
                }
                if(property_list != NULL) {
                    free(property_list);
                    property_list = NULL;
                }
                cls = class_getSuperclass(cls);
            }
        }
        [_soItemPropertyKeyListDictionary setObject:pts forKey:clsName];
        return (pts);
    }
}


@interface SOKillErrorObj : NSObject
@end
@implementation SOKillErrorObj
@end
static SOKillErrorObj *killErrorObj = nil;
SOKillErrorObj * SOSharedKillErrorObj() {
    if(!killErrorObj) {
        killErrorObj = [[SOKillErrorObj alloc] init];
    }
    return (killErrorObj);
}

@implementation SOBaseItem

#pragma mark - life cycle
+ (void)load {
    _soItemPropertyKeyIgnoreKeys = [@[@"hash",
                                        @"superclass",
                                        @"description",
                                        @"debugDescription"] copy];
}

/**
 *  @brief  类方法
 */
+ (instancetype)item {
    return ([[[self class] alloc] init]);
}

/**
 *  @brief  类方法，从字典初始化
 */
+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary {
    return ([[self alloc] initWithDictionary:dictionary]);
}

/**
 *  @brief  从字典初始化
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if(self) {
        if(!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
            return (self);
        }
        //遍历元素
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            if(!key || !value || [value isKindOfClass:[NSNull class]]) {
                return;
            }
            //如果是字典，尝试解下一层
            if([value isKindOfClass:[NSDictionary class]]) {
                Class parseClass = [self parseClassWithKey:key];
                if(!parseClass || ![parseClass isSubclassOfClass:[SOBaseItem class]]) {
                    [self setValue:value forKey:key];
                    return;
                }
                id subItem = [parseClass itemWithDictionary:value];
                [self setValue:subItem forKey:key];
                return;
            }
            //如果是数组，尝试解下一层
            if([value isKindOfClass:[NSArray class]]) {
                Class parseClass = [self parseClassWithKey:key];
                if(!parseClass || ![parseClass isSubclassOfClass:[SOBaseItem class]]) {
                    [self setValue:value forKey:key];
                    return;
                }
                NSArray *valueArray = (NSArray *)value;
                NSArray *subItems = [NSArray itemsWithItemClass:parseClass JSONArray:valueArray];
                [self setValue:subItems forKey:key];
                return;
            }
            [self setValue:value forKey:key];
        }];
    }
    return (self);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return (self);
}
#pragma mark -

#pragma mark - override
- (NSUInteger)hash {
    __block NSUInteger hh = 0;
    NSArray *ptlist = SOPropertyKeyList([self class]);
    [ptlist enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKey:key];
        if(!value) {
            return;
        }
        hh ^= [value hash];
    }];
    return (hh);
}

- (NSString *)description {
    NSString *hs = [NSString stringWithFormat:@"\n<%s : %p;\n", object_getClassName(self), self];
    NSArray *keys = SOPropertyKeyList([self class]);
    NSDictionary *dict = [self dictionaryWithValuesForKeys:keys];
    if(!dict) {
        return ([hs stringByAppendingString:@">"]);
    }
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@", dict];
    [desc replaceCharactersInRange:[desc rangeOfString:@"{\n"] withString:hs];
    [desc replaceCharactersInRange:NSMakeRange([desc length] - 1, 1) withString:@">"];
    return (desc);
}
#pragma mark -

#pragma mark - getter
- (Class)parseClassWithKey:(NSString * _Nonnull)key {
    NSString *parseKey = [NSString stringWithFormat:@"%@ParseClass", key];
    Class parseClass = [self valueForKey:parseKey];
    return (parseClass);
}

/**
 *  @brief  将属性组装成字典
 */
- (NSDictionary *)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *propertyList = SOPropertyKeyList([self class]);
    for(NSString *key in propertyList) {
        id value = [self valueForKey:key];
        //装入已转换的参数
        [dict setValue:SOObjectParseItem(value) forKey:key];
    }
    return (dict);
}
#pragma mark -

#pragma mark - <NSKeyValueCoding>
- (nullable id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%s -> value undefine key:%@", object_getClassName(self), key);
    return (nil);
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s -> set value undefine key:%@", object_getClassName(self), key);
}
#pragma mark -

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    SOBaseItem *item = [[[self class] alloc] init];
    NSArray *ptlist = SOPropertyKeyList([self class]);
    [ptlist enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setValue:[self valueForKey:key] forKey:key];
    }];
    return (item);
}
#pragma mark -

#pragma mark - <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *ptlist = SOPropertyKeyList([self class]);
    [ptlist enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        NSArray *ptlist = SOPropertyKeyList([self class]);
        [ptlist enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }];
    }
    return (self);
}
#pragma mark -

#pragma mark - invocation
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL seletor = [anInvocation selector];
    if ([self respondsToSelector:seletor]) {
        [anInvocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        SOKillErrorObj *killErrorObj = SOSharedKillErrorObj();
        if(![killErrorObj respondsToSelector:aSelector]) {
            class_addMethod([killErrorObj class], aSelector, (IMP)sel_getName(aSelector), "@@:");
        }
        signature = [killErrorObj methodSignatureForSelector:aSelector];
    }
    return (signature);
}
#pragma mark -

@end



@implementation NSArray (SOItems)

+ (NSArray <__kindof SOBaseItem * > *)itemsWithItemClass:(Class)itemClass JSONArray:(NSArray <__kindof NSDictionary *> *)array {
    if(!array || ![array isKindOfClass:[NSArray class]]) {
        return (nil);
    }
    if(!itemClass || ![itemClass isSubclassOfClass:[SOBaseItem class]]) {
        itemClass = [SOBaseItem class];
    }
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        [items addObject:[itemClass itemWithDictionary:dict]];
    }
    return ([items copy]);
}

@end