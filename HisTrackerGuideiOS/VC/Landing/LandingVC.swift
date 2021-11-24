//
//  LandingVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 9.11.2021.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet weak var collctionUV: UICollectionView!
    @IBOutlet weak var skipUB: UIButton!
    @IBOutlet weak var nextUB: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            if currentIndex == LANDINGMODELS.count - 1  {
                nextUB.setTitle("Finish", for: .normal)
            } else {
                nextUB.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfPages = LANDINGMODELS.count
        collctionUV.delegate = self
        collctionUV.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func onTapNextUB(_ sender: Any) {
        currentIndex += 1
        if currentIndex >= LANDINGMODELS.count {
            onShowAuthVC()
            return
        } else {
            let contentOffSet = CGFloat(collctionUV.contentOffset.x + collctionUV.frame.width)
            collctionUV.setContentOffset(CGPoint(x: contentOffSet, y: 0), animated: true)
        }
        
    }
    
    @IBAction func onTapSkipUB(_ sender: Any) {
        onShowAuthVC()
    }
    
    func onShowAuthVC() {
        UserDefaults.isPassedLanding = true
        self.performSegue(withIdentifier: SegueNames.goAuthSegue.rawValue, sender: nil)
    }
    
}

//MARK: - UICollectionViewDelegate, FlowLayout, DataSource

extension LandingVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: scrollView.frame.height / 2)
        if let iP = collctionUV.indexPathForItem(at: center) {
            currentIndex = iP.row
            self.pageControl.currentPage = iP.row
        }

    }
    
}
extension LandingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension LandingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LANDINGMODELS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell
        cell?.onboardingModel = LANDINGMODELS[indexPath.row]
        return cell!
    }
    
}


//MARK: - OnBoarding UICollectionViewCell
class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var subTitleLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var onboardingUIMG: UIImageView!
    
    
    var onboardingModel: OnboardingModel! {
        didSet {
            subTitleLB.text = onboardingModel.subTitle
            titleLB.text = onboardingModel.title
            onboardingUIMG.image = onboardingModel.image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subTitleLB.text = ""
        titleLB.text = ""
        onboardingUIMG.image = nil
    }
}


