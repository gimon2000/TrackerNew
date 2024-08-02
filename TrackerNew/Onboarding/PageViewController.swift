//
//  PageViewController.swift
//  TrackerNew
//
//  Created by gimon on 02.08.2024.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    //MARK: - Private Properties
    private lazy var pages: [UIViewController] = {
        guard let image1 = UIImage(named: "first"),
              let image2 = UIImage(named: "second") else {
            return [UIViewController()]
        }
        let first = OnboardingViewController(
            image: image1,
            text: "Отслеживайте только то, что хотите"
        )
        let second = OnboardingViewController(
            image: image2,
            text: "Даже если это не литры воды и йога"
        )
        return [first, second]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Initialization
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didOnboardingShow = UserDefaults.standard.bool(forKey: "didOnboardingShow")
        
        if didOnboardingShow {
            guard let window = UIApplication.shared.windows.first else {
                print(#fileID, #function, #line, "window error")
                return
            }
            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
        }
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

//MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
