//
//  HomeViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    let animatioinButton : UIButton = {
       
        let button = UIButton.init(type: .system)
        button.setTitle("Animation", for: .normal)
        button.addTarget(self,
                         action: #selector(HomeViewController.animActioin),//Selector(("animActioin")),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var monthView : UICollectionView = {
        
        let minimumLineSpacing : CGFloat = 20.0
        let minimumInteritemSpacing : CGFloat = 20.0
        let screenWidth : CGFloat = self.view.frame.width
        let itemWidth : CGFloat = (screenWidth - 2 * 16 - minimumInteritemSpacing) / 2.0
        let itemHeight : CGFloat = (500 - minimumLineSpacing - 2 * minimumLineSpacing) / 2.0
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.itemSize = CGSize.init(width: itemWidth , height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: minimumLineSpacing,
                                           left: 16,
                                           bottom: minimumLineSpacing,
                                           right: 16)
        let v = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .orange
        v.dataSource = self
        v.delegate = self
        v.isPagingEnabled = true
        v.register(MonthCCell.self, forCellWithReuseIdentifier: "MonthCCell")
        return v
    }()
    
    let titleLabel = UILabel()
    
    @objc func animActioin() {
        
        let animator = UIViewPropertyAnimator.init(duration: 2.5, curve: .easeInOut) {
            self.titleLabel.textColor = .red
        }
        animator.startAnimation()
        
//        let month = MonthViewController()
        let month = DayViewController()
        navigationController?.pushViewController(month, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "seq"
//        titleLabel.attributedText = NSAttributedString.init(string: "Seq",
//                                                            attributes: [.foregroundColor:UIColor.clear,
//                                                                         .font:UIFont.systemFont(ofSize: 50),
//                                                                         .strokeColor:UIColor.blue,
//                                                                         .strokeWidth:1])
        self.titleLabel.textColor = .orange
        view.addSubview(titleLabel)
        view.addSubview(self.monthView)
        
        view.addSubview(self.animatioinButton)
        
        self.monthView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(500)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(monthView.snp.bottom)
        }
        animatioinButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(CGSize.init(width: 150, height: 100))
        }
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCCell", for: indexPath) as! MonthCCell
        cell.updateMonthTotalBill((indexPath.row % 2 == 0 ? 123 : 0), month: "Seq")
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
