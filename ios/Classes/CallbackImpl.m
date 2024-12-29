#import "CallbackImpl.h"

@interface CallbackImpl()
@property (nonatomic, copy, nullable) FlutterEventSink eventSink;
@end

@implementation CallbackImpl

+ (instancetype)shared {
    static CallbackImpl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CallbackImpl alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"CallbackImpl initialized");
    }
    return self;
}

- (void)setEventSink:(nullable FlutterEventSink)eventSink {
    @synchronized (self) {
        if (eventSink) {
            NSLog(@"CallbackImpl: Setting new eventSink");
        } else {
            NSLog(@"CallbackImpl: Clearing eventSink");
        }
        _eventSink = eventSink;
    }
}

- (void)onPlaybackConfigChanged:(BOOL)isPlaying {
    @synchronized (self) {
        if (self.eventSink) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
                    self.eventSink(@(isPlaying));
                    NSLog(@"CallbackImpl: Sent playback state: %@", isPlaying ? @"YES" : @"NO");
                } @catch (NSException *exception) {
                    NSLog(@"CallbackImpl: Error sending event: %@", exception);
                }
            });
        } else {
            NSLog(@"CallbackImpl: eventSink is nil");
        }
    }
}

- (void)dealloc {
    NSLog(@"CallbackImpl: deallocating");
    self.eventSink = nil;
}

@end 