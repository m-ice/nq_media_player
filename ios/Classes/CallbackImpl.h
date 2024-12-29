#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallbackImpl : NSObject

+ (instancetype)shared;
- (void)onPlaybackConfigChanged:(BOOL)isPlaying;
- (void)setEventSink:(nullable FlutterEventSink)eventSink;

@end

NS_ASSUME_NONNULL_END 