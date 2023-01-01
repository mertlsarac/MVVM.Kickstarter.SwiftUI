//
//  WelcomeService.swift
//  MVVM.Kickstarter.SwiftUI
//
//  Created by Mert Saraç on 31.12.2022.
//

import Foundation
import Combine
import CombineExt


protocol WelcomeServiceProtocol: AnyObject {
  func fetchWelcomeSettings() -> AnyPublisher<WelcomeSettings, Error>
}

class WelcomeService: WelcomeServiceProtocol {
  private let _welcomeSettings: CurrentValueSubject<WelcomeSettings?, Never> = CurrentValueSubject(nil)
  var welcomeSettings: AnyPublisher<WelcomeSettings?, Never> { self._welcomeSettings.eraseToAnyPublisher() }
  
  func fetchWelcomeSettings() -> AnyPublisher<WelcomeSettings, Error> {
    let welcomeSettings = WelcomeSettings(shouldShowWelcomeSettings: true)
    self._welcomeSettings.send(welcomeSettings)
    return self._welcomeSettings
      .debounce(for: .seconds(2), scheduler: RunLoop.main)
      .prefix(1)
      .setFailureType(to: Error.self)
      .flatMapLatest { (newWelcomeSettings: WelcomeSettings?) -> AnyPublisher<WelcomeSettings, Error> in
        if newWelcomeSettings == welcomeSettings {
          return Just(welcomeSettings)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        } else {
          return Fail(error: Errors.entryDenied)
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}

extension WelcomeService {
  enum Errors: Error {
    case entryDenied
  }
}

struct WelcomeSettings: Equatable {
  let shouldShowWelcomeSettings: Bool
  
  static func ==(lhs: WelcomeSettings, rhs: WelcomeSettings) -> Bool {
    return lhs.shouldShowWelcomeSettings == rhs.shouldShowWelcomeSettings
  }
}
