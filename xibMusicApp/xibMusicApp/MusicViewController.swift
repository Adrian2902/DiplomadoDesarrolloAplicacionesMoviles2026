//
//  MusicViewController.swift
//  xibMusicApp
//
//  Created by Adrian Gutierrez on 07/11/25.
//

import UIKit

final class MusicViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    // MARK: - Properties
    private var songs: [Song] = []
    private var currentIndex = 0
    private var isPlaying = false
    private var timer: Timer?
    private var currentTime: TimeInterval = 0.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSongs()
        updateUI()
        configureButtons()
    }

    private func setupSongs() {
        songs = [
            Song(title: "Eternal Light", artist: "The Smiths", duration: 180, albumImage: UIImage(named: "the smiths")!),
            Song(title: "Dreaming Awake", artist: "Solaris", duration: 210, albumImage: UIImage(named: "solaris")!),
            Song(title: "Golden Skies", artist: "Aurora Lane", duration: 240, albumImage: UIImage(named: "aurora")!)
        ]
    }

    private func configureButtons() {
        backButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        forwardButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        updatePlayPauseButton()
    }

    private func updatePlayPauseButton() {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func updateUI() {
        let song = songs[currentIndex]
        albumImageView.image = song.albumImage
        songTitleLabel.text = song.title
        artistNameLabel.text = song.artist

        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(song.duration)
        progressSlider.value = Float(currentTime)
        updateTimeLabels()
    }

    private func updateTimeLabels() {
        let song = songs[currentIndex]
        elapsedTimeLabel.text = formatTime(currentTime)
        let remaining = song.duration - currentTime
        remainingTimeLabel.text = "-\(formatTime(remaining))"
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Actions
    @IBAction func playPauseTapped(_ sender: UIButton) {
        isPlaying.toggle()
        updatePlayPauseButton()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }

    @IBAction func nextSongTapped(_ sender: UIButton) {
        currentIndex = (currentIndex + 1) % songs.count
        resetPlayback()
    }

    @IBAction func previousSongTapped(_ sender: UIButton) {
        currentIndex = (currentIndex - 1 + songs.count) % songs.count
        resetPlayback()
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        currentTime = TimeInterval(sender.value)
        updateTimeLabels()
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.advancePlayback()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func advancePlayback() {
        let song = songs[currentIndex]
        guard currentTime < song.duration else {
            nextSongTapped(forwardButton)
            return
        }

        currentTime += 1
        progressSlider.value = Float(currentTime)
        updateTimeLabels()
    }

    private func resetPlayback() {
        stopTimer()
        currentTime = 0
        isPlaying = false
        updateUI()
        updatePlayPauseButton()
    }
}

