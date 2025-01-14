//
//  CreateProfileView.swift
//  Spill
//
//  Created by User on 2025-01-13.
//

import SwiftUI

struct CreateProfileView: View {
    
    @State private var name = ""
    @State private var bio = ""
    
    var body: some View {
        VStack {
            navigationBar()
            
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 1.5)
                        })
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                }
            }
            .frame(height: 64)
            .padding(.all, 16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 1.5)
            })
            .padding(.vertical)
            
            
            baseTextField(title: "Profile Name", prompt: "Enter name", text: $name)
                .padding(.vertical, 16)
            
            baseTextField(title: "Bio", prompt: "Enter bio", text: $bio)
            
            Spacer()
            
            Text("Updating your profile name or picture applies only to future Spills; old Spills keep the name and picture from when they were posted.")
                .font(.gilroyMedium10)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
                .foregroundStyle(Color.gray.opacity(0.7))
                .padding(.bottom, 2)
            
            Button {
                
            } label: {
                Text("Continue with Spill")
                    .font(.gilroyMedium16)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 36)
            }
        }
        .padding(.horizontal, 20)
        .background(Color.baseBackgroundColor)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
    
    func navigationBar() -> some View {
        ZStack {
            HStack {
                Spacer()
                
                Image(systemName: "chevron.leading")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            HStack {
                Spacer()
                
                Text("Create Profile")
                    .font(.gilroyMedium16)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
    
    func baseTextField(title: String, prompt: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.gilroyMedium14)
                .foregroundStyle(Color.white)
                .padding(.bottom, 5)
            
            TextField("", text: text, prompt: Text(prompt).foregroundColor(Color.white.opacity(0.5)))
                .font(.gilroyMedium14)
                .foregroundStyle(Color.white)
                .tint(Color.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .overlay(content: { RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1.5) })
        }
    }
}
