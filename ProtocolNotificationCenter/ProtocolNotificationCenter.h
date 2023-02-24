//
//  ProtocolNotificationCenter.h
//  ProtocolNotificationCenter
//
//  Created by janezhuang on 2023/2/24.
//

#import <Foundation/Foundation.h>

#define ADD_OBSERVER(obj, protocolName) \
    [[ProtocolNotificationCenter defaultCenter] addObserver:obj protocol:@protocol(protocolName)]

#define REMOVE_OBSERVER(obj, protocolName) \
    [[ProtocolNotificationCenter defaultCenter] removeObserver:obj protocol:@protocol(protocolName)]

#define POST_NOTIFICATION(protocolName, sel, method) \
    [[ProtocolNotificationCenter defaultCenter] postNotification:@protocol(protocolName) selector:sel action:^(id _Nonnull observer) { [observer method]; }]

@interface ProtocolNotificationCenter : NSObject

+ (instancetype)defaultCenter;

- (void)addObserver:(id)observer protocol:(Protocol *)protocol;
- (void)removeObserver:(id)observer protocol:(Protocol *)protocol;
- (void)postNotification:(Protocol *)protocol selector:(SEL)selector action:(void(^)(id observer))action;

@end
