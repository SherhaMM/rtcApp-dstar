//
//  CallViewController.swift
//  rtcApp
//
//  Created by Makcim Mikhailov on 18.11.19.
//  Copyright © 2019 Makcim Mikhailov. All rights reserved.
//

import UIKit
import AVFoundation


class CallViewController: UIViewController {
    let serverHost = "https://appr.tc"
    var roomName: String!
    
    var client: ARDAppClient?
    var localVideo: RTCVideoTrack?
    var remoteVideo: RTCVideoTrack?
    
    var localVideoView: RTCEAGLVideoView = {
        let view = RTCEAGLVideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 15
        return view
    }()
    
    var remoteVideoView: RTCEAGLVideoView = {
        let view = RTCEAGLVideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        if let roomName = roomName {
        title = "Room ID: \(roomName)"
        }
        
        configureViews()
        initializeConnection()
        connectToChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deinitializeConnection()
    }
    override func viewWillDisappear(_ animated: Bool) {
        deinitializeConnection()
    }
    private func configureViews() {
        view.addSubview(remoteVideoView)
        NSLayoutConstraint.activate([
            remoteVideoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            remoteVideoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            remoteVideoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        
            ])
        
        remoteVideoView.addSubview(localVideoView)
        NSLayoutConstraint.activate([
            localVideoView.trailingAnchor.constraint(equalTo: remoteVideoView.trailingAnchor,constant: -20),
            localVideoView.bottomAnchor.constraint(equalTo: remoteVideoView.bottomAnchor,constant: -20),
            localVideoView.heightAnchor.constraint(equalToConstant: 150),
            localVideoView.widthAnchor.constraint(equalToConstant: 100)
            ])
        
        
    }
    private func initializeConnection() {
        deinitializeConnection()
        client = ARDAppClient.init(delegate: self)
        remoteVideoView.delegate = self
        localVideoView.delegate = self
    }
    
    private func deinitializeConnection() {
        guard client != nil else { return }
        if localVideo != nil {
            localVideo?.remove(localVideoView)
        }
        if remoteVideo != nil {
            remoteVideo?.remove(remoteVideoView)
        }
        localVideo = nil
        remoteVideo = nil
        client?.disconnect()
    }
    
    private func remoteDisconnected() {
        if remoteVideo != nil {
            remoteVideo?.remove(remoteVideoView)
        }
        remoteVideo = nil
    }
    
    //MARK: Connect to room
    func connectToChat() {
        deinitializeConnection()
        client?.serverHostUrl = "https://appr.tc"
//        client?.serverHostUrl = "https://apprtc.appspot.com"
        
        client?.connectToRoom(withId: self.roomName, options: nil)
    
    }
  
}
//MARK: ARDAppClientDelegate
extension CallViewController: ARDAppClientDelegate {
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state {
        case .disconnected:
            remoteDisconnected()
        default:
            print("State changed!")
        }
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        if self.localVideo != nil {
            self.localVideo?.remove(localVideoView)
        }
        self.localVideo = localVideoTrack
        self.localVideo?.add(localVideoView)
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideo = remoteVideoTrack
        self.remoteVideo?.add(remoteVideoView)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        deinitializeConnection()
        showAlert(with: "Some Error Occured")
    }
  
}

extension CallViewController: RTCEAGLVideoViewDelegate {

    func videoView(_ videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        //TODO:
    }
}

extension CallViewController {
    func showAlert(with text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController,animated: true,completion: nil)
    }
}
