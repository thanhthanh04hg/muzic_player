//
//  VideoViewController.swift
//  cloud_offline
//
//  Created by Macbook on 10/06/2021.
//

import UIKit
import AVKit
import AVFoundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import MediaPlayer
import RealmSwift

class VideoViewController: UIViewController {
//MARK: -UI COmponents
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var currentLbl: UILabel!
    @IBOutlet weak var playbackBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet var videoView: UIView!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var repeatBtn: UIButton!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet weak var zoomBtn: UIButton!
    //MARK: - Propeties
    
    var drive: ATGoogleDrive?
    let service = GTLRDriveService()
    var list = [GTLRDrive_File]()
    var listAudio = [GTLRDrive_File]()
    var googleUser: GIDGoogleUser?
    var playerLayerVC = AVPlayerViewController()
    var playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    var videos = [Video]()
    var position : Int = 0;
    var str : String = ""
    var flag = 0
    var zoom = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVideo()
        setRecent()
        // Add Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc func didTapView(){
        if flag == 0 {
            toolBarView.isHidden = true
            topView.isHidden = true
            flag = 1
        }
        else {
            toolBarView.isHidden = false
            topView.isHidden = false
            view.addSubview(topView)
            view.addSubview(toolBarView)
            flag = 0
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController?.view.frame = UIScreen.main.bounds
        player.pause()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    fileprivate func configVideo(){
//        let urlString = Bundle.main.path(forResource: "video1", ofType: "mp4")
//        let videoPathURL : NSURL = NSURL(string: "https://drive.google.com/uc?export=open&id=1iNpWR2rAHIkBP4A63s9bpl41W_55zcum")!
//        let videoPathURL : NSURL = NSURL(string: "https://drive.google.com/uc?id=iNpWR2rAHIkBP4A63s9bpl41W_55zcum&authuser=0&export=download")!


        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            
            str = UserDefaults.standard.string(forKey: "url")! + videos[position].urlString!
            let videoPathURL = URL(string: str)
            player = AVPlayer(url: videoPathURL! as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.frame
            self.view.layer.addSublayer(playerLayer)
            
            
            //MARK: set volume

            let durationTime : CMTime = (player.currentItem?.asset.duration)!
            let floatCT = Float(CMTimeGetSeconds(player.currentTime()))
            let floatDT = Float(CMTimeGetSeconds(durationTime))
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressSlider), userInfo: nil, repeats: true)

            progressSlider.setValue(Float(floatCT/floatDT), animated: false)
            progressSlider.addTarget(self, action: #selector(didChangeProgress(_:)), for: .valueChanged)
            playBtn.setImage(UIImage(named: "ic_stopvideo"), for: .normal)
            player.play()
            setupNowPlaying()
            setupRemoteCommandCenter()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        }
        catch{
            print("error occur")
        }
       
        

    }
    @IBAction func backVideo(_ sender: Any) {
        if position > 0 {
            position = position - 1
            player.pause()
            configVideo()
        }
        else {
            position = videos.count - 1
            player.pause()
            configVideo()
        }
    }
    @IBAction func nextVideo(_ sender: Any) {
        if position < (videos.count - 1) {
            position = position + 1
            player.pause()
            configVideo()
        }
        else {
            position = 0
            player.pause()
            configVideo()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        AppUtility.lockOrientation(.portrait,andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func changePlayBack(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose a speed", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "0.5 X", style: .default, handler: { action in
            self.player.rate = 0.5
            self.playbackBtn.setTitle("0.5X", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "1.0 X", style: .default, handler: { action in
            self.player.rate = 1.0
            self.playbackBtn.setTitle("1.0X", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "1.5 X", style: .default, handler: { action in
            self.player.rate = 1.5
            self.playbackBtn.setTitle("1.5X", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "2.0 X", style: .default, handler: { action in
            self.player.rate = 2.0
            self.playbackBtn.setTitle("2.0X", for: .normal)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: .allowAirPlay)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }
    @IBAction func zoomVideo(_ sender: Any) {

        if zoom == 0 {
            AppUtility.lockOrientation(.landscape,andRotateTo: .landscapeLeft)
            playerLayer.frame = self.view.layer.bounds
            playerLayer.videoGravity = .resizeAspectFill
            zoom = 1
        }
        else {
            AppUtility.lockOrientation(.portrait,andRotateTo: .portrait)
            playerLayer.frame = self.view.layer.bounds
            playerLayer.videoGravity = .resizeAspect
            zoom = 0
        }
        print("zoom \(zoom)")
    }
    fileprivate func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.currentItem?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        nowPlayingInfo[MPMediaItemPropertyTitle] = videos[position].videoName

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    fileprivate func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.player.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.player.pause()
            return .success
        }
    }

    @objc func updateAudioProgressSlider()
    {
        let durationTime : CMTime = (player.currentItem?.asset.duration)!
        let integerCT = CMTimeGetSeconds(player.currentTime())
        let integerDT = CMTimeGetSeconds(durationTime)
        currentLbl.text = String(integerCT.stringFromTimeInterval())
        durationLbl.text = String (integerDT.stringFromTimeInterval())
        progressSlider.setValue(Float(integerCT/integerDT), animated: false)
        if(integerDT == integerCT) {
            progressSlider.setValue(0.0, animated: false)
        }

    }
    @objc func didChangeProgress(_ slider : UISlider){
        let durationTime : CMTime = (player.currentItem?.asset.duration)!
        let floatCT = Float(CMTimeGetSeconds(player.currentTime()))
        let floatDT = Float(CMTimeGetSeconds(durationTime))
        let value = slider.value
        let cmTime = CMTime(seconds: TimeInterval(value*floatDT), preferredTimescale: 1000000)
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        progressSlider.setValue(Float(floatCT/floatDT), animated: false)
        
        player.play()

    }

    

    @IBAction func onPlayVideo(_ sender: Any) {
        setupNowPlaying()
        setupRemoteCommandCenter()
        switch player.timeControlStatus {
        case .playing:
            playBtn.setImage(UIImage(named: "ic_playvideo"), for: .normal)
            player.pause()
        case .paused:
            let currentItem = player.currentItem
            if currentItem?.currentTime() == currentItem?.duration {
                currentItem?.seek(to: .zero)
            }
            playBtn.setImage(UIImage(named: "ic_stopvideo"), for: .normal)
            player.play()
        default:
            player.pause()
        }
    }
    fileprivate func floatToString(x : NSInteger) -> String {
        let seconds = x % 60
        let minutes = (x / 60) % 60
        let hours = (x / 3600)
        if hours != 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
        else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }

        
    }
    fileprivate func setRecent(){
        let recentVideos = RealmService.shared.get(RecentVideo.self, filter: "name contains 'Recent Video'")
        let realm = try! Realm()
        try! realm.write{
            if checkExist(recent: recentVideos, video: videos[position]) == true{
                if recentVideos.videos.count <= 3 {
                    recentVideos.videos.append(videos[position])
                    recentVideos.count += 1
                }
                else {
                    if recentVideos.count == 4 {
                        recentVideos.count = 0
                    }
                    else {
                        recentVideos.count += 1
                    }
                
                    recentVideos.videos[recentVideos.count%4] = videos[position]
                    
                }
            }
            
        }
        
    }
    fileprivate func checkExist(recent : RecentVideo , video : Video) -> Bool{
        for i in 0..<recent.videos.count{
            if recent.videos[i].urlString == video.urlString {
                return false
            }
        }
        return true
    }
    

}


