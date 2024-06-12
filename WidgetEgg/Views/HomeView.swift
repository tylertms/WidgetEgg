//
//  HomeView.swift
//  WidgetEgg
//
//  Created by Tyler on 5/5/24.
//

import SwiftUI
import CryptoKit
import WidgetKit

struct HomeView: View {
    @State private var EID: String = ""
    @State private var EIUserName: String
    @State private var message: String? = nil
    
    @State private var checkingEID: Bool = false
    @State private var showEIDHelp: Bool = false
    @State private var showWhatNext: Bool = false
    
    init() {
        self.EIUserName = UserDefaults(suiteName: "group.com.MissionInfo")?.string(forKey: "EIUserName") ?? ""
    }
    
    var body: some View {
        VStack(alignment: .center) {
#if os(iOS)
            Spacer()
#endif
            
            Image(.wireframe)
                .resizable()
                .aspectRatio(contentMode: .fit)
#if os(iOS)
                .padding()
                .frame(maxWidth: 150)
#elseif os(watchOS)
                .frame(maxWidth: 60)
#endif
            
            Group {
                if !EIUserName.isEmpty {
                    Text("Welcome, \(EIUserName)!")
                        .lineLimit(2)
                } else {
                    Text("Enter your EID:")
                        .lineLimit(1)
                }
            }
            .minimumScaleFactor(0.2)

            .padding(.horizontal)
            
#if os(iOS)
            .font(.system(size: 30, weight: .semibold))
#elseif os(watchOS)
            .font(.system(size: 20, weight: .semibold))
#endif
            
            TextField("EI0000000000000000", text: $EID)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
#if os(iOS)
                .padding()
                .background(Color.gray.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .contentShape(RoundedRectangle(cornerRadius: .infinity))
                .onTapGesture {}
#elseif os(watchOS)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
#endif
            
            if let message {
                Text(message)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(12.5)
                    .background(message == "Success!" ? Color.green : Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
            
            StackView {
                Button(action: {
                    if checkingEID {
                        return
                    }
                    
                    let basicRequestInfo = getBasicRequestInfo(EID: EID)
                    checkingEID = true
                    
                    Task {
                        do {
                            let backup = try await fetchBackup(basicRequestInfo: basicRequestInfo)
                            if let defaults = UserDefaults(suiteName: "group.com.MissionInfo") {
                                defaults.setValue(EID, forKey: "EID")
                                defaults.setValue(backup.userName, forKey: "EIUserName")
                            }
                            
                            checkingEID = false
                            self.EIUserName = backup.userName
                            self.EID.removeAll()
                            self.message = "Success!"
                            
#if os(iOS)
                            UIApplication.shared.endEditing()
#endif
                            
                            WidgetCenter.shared.reloadAllTimelines()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.message = nil
                            })
                            
                        } catch {
                            checkingEID = false
                            self.message = "Please enter a valid EID!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.message = nil
                            })
                        }
                    }
                    
                }, label: {
                    Text(checkingEID ? "Checking..." : "Submit EID")
                        .font(.system(size: 18, weight: .semibold))
                        .minimumScaleFactor(0.2)
                        .scaledToFit()
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                })
                .background(Color.blue)
                .buttonStyle(PlainButtonStyle())
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .contentShape(RoundedRectangle(cornerRadius: .infinity))
                
                
                Button(action: {
                    if let defaults = UserDefaults(suiteName: "group.com.MissionInfo") {
                        defaults.removeObject(forKey: "EID")
                        defaults.removeObject(forKey: "EIUserName")
                        
                        self.EID.removeAll()
                        self.EIUserName.removeAll()
                        
#if os(iOS)
                        UIApplication.shared.endEditing()
#endif
                        
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }, label: {
                    Text("Sign Out")
                        .font(.system(size: 18, weight: .semibold))
                        .minimumScaleFactor(0.2)
                        .scaledToFit()
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    
                })
                .background(Color.red)
                .buttonStyle(PlainButtonStyle())
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
            .foregroundColor(.white)
            .padding(.bottom, 20)
            
#if os(iOS)
            Spacer()
            
            if EIUserName.isEmpty {
                Button(action: {
                    showEIDHelp = true
                    UIApplication.shared.endEditing()
                }, label: {
                    Text("Where do I find my EID?")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(12.5)
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                })
                .background(Color.gray)
                .buttonStyle(PlainButtonStyle())
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            } else {
                Button(action: {
                    showWhatNext = true
                    UIApplication.shared.endEditing()
                }, label: {
                    Text("What next?")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(12.5)
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                })
                .background(Color.gray)
                .buttonStyle(PlainButtonStyle())
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
#endif
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        
#if os(iOS)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .sheet(isPresented: $showEIDHelp, content: {
            EIDHelpView()
        })
        .sheet(isPresented: $showWhatNext, content: {
            WhatNextView()
        })
#endif
        
    }
    
    
    @ViewBuilder
    private func StackView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
#if os(iOS)
        HStack(content: content)
#elseif os(watchOS)
        VStack(content: content)
#endif
    }
}

#Preview {
    HomeView()
}
