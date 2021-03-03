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
    @State private var optionChevronRotation: Double = 0
    @State private var showOptions: Bool = true
    @State private var nsURL: String = "https://nightscoutfoundation.org"
    @ObservedObject var viewModel = ViewModel()
    
    let defaults = UserDefaults.standard
    
    init() {
        
    }
        
    var mainWebView: some View {
        WebView(url: .publicUrl, viewModel: viewModel)
    }
    
    var enterURL: some View {
        VStack(alignment: .leading) {
            Text("Hello!")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("Please enter your Nighscout URL: ")
                .fontWeight(.thin)
            Text("...be sure to include http:// or https://")
                .padding(.top, 4)
                .font(.footnote)
                .foregroundColor(.orange)
            Divider()
            TextField("Enter URL", text: $nsURL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 12)
                .padding(.bottom, 12)
            Divider()
            HStack {
                Button("Clear", action: {
                    nsURL = ""
                })
                .buttonStyle(StandardButtonStyle())
                Button("Cancel", action: {
                    needsURL = false
                    nsURL = defaults.string(forKey: "ns_url") ?? nsURL
                })
                .buttonStyle(StandardButtonStyle())
                Spacer()
                Button("Done", action: {
                    needsURL = false
                    print(nsURL)
                    defaults.set(nsURL, forKey: "ns_url")
                    defaults.synchronize()
                })
                .buttonStyle(StandardButtonStyle())
            }
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
                        self.viewModel.webViewNavigationPublisher.send(.reload)
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
        
        return VStack {
            if !needsURL {
                mainWebView
                optionsClusterView
                    .padding()
            }
            if needsURL {
                enterURL
                    .padding()
            }
        }.animation(.interactiveSpring())
        .onAppear(){
            nsURL = defaults.string(forKey: "ns_url") ?? nsURL
            print(nsURL)
        }
    }
}
