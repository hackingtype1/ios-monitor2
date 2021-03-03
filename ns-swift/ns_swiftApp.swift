//
//  ns_swiftApp.swift
//  ns-swift
//
//  Created by John Costik on 3/2/21.
//

import SwiftUI

@main
struct ns_swiftApp: App {
    @State private var nsURL: String? = UserDefaults.standard.string(forKey: "ns_url")
    var body: some Scene {
        WindowGroup {
            ContentView(nsURL: $nsURL)
        }
    }
}
