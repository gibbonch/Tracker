//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 16.01.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private var pages: [UIViewController] = []
    private var timer: Timer?
    
    // MARK: - Subviews
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackApp
        pageControl.pageIndicatorTintColor = .blackApp.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var continueButton = FilledButton(title: "Вот это технологии!") { [weak self] in
        UserDefaults.standard.set(true, forKey: Constants.didPresentOnboarding)
        let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate
        let appCoordinator = sceneDelegate?.appCoordinator
        appCoordinator?.switchToTrackers()
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        dataSource = self
        delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        setupView()
        setupLayout()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        startTimer()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(pageControl, continueButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupPages() {
        let page1 = createPage(text: "Отслеживайте только то, что хотите", image: .onboardingBackground1)
        let page2 = createPage(text: "Даже если это не литры воды и йога", image: .onboardingBackground2)
        pages = [page1, page2]
    }
    
    private func createPage(text: String, image: UIImage) -> UIViewController {
        let vc = UIViewController()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackApp
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.addSubviews(imageView, label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
        ])
        
        return vc
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func nextPage() {
        guard let currentViewController = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else { return }
        
        let nextIndex = (currentIndex + 1) % pages.count
        let nextViewController = pages[nextIndex]
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = nextIndex
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == 0 {
            return pages.last
        }
        
        return pages[viewControllerIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == pages.count - 1 {
            return pages.first
        }
        
        return pages[viewControllerIndex + 1]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
            stopTimer()
            startTimer()
        }
    }
}
