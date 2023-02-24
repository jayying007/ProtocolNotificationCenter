a protocol-based notification center which is more elegant than NSNotificationCenter.

### Before
```objc
@interface Dog : NSObject
@end

@implementation Dog
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewNotify:) name:@"CustomNotificationName" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CustomNotificationName" object:nil];
}

- (void)receiveNewNotify:(NSNotification *)notification {
    NSString *param1 = (NSString *)[notification.userInfo objectForKey:@"param1"];
    NSString *param2 = (NSString *)[notification.userInfo objectForKey:@"param2"];
    int param3 = [[notification.userInfo objectForKey:@"param3"] intValue];
    NSLog(@"dog %@ %@ %d", param1, param2, param3);
}
@end
```
then post notification
```objc
NSDictionary *userInfo = @{ @"param1" : @"hello", @"param2" : @"world", @"param3" : @404 };
[[NSNotificationCenter defaultCenter] postNotificationName:@"CustomNotificationName" object:nil userInfo:userInfo];
```


### After
```objc
@protocol ExampleNotification <NSObject>
- (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3;
@end

@interface Dog : NSObject <ExampleNotification>
@end

@implementation Dog
- (instancetype)init {
    self = [super init];
    if (self) {
        ADD_OBSERVER(self, ExampleNotification);
    }
    return self;
}

- (void)dealloc {
    REMOVE_OBSERVER(self, ExampleNotification);
}

- (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3 {
    NSLog(@"dog %@ %@ %d", param1, param2, param3);
}
@end
```
then post notification
```objc
POST_NOTIFICATION(ExampleNotification, @selector(receiveNewNotify:param2:param3:), receiveNewNotify:@"hello" param2:@"world" param3:404);
```

---

if you prefer to use Swift, consider [this repo](https://github.com/100mango/SwiftNotificationCenter) 