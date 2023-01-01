//
//  SplashView.swift
//  MVVM.Kickstarter.SwiftUI
//
//  Created by Mert Saraç on 31.12.2022.
//

import SwiftUI

struct SplashView: View {
  @ObservedObject var viewModel: SplashViewModel
  
  var body: some View {
    ZStack {
      VStack {
        Spacer()
        
        Text("Splash Screen")
          .padding(EdgeInsets(horizontal: 8, vertical: 0))
          .multilineTextAlignment(.center)
        
        Spacer()
      }  
    }
    
  }
}
