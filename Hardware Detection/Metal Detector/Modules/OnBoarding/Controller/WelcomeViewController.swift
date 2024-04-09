//
//  WelcomeViewController.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit

class WelcomeViewController: BaseViewController {

    class func control() -> WelcomeViewController {
        let control = self.control(.OnBoarding) as? WelcomeViewController
        return control ?? WelcomeViewController()
    }
    
    @IBOutlet var pagerView: [UIView]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedIndex = 0
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setUpUI(){
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.scrollDirection = .horizontal
        collectionFlowLayout.minimumLineSpacing = 0
        self.collectionView?.collectionViewLayout = collectionFlowLayout
        self.collectionView.setCollectionViewLayout(collectionFlowLayout, animated: true)
        updatePageViewDotsColor(index: selectedIndex)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            selectedIndex = indexPath.item
        }
        self.collectionView.layoutIfNeeded()
        self.updatePageViewDotsColor(index: selectedIndex)
    }
        
    
    //MARK: - Update dots color
    private func updatePageViewDotsColor(index: Int) {
        for (index, pagerView) in pagerView.enumerated() {
            Helper.dispatchDelay(deadLine: .now() + 0.2, execute: {
                let dotColor = (index <= self.selectedIndex) ? UIColor.white : UIColor.clear
                let dotsBorderColor = (index <= self.selectedIndex) ? UIColor.clear : UIColor.white
                pagerView.backgroundColor = dotColor
                pagerView.layer.borderColor = dotsBorderColor.cgColor
                pagerView.layer.borderWidth = 1
            })
        }
    }
        
    @IBAction func nextClicked(_ sender: UIButton) {
        selectedIndex += 1
        self.updatePageViewDotsColor(index: selectedIndex)
        if selectedIndex > 2 {
            CustomUserDefaults.doneOnboardFlow = true
            self.openSubscription(isRootSet: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCollectionViewCell.identifier, for: indexPath) as? OnboardCollectionViewCell else {return UICollectionViewCell()}
        cell.configureCell(onbaordData: onboardArr[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    
}
