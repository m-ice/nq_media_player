package com.nq.nq_media_player;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.nq.nq_media_player.callback.impl.CallbackImpl;
import com.nq.nq_media_player.utils.log.Logger;
import io.flutter.plugin.common.EventChannel;

public class StreamHandlerImpl implements EventChannel.StreamHandler {
    private static final String TAG = StreamHandlerImpl.class.getSimpleName();
    private EventChannel.EventSink eventSink;

    @Override
    public void onListen(Object arguments, @NonNull EventChannel.EventSink events) {
        Logger.d(TAG, "Stream handler started listening");
        eventSink = events;
        CallbackImpl.getInstance().setEventSink(eventSink);
    }

    @Override
    public void onCancel(Object arguments) {
        Logger.d(TAG, "Stream handler cancelled");
        if (eventSink != null) {
            eventSink.endOfStream();
            eventSink = null;
            CallbackImpl.getInstance().setEventSink(null);
        }
    }

    @Nullable
    public EventChannel.EventSink getEventSink() {
        return eventSink;
    }
}