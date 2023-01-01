//
//  SplashViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Mert Saraç on 31.12.2022.
//

import Foundation

protocol SplashViewModelDelegate: AnyObject {
  func welcomeSettingsDidFetch(_ source: SplashViewModel)
}

class SplashViewModel: ViewModel {
  private let welcomeService: WelcomeServiceProtocol
  
  private weak var delegate: SplashViewModelDelegate?
  
  private var cancelBag: CancelBag!
  
  init(welcomeService: WelcomeServiceProtocol) {
    self.welcomeService = welcomeService
  }
  
  func setup(delegate: SplashViewModelDelegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    welcomeService.fetchWelcomeSettings()
      .sink { _ in
        self.delegate?.welcomeSettingsDidFetch(self)
      }
      .store(in: &self.cancelBag)
  }
}
