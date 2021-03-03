//
//  ContentView.swift
//  ns-swift
//
//  Created by John Costik on 3/2/21.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = ""
    @State private var error: Error? = nil
    @State private var keepOn: Bool = true
    @State private var needsURL: Bool = false
    @State private var needsRefresh: Bool = false
    
    @Binding var nsURL: String?
    @State var defaultURL: String = "https://nightscoutfoundation.org"
    
    @State private var optionChevronRotation: Double = 0
    @State private var showOptions: Bool = false
    
    
    let defaults = UserDefaults.standard
    
    var mainWebView: some View {
        WebView(title: $title, url: URL(string: nsURL ?? defaultURL)!)
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
            TextField("Enter URL", text: Binding($nsURL) ?? $defaultURL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Divider()
            Button("Done", action: {
                needsURL = false
                defaults.set(nsURL, forKey: "ns_url")
            })
                .buttonStyle(StandardButtonStyle())
        }
    }
    
    var optionsClusterView: some View {
        VStack (alignment: .leading, spacing: 4) {
            Button(action: {
                showOptions.toggle()
                if self.showOptions {
                    self.optionChevronRotation = 90
                } else {
                    self.optionChevronRotation = 0
                }
            }) {
                HStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(optionChevronRotation))
                        .padding(.leading, 8)
                    Text(showOptions ? "HIDE OPTIONS" : "SHOW OPTIONS")
                    Spacer()
                }
            }.foregroundColor(.orange)
            .font(.footnote)
            if showOptions {
                Divider()
                    .padding()
                HStack {
                    Image(systemName: "speaker")
                    Spacer()
                    Image(systemName: "speaker.wave.2")
                    Spacer()
                    Image(systemName: "speaker.wave.3")
                }.padding(4)
                VolumeSliderView().frame(height: 40)
                HStack(alignment: .center) {
                    Button("Change", action: {
                        needsURL = true
                    })
                    .buttonStyle(StandardButtonStyle())
                    Spacer()
                    Button("Refresh", action: {
                        needsRefresh = true
                    })
                    .buttonStyle(StandardButtonStyle())
                    Spacer()
                    HStack (alignment: .center, spacing: 2) {
                        VStack(alignment: .trailing) {
                            Text("SCREEN LOCK")
                            Text("OVERRIDE")
                        }.font(.caption2)
                        Toggle("", isOn: $keepOn).padding(0)
                            .labelsHidden()
                    }
                }
            }
        }
    }
    
    func idleTimerhandler() {
        UIApplication.shared.isIdleTimerDisabled = keepOn
    }
    
    var body: some View {
        idleTimerhandler()
        
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
        }.animation(.interactiveSpring())
    }
}
