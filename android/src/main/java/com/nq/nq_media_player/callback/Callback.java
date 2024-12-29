package com.nq.nq_media_player.callback;

import io.flutter.plugin.common.EventChannel;

public interface Callback {
    void onPlaybackConfigChanged(boolean isMusicOn);

    void setEventSink(EventChannel.EventSink eventSink);
}