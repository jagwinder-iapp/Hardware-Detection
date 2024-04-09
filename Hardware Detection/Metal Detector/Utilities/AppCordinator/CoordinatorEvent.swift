//
//  CoordinatorEvent.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import Foundation
import UIKit
import Combine


//MARK: - Navigation Events

enum NavigationEvent {
    case push(UIViewController)
    case present(UIViewController, UIModalPresentationStyle)
    case pop
    case dismiss
    case none
}

//MARK: - Flow

class Cordinator<Step> {
    weak var navigationController : UINavigationController?
    var cancellables: Set<AnyCancellable> = Set()
    @Published var step: Step?

    @discardableResult
    func navigate(to stepper: Step) -> NavigationEvent {
        return .none
    }
    
    private func navigate(flowAction: NavigationEvent) {
        switch flowAction {
        case .dismiss:
            if let presentedViewController = navigationController?.presentedViewController {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                navigationController?.topViewController?.dismiss(animated: true, completion: nil)
            }

        case .push(let controller):
            navigationController?.pushViewController(controller, animated: true)

        case .pop:
            navigationController?.popViewController(animated: true)

        case .present(let controller, let style):
            controller.modalPresentationStyle = style

            if let presentedViewController = navigationController?.presentedViewController {
                presentedViewController.present(controller, animated: true, completion: nil)
            } else {
                navigationController?.topViewController?.present(
                    controller,
                    animated: true,
                    completion: nil
                )
            }

        case .none:
            break
        }
    }
    
    @discardableResult
    public func start() -> UIViewController? {
        $step
            .compactMap { $0 }
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.navigate(flowAction: self.navigate(to: $0))
            }
            .store(in: &cancellables)

        return navigationController
    }
    
}
