//
//  LessonsController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class LessonsController: UIViewController {
    
    //MARK: - Data
    var scrollViewIndex = 0
    
    //MARK: - Views / Subviews
    
    var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Lessons"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var scrollView: UIScrollView = {
        
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.clipsToBounds = false
        sv.isPagingEnabled = true
        sv.backgroundColor = .clear
        sv.showsHorizontalScrollIndicator = false
        sv.layer.masksToBounds = false
        sv.delegate = self
        return sv
        
    }()
    
    var stackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
        
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.dataSource = self
        cv.delegate = self
        cv.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        cv.backgroundColor = .white
        cv.allowsSelection = true
        return cv
        
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.lessonsTabDelegate = self
        AdManager.shared.lessonDelegate = self
        setup()
    }
    
    //MARK: - Setup
    
    func setup() {
        
        self.view.backgroundColor = K.DesignColors.background
        
        setupNavBar()
        self.setupScrollView()
        self.setupCollectionView()
    }
    
    func setupNavBar() {
        
        // Add Center Title
        self.navigationItem.titleView = titleLabel
        
        // Add user button
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "line.horizontal.3").withRenderingMode(.alwaysTemplate),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        }

        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
    }
    
    func setupScrollView() {

        scrollView.addSubview(stackView)
        
        stackView.anchor(top: scrollView.topAnchor,
                         bottom: scrollView.bottomAnchor,
                         leading: scrollView.leadingAnchor,
                         trailing: scrollView.trailingAnchor,
                         height: nil,
                         width: nil)
        
        // Prevent Vertical Scrolling
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        // Populate Stack View
        for lesson in Utilities.shared.lessons! {

            let iv = CustomImageView()
            iv.loadImageUsingCacheWithURLString(urlString: lesson.lessonThumbnailURL)
            iv.backgroundColor = K.DesignColors.primary
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.heightAnchor.constraint(equalToConstant: 180).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 280).isActive = true
            iv.roundCorners(cornerRadius: 8)
            stackView.addCenteredSubview(iv, stackViewParent: scrollView)

        }
        
        // Add Scroll View to Main View
        view.addSubview(scrollView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -90).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func updateScrollView() {
        
        for view in stackView.subviews {
            view.removeFromSuperview()
            print("removed")
        }
        
        // Populate Stack View
        print(Utilities.shared.lessons!.count)
        for lesson in Utilities.shared.lessons! {

            let iv = CustomImageView()
            iv.loadImageUsingCacheWithURLString(urlString: lesson.lessonThumbnailURL)
            iv.backgroundColor = K.DesignColors.primary
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.heightAnchor.constraint(equalToConstant: 180).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 280).isActive = true
            iv.roundCorners(cornerRadius: 8)
            stackView.addCenteredSubview(iv, stackViewParent: scrollView)

        }
        
        scrollViewIndex = 0
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        collectionView.reloadData()
        
    }
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: scrollView.bottomAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              height: nil,
                              width: nil,
                              padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        collectionView.reloadData()
    }
    
    //MARK: - Selector Functions
    
    @objc func settingsButtonTapped() {
    
        Utilities.shared.settingsLauncher.parentVC = self
        Utilities.shared.settingsLauncher.showSettings()
                
    }
    
    func populateLessonsDB() {
        
        let video1 = VideoModel(videoTitle: "Lesson 1",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson1.png?alt=media&token=b729c5f5-8683-49df-b7d5-2bc7c6905ada",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson1.MOV?alt=media&token=27f58b35-ef23-4d08-855c-e7b9f0117415",
                                duration: "10 minutes, 37 seconds")
        
        let video2 = VideoModel(videoTitle: "Lesson 2",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson2.png?alt=media&token=ccad6042-8c16-4fa7-ab8e-e3c3e7fb1486",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson2.MOV?alt=media&token=f98a570c-5d61-46c7-832b-f5e06234806e",
                                duration: "8 minutes, 15 seconds")
        
        let video3 = VideoModel(videoTitle: "Lesson 3",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson3.png?alt=media&token=b1c9aae4-cedd-447f-8c6f-dda53ff8bb4d",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson3.MOV?alt=media&token=1c7bf585-9df8-4ff3-8a65-9db7bfdb03fe",
                                duration: "9 minutes, 40 seconds")
        
        let video4 = VideoModel(videoTitle: "Lesson 4",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson4.png?alt=media&token=e68a71c9-118e-422c-88f3-74fd7b107aa1",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson4.MOV?alt=media&token=60340113-b672-4fdc-81b0-c2414c6e3358",
                                duration: "6 minutes, 32 seconds")
        
        let video5 = VideoModel(videoTitle: "Lesson 5",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson5.png?alt=media&token=6598a8c6-8846-4141-b9d4-27a6f7decbca",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson5.MOV?alt=media&token=ec65bf0d-a286-4d15-bd0b-512455ae48cf",
                                duration: "7 minutes, 24 seconds")
        
        let video6 = VideoModel(videoTitle: "Lesson 6",
                                videoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson6.png?alt=media&token=ad34e7d9-4535-4173-8f4e-ac26cf39fc3c",
                                videoURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson6.MOV?alt=media&token=e8242a5b-3057-4df8-904d-4506a6b838a1",
                                duration: "10 minutes, 23 seconds")
        
        let videos = [video1, video2, video3, video4, video5, video6]
        
        let lesson1 = LessonModel(lessonTitle: "Lessons", lessonThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Lesson1Thumbnail.png?alt=media&token=133e14e3-39d3-4d0d-b7c9-cd1fd51d9e06", videos: videos)
        
        FirebaseManager.shared.updateLesson(lesson: lesson1)
    }
    
}

//MARK: - Collection View Data Source

extension LessonsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Utilities.shared.lessons![scrollViewIndex].videos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        
        cell.cellMask.alpha = 0
        
        if scrollViewIndex == 1 && AdManager.shared.funnelProgress != .completedVideo2Bought && indexPath.row > 0 {
            cell.playView.isHidden = false
        } else {
            cell.playView.isHidden = true
        }
        
        let currentVideo = Utilities.shared.lessons![scrollViewIndex].videos[indexPath.row]
        
        let thumbnailUrlString = currentVideo.videoThumbnailURL
        
        cell.imageView.backgroundColor = .white
        
        cell.imageView.loadImageUsingCacheWithURLString(urlString: thumbnailUrlString)
        
        cell.titleLabel.text = currentVideo.videoTitle
        
        cell.videoLengthLabel.text = currentVideo.duration
        
        return cell
    }
    
}

//MARK: - Collection View Delegate Flow Layout

extension LessonsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 74)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}

//MARK: - Collection View Delegate

extension LessonsController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if scrollViewIndex == 1 && AdManager.shared.funnelProgress != .completedVideo2Bought && indexPath.row > 0 {
            AdManager.shared.showBuyButton(inVideo: false, videoVC: nil, parentVC: self)
            return 
        }
        
        let av = PUAVPlayerViewController()
        av.videoIdx = indexPath.row
        av.parentView = self
        AdManager.shared.currentLessonIndex = indexPath.row
        let urlString = Utilities.shared.lessons![scrollViewIndex].videos[indexPath.row].videoURL
        
        if let url = URL(string: urlString) {
            
            let player = AVPlayer(url: url)
            av.player = player
            av.player?.automaticallyWaitsToMinimizeStalling = true
            
            // Add Observer
            let interval = CMTime(value: 1, timescale: 2)
            av.timeObserver = av.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let min = Int(seconds / 60)
                let secs = Int(seconds) % 60
                
                switch AdManager.shared.funnelProgress {
                case .hasNotSeenVideo1:
                    AdManager.shared.funnelProgress = .seenPartOfVideo1
                case .seenPartOfVideo1:
                    if min >= 9 {
                        AdManager.shared.funnelProgress = .completedVideo1
                    }
                case .completedVideo1:
                    AdManager.shared.funnelProgress = .seenPartOfVideo2
                case .seenPartOfVideo2:
                    if min >= 15 && secs >= 15 {
                        AdManager.shared.funnelProgress = .completedVideo2NoBuy
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                        AdManager.shared.currentLessonIndex = 0
                    }
                case .completedVideo2NoBuy:
                    if secs >= 15 && AdManager.shared.isBuyButtonShowing == false {
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                    }
                    
                    if let idx = AdManager.shared.currentLessonIndex {
                        if let duration = av.player?.currentItem?.duration {
                            let durationSecs = CMTimeGetSeconds(duration)
                            if durationSecs - seconds <= 15 {
                                if idx == 0 {
                                    AdManager.shared.currentLessonIndex = idx + 1
                                }
                            }
                        }
                    }
                case .completedVideo2Bought:
                    if let idx = AdManager.shared.currentLessonIndex {
                        if let duration = av.player?.currentItem?.duration {
                            let durationSecs = CMTimeGetSeconds(duration)
                            if durationSecs - seconds <= 15 {
                                if idx == av.videoIdx && idx + 1 < Utilities.shared.lessons![1].videos.count {
                                    AdManager.shared.currentLessonIndex = idx + 1
                                }
                            }
                        }
                    }
                default:
                    break
                }
            })
            
            self.present(av, animated: true) {
                
                av.player!.play()
                
            }
        }
    }
}

//MARK: - Scroll View Delegate

extension LessonsController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        scrollViewIndex = Int(targetContentOffset.pointee.x / scrollView.frame.size.width)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
}

extension LessonsController: FirebaseUpdaterDelegate {
    func updateLessonsDisplay() {
        self.updateScrollView()
    }
}

extension LessonsController {
    func playVideo() {
        let av = PUAVPlayerViewController()
        av.videoIdx = AdManager.shared.currentLessonIndex ?? 0
        av.parentView = self
        let urlString = AdManager.shared.getVideoURLForCurrentUserState()
                
        if let url = URL(string: urlString) {
            
            let player = AVPlayer(url: url)
            av.player = player
            av.player?.automaticallyWaitsToMinimizeStalling = true
            
            // Add Observer
            let interval = CMTime(value: 1, timescale: 2)
            av.timeObserver = av.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let min = Int(seconds / 60)
                let secs = Int(seconds) % 60
                
                switch AdManager.shared.funnelProgress {
                case .hasNotSeenVideo1:
                    AdManager.shared.funnelProgress = .seenPartOfVideo1
                case .seenPartOfVideo1:
                    if min >= 9 {
                        AdManager.shared.funnelProgress = .completedVideo1
                    }
                case .completedVideo1:
                    AdManager.shared.funnelProgress = .seenPartOfVideo2
                case .seenPartOfVideo2:
                    if min >= 15 && secs >= 15 {
                        AdManager.shared.funnelProgress = .completedVideo2NoBuy
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                        AdManager.shared.currentLessonIndex = 0
                    }
                case .completedVideo2NoBuy:
                    if secs >= 15 && AdManager.shared.isBuyButtonShowing == false {
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                    }
                    
                    if let idx = AdManager.shared.currentLessonIndex {
                        if let duration = av.player?.currentItem?.duration {
                            let durationSecs = CMTimeGetSeconds(duration)
                            if durationSecs - seconds <= 15 {
                                if idx == 0 {
                                    AdManager.shared.currentLessonIndex = idx + 1
                                }
                            }
                        }
                    }
                case .completedVideo2Bought:
                    if let idx = AdManager.shared.currentLessonIndex {
                        if let duration = av.player?.currentItem?.duration {
                            let durationSecs = CMTimeGetSeconds(duration)
                            if durationSecs - seconds <= 15 {
                                if idx == av.videoIdx && idx + 1 < Utilities.shared.lessons![1].videos.count {
                                    AdManager.shared.currentLessonIndex = idx + 1
                                }
                            }
                        }
                    }
                default:
                    break
                }
            })
            self.present(av, animated: true) {
                
                av.player!.play()
            }
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        DispatchQueue.main.async {
            self.scrollViewIndex = page
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(page) * self.scrollView.frame.width, y: 0), animated: animated)
            self.collectionView.reloadData()
        }
    }

}
