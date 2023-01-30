//
//  ArticleVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import UIKit

class ArticleVC: UIViewController {
    
    @IBOutlet weak var currentDateLB: UILabel!
    @IBOutlet weak var bodyUB: UIButton!
    @IBOutlet weak var emotionUB: UIButton!
    @IBOutlet weak var actionUB: UIButton!
    @IBOutlet weak var carouselCV: UICollectionView!
    
    var btns: [UIButton] = [UIButton]()
    var carouselArr: [CarouselModel] = [CarouselModel]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientView()
        btns.append(bodyUB)
        btns.append(emotionUB)
        btns.append(actionUB)
        handleTapUB(index: 0)
        
        currentDateLB.text = CalendarUtil().getDateWithSuffix(date: Date())
        
        carouselCV.register(UINib(nibName: "ArticleCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
        getCarouselData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpCarousel()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func addGradientView() {
        let gradientUV = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let gradient = CAGradientLayer()
        gradient.frame = gradientUV.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.articleBackgroundColor.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setUpCarousel() {
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: carouselCV.frame.size.width - 48.0, height: carouselCV.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.85
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 10.0)
        carouselCV.collectionViewLayout = flowLayout
        carouselCV.delegate = self
        carouselCV.dataSource = self
    }
    
    func getCarouselData() {
//        for i in 10...19 {
//            let model = CarouselModel(image: UIImage(named: "sample_woman_\(i)")!, isRead: i % 2 == 0)
//            carouselArr.append(model)
//        }
//        carouselCV.reloadData()
        carouselArr.removeAll()
        FireUtil.instance.getArticles { (carousels) in
            self.carouselArr.append(contentsOf: carousels)
            self.carouselCV.reloadData()
        }
    }
    
    @IBAction func didTapTabUB(_ sender: UIButton) {
        handleTapUB(index: sender.tag)
    }
    
    func handleTapUB(index: Int) {
        btns.forEach { (item) in
            if item.tag == index {
                item.backgroundColor = UIColor(named: "mainBlue")
                item.layer.cornerRadius = 20.0
                item.setTitleColor(.white, for: .normal)
                item.layer.borderWidth = 0.0
            } else {
                item.backgroundColor = .white
                item.layer.cornerRadius = 20.0
                item.setTitleColor(UIColor(named: "mainBlack"), for: .normal)
                item.layer.borderWidth = 1.0
                item.layer.borderColor = UIColor(named: "mainText")?.cgColor
            }
        }
    }
    
    @IBAction func didTapReadMorUB(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapBackNextUB(_ sender: UIButton) {
        handleCarousel(direction: sender.tag)
    }
    
    func handleCarousel(direction: Int) {
        let collctionLayout = carouselCV.collectionViewLayout as? UPCarouselFlowLayout
        let itemWidth = collctionLayout?.itemSize.width
        let spacing = abs(10.0 - (itemWidth! * 0.15) / 2)
        let delta = itemWidth! - spacing
        if direction == 0 {
            if currentIndex == 0 {
                return
            } else {
                currentIndex -= 1
                let contentOffSet = CGFloat(carouselCV.contentOffset.x - delta)
                carouselCV.setContentOffset(CGPoint(x: contentOffSet, y: 0), animated: true)
            }
        } else {
            if currentIndex >= carouselArr.count - 1 {
                return
            } else {
                currentIndex += 1
                print(carouselCV.contentOffset.x)
                
                let contentOffSet = CGFloat(carouselCV.contentOffset.x + delta)
                carouselCV.setContentOffset(CGPoint(x: contentOffSet, y: 0), animated: true)
            }
        }
    }
    
}

//MARK: - CollectionView Data Source, Delegate

extension ArticleVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: scrollView.frame.height / 2)
        if let iP = carouselCV.indexPathForItem(at: center) {
            currentIndex = iP.row
        }

    }
}

extension ArticleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.model = carouselArr[indexPath.row]
        return cell
    }
    
}
