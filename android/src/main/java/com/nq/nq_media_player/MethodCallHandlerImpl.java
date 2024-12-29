package com.nq.nq_media_player;

import android.os.Build;
import androidx.annotation.NonNull;
import com.nq.nq_media_player.utils.audio.AudioUtil;
import com.nq.nq_media_player.utils.log.Logger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String TAG = MethodCallHandlerImpl.class.getSimpleName();

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Method called: " + call.method);
        
        try {
            switch (call.method) {
                case "getPlatformVersion":
                    handleGetPlatformVersion(result);
                    break;
                case "switchMusicOn":
                    handleSwitchMusic(result);
                    break;
                case "isMusicOn":
                    handleIsMusicOn(result);
                    break;
                case "nextMusic":
                    handleNextMusic(result);
                    break;
                case "lastMusic":
                    handleLastMusic(result);
                    break;
                default:
                    Logger.w(TAG, "Method not implemented: " + call.method);
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            Logger.e(TAG, "Error handling method call: " + e.getMessage());
            result.error("INTERNAL_ERROR", e.getMessage(), null);
        }
    }

    private void handleGetPlatformVersion(@NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Getting platform version");
        result.success("Android " + Build.VERSION.RELEASE);
    }

    private void handleSwitchMusic(@NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Handling switch music");
        try {
            AudioUtil.getInstance().playOrPauseMusic();
            result.success(true);
        } catch (Exception e) {
            Logger.e(TAG, "Error switching music: " + e.getMessage());
            result.error("AUDIO_ERROR", "Failed to switch music", e.getMessage());
        }
    }

    private void handleIsMusicOn(@NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Checking if music is active");
        try {
            boolean isActive = AudioUtil.getInstance().isMusicActive();
            Logger.d(TAG, "Music active state: " + isActive);
            result.success(isActive);
        } catch (Exception e) {
            Logger.e(TAG, "Error checking music state: " + e.getMessage());
            result.error("AUDIO_ERROR", "Failed to check music state", e.getMessage());
        }
    }

    private void handleNextMusic(@NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Handling next music");
        try {
            AudioUtil.getInstance().nextMusic();
            result.success(true);
        } catch (Exception e) {
            Logger.e(TAG, "Error switching to next track: " + e.getMessage());
            result.error("AUDIO_ERROR", "Failed to switch to next track", e.getMessage());
        }
    }

    private void handleLastMusic(@NonNull MethodChannel.Result result) {
        Logger.d(TAG, "Handling previous music");
        try {
            AudioUtil.getInstance().lastMusic();
            result.success(true);
        } catch (Exception e) {
            Logger.e(TAG, "Error switching to previous track: " + e.getMessage());
            result.error("AUDIO_ERROR", "Failed to switch to previous track", e.getMessage());
        }
    }
}
