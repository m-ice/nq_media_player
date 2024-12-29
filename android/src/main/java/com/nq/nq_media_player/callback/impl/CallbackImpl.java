package com.nq.nq_media_player.callback.impl;

import androidx.annotation.Nullable;
import com.nq.nq_media_player.utils.log.Logger;
import io.flutter.plugin.common.EventChannel;
import java.util.concurrent.atomic.AtomicReference;

public class CallbackImpl {
    private static final String TAG = CallbackImpl.class.getSimpleName();
    private static volatile CallbackImpl instance;
    private final AtomicReference<EventChannel.EventSink> eventSinkRef = new AtomicReference<>();

    private CallbackImpl() {}

    public static CallbackImpl getInstance() {
        if (instance == null) {
            synchronized (CallbackImpl.class) {
                if (instance == null) {
                    instance = new CallbackImpl();
                }
            }
        }
        return instance;
    }

    public void setEventSink(@Nullable EventChannel.EventSink eventSink) {
        Logger.d(TAG, "Setting event sink: " + (eventSink != null ? "non-null" : "null"));
        eventSinkRef.set(eventSink);
    }

    public void onPlaybackConfigChanged(boolean isPlaying) {
        EventChannel.EventSink eventSink = eventSinkRef.get();
        if (eventSink != null) {
            try {
                Logger.d(TAG, "Sending playback state change: " + isPlaying);
                eventSink.success(isPlaying);
            } catch (Exception e) {
                Logger.e(TAG, "Error sending playback state: " + e.getMessage());
            }
        } else {
            Logger.w(TAG, "Event sink is null, cannot send playback state");
        }
    }
}