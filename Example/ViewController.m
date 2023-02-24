//
//  ViewController.m
//  Example
//
//  Created by janezhuang on 2023/2/24.
//

#import "ViewController.h"
#import <ProtocolNotificationCenter/ProtocolNotificationCenter.h>

@protocol ExampleNotification <NSObject>
- (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3;
@optional
- (void)postToDog:(NSString *)param;
- (void)postToCat:(NSString *)param;
@end


@interface Dog : NSObject <ExampleNotification>
@end

@implementation Dog
- (instancetype)init {
    self = [super init];
    if (self) {
        ADD_OBSERVER(self, ExampleNotification);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewNotify:) name:@"CustomNotificationName" object:nil];
    }
    return self;
}

- (void)dealloc {
    REMOVE_OBSERVER(self, ExampleNotification);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CustomNotificationName" object:nil];
}

- (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3 {
    NSLog(@"dog %@ %@ %d", param1, param2, param3);
}

- (void)receiveNewNotify:(NSNotification *)notification {
    NSString *param1 = (NSString *)[notification.userInfo objectForKey:@"param1"];
    NSString *param2 = (NSString *)[notification.userInfo objectForKey:@"param2"];
    int param3 = [[notification.userInfo objectForKey:@"param3"] intValue];
    NSLog(@"dog %@ %@ %d", param1, param2, param3);
}

- (void)postToDog:(NSString *)param {
    NSLog(@"%s", __func__);
}
@end

@interface Cat : NSObject <ExampleNotification>
@end
@implementation Cat
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
    NSLog(@"cat %@ %@ %d", param1, param2, param3);
}

- (void)postToCat:(NSString *)param {
    NSLog(@"%s", __func__);
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Dog *dog = [Dog new];
    Cat *cat = [Cat new];
    
    POST_NOTIFICATION(ExampleNotification, @selector(receiveNewNotify:param2:param3:), receiveNewNotify:@"hello" param2:@"world" param3:404);
    POST_NOTIFICATION(ExampleNotification, @selector(postToDog:), postToDog:@"dog");
    POST_NOTIFICATION(ExampleNotification, @selector(postToCat:), postToCat:@"cat");
    
    cat = nil;
    // now only dog receive, because cat is already released.
    POST_NOTIFICATION(ExampleNotification, @selector(receiveNewNotify:param2:param3:), receiveNewNotify:@"hello" param2:@"world" param3:505);
    
    
    NSDictionary *userInfo = @{ @"param1" : @"hello", @"param2" : @"world", @"param3" : @100 };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomNotificationName" object:nil userInfo:userInfo];
}
@end
