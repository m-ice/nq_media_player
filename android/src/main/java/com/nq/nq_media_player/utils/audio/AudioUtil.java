package com.nq.nq_media_player.utils.audio;

import android.content.Context;
import android.media.AudioManager;
import android.media.AudioPlaybackConfiguration;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import com.nq.nq_media_player.callback.impl.CallbackImpl;
import com.nq.nq_media_player.utils.log.Logger;
import java.lang.ref.WeakReference;
import java.util.List;

public class AudioUtil {
    private static final String TAG = AudioUtil.class.getSimpleName();
    private static final long DEBOUNCE_TIME = 200; // 防抖时间
    private static final long DELAY_TIME = 1000; // 延迟回调时间

    private static volatile AudioUtil instance;
    private AudioManager audioManager;
    private final Handler handler;
    private AudioManager.AudioPlaybackCallback callback;
    private long lastCallTime = 0;
    private boolean isInitialized = false;

    private AudioUtil() {
        handler = new Handler(Looper.getMainLooper());
    }

    public static AudioUtil getInstance() {
        if (instance == null) {
            synchronized (AudioUtil.class) {
                if (instance == null) {
                    instance = new AudioUtil();
                }
            }
        }
        return instance;
    }

    public void init(@NonNull WeakReference<Context> contextWeakReference) {
        try {
            Context context = contextWeakReference.get();
            if (context == null) {
                Logger.e(TAG, "Context is null");
                return;
            }

            audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
            if (audioManager == null) {
                Logger.e(TAG, "Failed to get AudioManager");
                return;
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                registerAudioCallback();
            }
            
            isInitialized = true;
            Logger.d(TAG, "AudioUtil initialized successfully");
        } catch (Exception e) {
            Logger.e(TAG, "Init error: " + e.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void registerAudioCallback() {
        callback = new AudioManager.AudioPlaybackCallback() {
            @Override
            public void onPlaybackConfigChanged(List<AudioPlaybackConfiguration> configs) {
                super.onPlaybackConfigChanged(configs);
                handlePlaybackConfigChanged();
            }
        };
        audioManager.registerAudioPlaybackCallback(callback, handler);
    }

    private void handlePlaybackConfigChanged() {
        long now = System.currentTimeMillis();
        if (now - lastCallTime < DEBOUNCE_TIME) {
            lastCallTime = now;
            Logger.d(TAG, "Skipping callback due to debounce");
            return;
        }

        lastCallTime = now;
        Logger.d(TAG, "Scheduling delayed callback");
        handler.removeCallbacksAndMessages(null);
        handler.postDelayed(() -> {
            boolean isActive = isMusicActive();
            Logger.d(TAG, "Sending playback state: " + isActive);
            CallbackImpl.getInstance().onPlaybackConfigChanged(isActive);
        }, DELAY_TIME);
    }

    public void playOrPauseMusic() {
        sendMediaButton(KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE);
    }

    public void nextMusic() {
        sendMediaButton(KeyEvent.KEYCODE_MEDIA_NEXT);
    }

    public void lastMusic() {
        sendMediaButton(KeyEvent.KEYCODE_MEDIA_PREVIOUS);
    }

    public boolean isMusicActive() {
        if (!isInitialized || audioManager == null) {
            Logger.d(TAG, "AudioManager not initialized");
            return false;
        }
        try {
            boolean isActive = audioManager.isMusicActive();
            Logger.d(TAG, "Music active state: " + isActive);
            return isActive;
        } catch (Exception e) {
            Logger.e(TAG, "Error checking music state: " + e.getMessage());
            return false;
        }
    }

    private void sendMediaButton(int keyCode) {
        if (!isInitialized || audioManager == null) {
            Logger.e(TAG, "Cannot send media button - not initialized");
            return;
        }

        try {
            Logger.d(TAG, "Sending media button: " + keyCode);
            KeyEvent keyEventDown = new KeyEvent(KeyEvent.ACTION_DOWN, keyCode);
            audioManager.dispatchMediaKeyEvent(keyEventDown);

            KeyEvent keyEventUp = new KeyEvent(KeyEvent.ACTION_UP, keyCode);
            audioManager.dispatchMediaKeyEvent(keyEventUp);
            Logger.d(TAG, "Media button sent successfully");
        } catch (Exception e) {
            Logger.e(TAG, "Error sending media button: " + e.getMessage());
        }
    }

    public void close() {
        Logger.d(TAG, "Closing AudioUtil");
        try {
            if (handler != null) {
                handler.removeCallbacksAndMessages(null);
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (audioManager != null && callback != null) {
                    audioManager.unregisterAudioPlaybackCallback(callback);
                }
            }

            audioManager = null;
            callback = null;
            isInitialized = false;
            Logger.d(TAG, "AudioUtil closed successfully");
        } catch (Exception e) {
            Logger.e(TAG, "Error closing AudioUtil: " + e.getMessage());
        }
    }
}
