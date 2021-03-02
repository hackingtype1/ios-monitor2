//
//  ContentView.swift
//  ns-swift
//
//  Created by John Costik on 3/2/21.
//

import SwiftUI

struct ContentView: View {
    @State var title: String = ""
    @State var error: Error? = nil
    @State var keepOn: Bool = true
    @State var needsURL: Bool = false
    @State var needsRefresh: Bool = false
    @State var nsURL: String = "https://nightscoutfoundation.org"
    
    let defaults = UserDefaults.standard
    
    var mainWebView: some View {
        WebView(title: $title, url: URL(string: nsURL)!)
            .onLoadStatusChanged { loading, error in
                if loading {
                    self.title = "Loading…"
                }
                else {
                    if let error = error {
                        self.error = error
                        if self.title.isEmpty {
                            self.title = "Error"
                        }
                    }
                    else if self.title.isEmpty {
                        self.title = "???"
                    }
                }
            }
    }
    
    var enterURL: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Hello! \nPlease enter your Nighscout URL: ")
            Text("Be sure to include http:// or https://")
                .font(.footnote)
            
            Divider()
            TextField("Enter URL", text: $nsURL)
                .autocapitalization(.none)
            Divider()
            Button("Done", action: {
                needsURL = false
                defaults.set(nsURL, forKey: "ns_url")
            })
                .buttonStyle(StandardButtonStyle())
        }
    }
    
    var optionsClusterView: some View {
        VStack (spacing: 8) {
            VolumeSliderView()
                .frame(height: 40)
            Divider()
            HStack(alignment: .center) {
                Button("Change URL", action: {
                    needsURL = true
                })
                    .buttonStyle(StandardButtonStyle())
                Spacer()
                Button("Refresh Page", action: {
                    needsRefresh = true
                })
                    .buttonStyle(StandardButtonStyle())
            }
            Divider()
            Toggle("Screen Lock Override:", isOn: $keepOn)
                .toggleStyle(SwitchToggleStyle(tint: .orange))
        }
    }
    
    var body: some View {
        if needsRefresh {
            DispatchQueue.main.async {
                needsRefresh.toggle()
            }
        }
        return VStack {
            if !needsURL {
                if !needsRefresh {
                    mainWebView
                }
                optionsClusterView
                    .padding()
            }

            if needsURL {
                enterURL
                    .padding()
            }
        }.onAppear(){
            if let url = defaults.string(forKey: "ns_url") {
                DispatchQueue.main.async {
                    nsURL =  url
                    needsRefresh.toggle()
                }
            }
        }
    }
}
