import SwiftUI
import CryptoKit
import WidgetKit

struct HomeView: View {
    @State private var EID: String = ""
    @State private var EIUserName: String
    @State private var message: String = "NIL"
    
    @State private var checkingEID: Bool = false
    @State private var showEIDHelp: Bool = false
    @State private var showWhatNext: Bool = false
    
    init() {
        self.EIUserName = UserDefaults(suiteName: "group.com.MissionInfo")?.string(forKey: "EIUserName") ?? ""
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Spacer ()
                
                Image(.wireframe)
                    .resizable()
                    .padding()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                
                if EIUserName.isEmpty == false {
                    Text("Welcome, \(EIUserName)!")
                        .font(.system(size: 30, weight: .semibold))
                } else {
                    Text("Enter your EID:")
                        .font(.system(size: 30, weight: .semibold))
                }
                
                TextField("EI0000000000000000", text: $EID)
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(Color.gray.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .font(.system(size: 18))
                    .padding(.horizontal)
                    .contentShape(RoundedRectangle(cornerRadius: .infinity))
                    .onTapGesture {}
                
                HStack {
                    
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
                                
                                UIApplication.shared.endEditing()
                                WidgetCenter.shared.reloadAllTimelines()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.message = "NIL"
                                })
                                
                            } catch {
                                checkingEID = false
                                self.message = "Please enter a valid EID!"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.message = "NIL"
                                })
                            }
                        }
                        
                    }, label: {
                        Text(checkingEID ? "Checking..." : "Submit EID")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12.5)
                            .frame(width: proxy.size.width / 2 - 20)
                            .contentShape(Rectangle())
                    })
                    .background(Color.blue)
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    
                    Button(action: {
                        if let defaults = UserDefaults(suiteName: "group.com.MissionInfo") {
                            defaults.removeObject(forKey: "EID")
                            defaults.removeObject(forKey: "EIUserName")
                            
                            self.EID.removeAll()
                            self.EIUserName.removeAll()
                            
                            UIApplication.shared.endEditing()
                            
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }, label: {
                        Text("Sign Out")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12.5)
                            .frame(width: proxy.size.width / 2 - 20)
                            .contentShape(Rectangle())
                    })
                    .background(Color.red)
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                }
                .foregroundStyle(.white)
                .padding(.bottom, 20)
                
                Text(message)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(12.5)
                    .background(message == "Success!" ? .green : .red)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .opacity(message == "NIL" ? 0 : 1)
                
                Spacer()
                
                if EIUserName.isEmpty {
                    Button(action: {
                        showEIDHelp = true
                        UIApplication.shared.endEditing()
                    }, label: {
                        Text("Where do I find my EID?")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12.5)
                            .frame(width: proxy.size.width - 30)
                            .contentShape(Rectangle())
                    })
                    .background(Color.gray)
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)
                } else {
                    Button(action: {
                        showWhatNext = true
                        UIApplication.shared.endEditing()
                    }, label: {
                        Text("What next?")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12.5)
                            .frame(width: proxy.size.width - 30)
                            .contentShape(Rectangle())
                    })
                    .background(Color.gray)
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .multilineTextAlignment(.center)
        .sheet(isPresented: $showEIDHelp, content: {
            EIDHelpView()
        })
        .sheet(isPresented: $showWhatNext, content: {
            WhatNextView()
        })
    }
}
