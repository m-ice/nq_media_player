import MediaPlayer
import AVFoundation

@objc class AudioUtil: NSObject {
    private static let shared = AudioUtil()
    private var audioSession: AVAudioSession?
    private var lastCallTime: TimeInterval = 0
    private var timer: Timer?
    private let debounceTime: TimeInterval = 0.2
    private let delayTime: TimeInterval = 1.0
    private var isInitialized = false
    
    @objc static func getInstance() -> AudioUtil {
        return shared
    }
    
    private override init() {
        super.init()
        print("AudioUtil: Instance created")
    }
    
    @objc func initialize() {
        guard !isInitialized else {
            print("AudioUtil: Already initialized")
            return
        }
        
        do {
            print("AudioUtil: Initializing...")
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(.playback, mode: .default)
            try audioSession?.setActive(true)
            
            // 监听音频状态变化
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleAudioSessionRouteChange),
                name: AVAudioSession.routeChangeNotification,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleInterruption),
                name: AVAudioSession.interruptionNotification,
                object: nil
            )
            
            isInitialized = true
            print("AudioUtil: Initialized successfully")
        } catch {
            print("AudioUtil initialization error: \(error.localizedDescription)")
        }
    }
    
    @objc func playOrPauseMusic() {
        guard isInitialized else {
            print("AudioUtil: Not initialized")
            return
        }
        
        print("AudioUtil: Attempting playOrPauseMusic")
        let commandCenter = MPRemoteCommandCenter.shared()
        if isMusicActive() {
            print("AudioUtil: Executing pause command")
            _ = commandCenter.pauseCommand.execute(nil)
        } else {
            print("AudioUtil: Executing play command")
            _ = commandCenter.playCommand.execute(nil)
        }
    }
    
    @objc func nextMusic() {
        guard isInitialized else {
            print("AudioUtil: Not initialized")
            return
        }
        
        print("AudioUtil: Executing next track command")
        _ = MPRemoteCommandCenter.shared().nextTrackCommand.execute(nil)
    }
    
    @objc func lastMusic() {
        guard isInitialized else {
            print("AudioUtil: Not initialized")
            return
        }
        
        print("AudioUtil: Executing previous track command")
        _ = MPRemoteCommandCenter.shared().previousTrackCommand.execute(nil)
    }
    
    @objc func isMusicActive() -> Bool {
        guard isInitialized, let audioSession = audioSession else {
            print("AudioUtil: Not initialized or audioSession is nil")
            return false
        }
        
        let isPlaying = audioSession.isOtherAudioPlaying
        print("AudioUtil: isMusicActive = \(isPlaying)")
        return isPlaying
    }
    
    @objc private func handleAudioSessionRouteChange(_ notification: Notification) {
        let now = Date().timeIntervalSince1970
        if now - lastCallTime < debounceTime {
            lastCallTime = now
            print("AudioUtil: Skipping route change due to debounce")
            return
        }
        
        lastCallTime = now
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            print("AudioUtil: Handling delayed route change")
            CallbackImpl.shared().onPlaybackConfigChanged(self.isMusicActive())
        }
    }
    
    @objc private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            print("AudioUtil: Invalid interruption notification")
            return
        }
        
        switch type {
        case .began:
            print("AudioUtil: Audio interruption began")
            CallbackImpl.shared().onPlaybackConfigChanged(false)
        case .ended:
            print("AudioUtil: Audio interruption ended")
            CallbackImpl.shared().onPlaybackConfigChanged(isMusicActive())
        @unknown default:
            print("AudioUtil: Unknown interruption type")
            break
        }
    }
    
    @objc func close() {
        print("AudioUtil: Closing...")
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
        
        do {
            try audioSession?.setActive(false)
            audioSession = nil
            isInitialized = false
            print("AudioUtil: Closed successfully")
        } catch {
            print("AudioUtil: Error closing audio session: \(error.localizedDescription)")
        }
    }
    
    deinit {
        print("AudioUtil: Deinitializing")
        close()
    }
} 