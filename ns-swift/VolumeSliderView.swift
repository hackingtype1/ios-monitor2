//
//  VolumeSliderView.swift
//  ns-swift
//
//  Created by John Costik on 3/2/21.
//

import SwiftUI
import MediaPlayer
import UIKit

struct VolumeSliderView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let vview = MPVolumeView(frame: .zero)
        vview.showsRouteButton = false
        return vview
    }
    
    func updateUIView(_ view: MPVolumeView, context: Context) {}
}
