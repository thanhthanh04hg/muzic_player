//
//  DetailViewController.swift
//  cloud_offline
//
//  Created by Macbook on 10/06/2021.
//

import UIKit
import AVFoundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import MediaPlayer
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet var repeatBtn: UIButton!
    @IBOutlet var name: UILabel!
    var player: AVAudioPlayer?
//    var player : AVPlayer?
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var playBtn: UIButton!
    public var position: Int = 0
    public var songs: [Song] = []
    @IBOutlet var currentTimeLbl: UILabel!
    @IBOutlet var durationTimeLbl: UILabel!
    
    
    var listAudio = [GTLRDrive_File]()
    var str : String?
    fileprivate let service = GTLRDriveService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOff()
        setRecent()
//        configureOnl()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.pause()
        }
    }

//    MARK: OFFLINE MUSIC
    func configureOff() {
//        let urlString = Bundle.main.path(forResource: "BlankSpace-TaylorSwift-6077900", ofType: "mp3")
        do {
            let song = songs[position]
            musicImage.image = song.artwork
            musicImage.layer.cornerRadius = 10 
            name.text = song.name
            artistLbl.text = song.artistName
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//            setupAudioSession()
            str = UserDefaults.standard.string(forKey: "url")! + song.urlString!
            player = try AVAudioPlayer(contentsOf: URL(string: str!)!)
            guard let player = player else {
                print("player is nil")
                return
            }
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressSlider), userInfo: nil, repeats: true)
            progressSlider.setValue(Float(player.currentTime/player.duration) , animated: false)
            player.volume = 1
            player.delegate = self
            player.enableRate = true
            player.rate = 1.0
            player.prepareToPlay()
            player.play()
//            playBtn.setTitle("Stop", for: .normal)
            playBtn.setImage(UIImage(named: "btn_play"), for: .normal)
            setupNowPlaying()
            setupRemoteCommandCenter()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()

        }
        catch {
            print("error occurred")
        }
        
        // slider
        progressSlider.addTarget(self, action: #selector(didChangeProgress(_:)), for: .valueChanged)
    }
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: .allowAirPlay)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        if let artwork = songs[position].artwork{
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: artwork.size) { size in
                    return artwork
            }
        }

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        nowPlayingInfo[MPMediaItemPropertyTitle] = songs[position].name
        nowPlayingInfo[MPMediaItemPropertyArtist] = songs[position].artistName ?? UIImage(named: "unknown_music")

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.player!.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.player!.pause()
            return .success
        }
    }


    @IBAction func onReapeatBtn(_ sender: Any) {

        if repeatBtn.image(for: .normal) == UIImage(named: "ic_replay") {
            repeatBtn.setImage(UIImage(named: "ic_repeat_one"), for: .normal)
        }
        else {
            repeatBtn.setImage(UIImage(named: "ic_replay"), for: .normal)
        }
        
    }
    @IBAction func onBackBtn(_ sender: Any) {
        if position > 0 {
            position = position - 1
            player?.pause()
            configureOff()
//            configureOnl()
        }
        else {
            position = songs.count - 1
            player?.pause()
            configureOff()
//            configureOnl()
        }
        
        
    }
    
    @IBAction func onChangeRate(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose a speed", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "0.5 X", style: .default, handler: { action in
            self.player?.rate = 0.5
        }))
        alert.addAction(UIAlertAction(title: "1.0 X", style: .default, handler: { action in
            self.player?.rate = 1.0
        }))
        alert.addAction(UIAlertAction(title: "1.5 X", style: .default, handler: { action in
            self.player?.rate = 1.5
        }))
        alert.addAction(UIAlertAction(title: "2.0 X", style: .default, handler: { action in
            self.player?.rate = 2.0
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onPlayBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if player != nil {
            // pause
            if sender.isSelected == true {
                player?.pause()
//                playBtn.setTitle("Play", for: .normal)
                playBtn.setImage(UIImage(named: "ic_stopMusic"), for: .normal)
            }
            //play
            else {
                player?.play()
//                playBtn.setTitle("Stop", for: .normal)
                playBtn.setImage(UIImage(named: "btn_play"), for: .normal)
                
            }
            setupNowPlaying()
            setupRemoteCommandCenter()
        }

       
    }
    
    @IBAction func listAudios(_ sender: Any) {
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onNextBtn(_ sender: Any) {
        nextSong()
    }
    @objc func didChangeProgress(_ slider : UISlider){
        let value = slider.value
        player!.currentTime = TimeInterval(value*Float(player!.duration))
        progressSlider.setValue(Float(player!.currentTime/player!.duration), animated: false)
        player?.play()
        
//        let durationTime : CMTime = (player?.currentItem?.asset.duration)!
//        let floatCT = Float(CMTimeGetSeconds((player?.currentTime())!))
//        let floatDT = Float(CMTimeGetSeconds(durationTime))
//        let value = slider.value
//        let cmTime = CMTime(seconds: TimeInterval(value*floatDT), preferredTimescale: 1000000)
//        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
//        progressSlider.setValue(Float(floatCT/floatDT), animated: false)
        
//        player?.play()
    }
    @objc func updateAudioProgressSlider()
    {

//        if player != nil {
//            let durationTime : CMTime = (player?.currentItem?.asset.duration)!
//            let integerCT = CMTimeGetSeconds((player?.currentTime())!)
//            let integerDT = CMTimeGetSeconds(durationTime)
//            progressSlider.setValue(Float(integerCT/integerDT), animated: false)
//            currentTimeLbl.text = String(integerCT.stringFromTimeInterval())
//            durationTimeLbl.text = String (integerDT.stringFromTimeInterval())
//            if(integerDT == integerCT) {
//                playBtn.setTitle("Play", for: .normal)
//                progressSlider.setValue(0.0, animated: false)
//            }
//        }
        let integerCT = player?.currentTime
        let integerDT = player?.duration
        currentTimeLbl.text = String(integerCT!.stringFromTimeInterval())
        durationTimeLbl.text = String (integerDT!.stringFromTimeInterval())
        if player?.isPlaying == true {
            progressSlider.setValue(Float(player!.currentTime/player!.duration), animated: false)
        }
        if player?.currentTime == player?.duration {
            progressSlider.setValue(0.0, animated: false)
        }

    }
    func nextSong(){
        if position < (songs.count - 1) {
            position = position + 1
//            player?.stop()
            player?.pause()
            configureOff()
//            configureOnl()
        }
        else {
            position = 0
//            player?.stop()
            player?.pause()
            configureOff()
//            configureOnl()
        }
    }
    
    fileprivate func setRecent(){
        let recentAudio = RealmService.shared.get(RecentAudio.self, filter: "name contains 'Recent Audio'")
        
        let realm = try! Realm()
        try! realm.write{
            if recentAudio.songs.count <= 3 {
                if checkExist(recent: recentAudio, song: songs[position]) == true {
                    recentAudio.songs.append(songs[position])
                    recentAudio.count += 1
                }
                
                
            }
            else {
                if checkExist(recent: recentAudio, song: songs[position]) == true {
                    if recentAudio.count == 4 {
                        recentAudio.count = 0
                    }
                    else {
                        recentAudio.count += 1
                        
                    }
                    recentAudio.songs[recentAudio.count%4] = songs[position]
                    
                }
            }
        }
        print(RealmService.shared.get(RecentAudio.self, filter: "name contains 'Recent Audio'"))
        
    }
    fileprivate func checkExist(recent : RecentAudio , song : Song) -> Bool{
        for i in 0..<recent.songs.count {
            if recent.songs[i].urlString == song.urlString {
                return false
            }
        }
        return true
    }
    

}
extension DetailViewController : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if repeatBtn.image(for: .normal) == UIImage(named: "ic_repeat_one "){
            configureOff()
//            configureOnl()
        }
        else{
            nextSong()
        }
        
    }
}
extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        if hours != 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
        else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }

    }
}

//
//MARK: ONLINE MUSIC
//    func configureOnl() {
//
//        let url = URL(string: "https://drive.google.com/uc?export=download&id="+listAudio[position].identifier!)
//        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
//
//        let durationTime : CMTime = (player?.currentItem?.asset.duration)!
//        let floatCT = Float(CMTimeGetSeconds(player!.currentTime()))
//        let floatDT = Float(CMTimeGetSeconds(durationTime))
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressSlider), userInfo: nil, repeats: true)
//
//        progressSlider.setValue(Float(floatCT/floatDT), animated: false)
//
//        player?.volume = 1
//        player?.rate = playBackRate()
//        player?.play()
//        playBtn.setTitle("Stop", for: .normal)
//
//
//        // slider
//        slider.maximumValue = 10
//        slider.value = 5
//        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
//        progressSlider.addTarget(self, action: #selector(didChangeProgress(_:)), for: .valueChanged)
//    }
