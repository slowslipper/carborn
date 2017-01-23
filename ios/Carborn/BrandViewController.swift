//
//  BrandViewController.swift
//  Carborn
//
//  Created by pureye4u on 23/01/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import RealmSwift

class BrandViewController: UIViewController, UIScrollViewDelegate {
    
    var brands = [String]()
    var brandScrollView = UIScrollView()
    var brandViews = [BrandView]()
    var _selectedIndex = -1
    var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            if _selectedIndex != newValue && newValue < self.brands.count {
                _selectedIndex = newValue
                self.resetCarListView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        // Initialize view
        let frame = self.view.bounds
        let label = UILabel(frame: frame)
        label.font = UIFont(name: "AvenirNextCondensed-UltraLight", size: 100)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "BrandView"
        self.view.addSubview(label)
        
        self.initGesture()
        self.initScrollView()
        self.initCarListData()
    }
    
    func initGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                if self.selectedIndex < 0 {
                    break
                }
                guard let touches = swipeGesture.value(forKey: "touches") as? Set<UITouch> else {
                    break
                }
                
                guard let event = swipeGesture.value(forKey: "event") as? UIEvent else {
                    break
                }
                let modelViewController = ModelViewController(brandName: self.brands[self.selectedIndex], touces: touches, event: event)
                self.navigationController?.pushViewController(modelViewController, animated: false)
                
            default:
                break
            }
        }
    }
    
    func initScrollView() {
        self.brandScrollView.isPagingEnabled = true
        self.brandScrollView.clipsToBounds = false
        self.brandScrollView.showsVerticalScrollIndicator = false
        self.brandScrollView.showsHorizontalScrollIndicator = false
        self.brandScrollView.delegate = self
        let viewSize = self.view.bounds.size
        let size = BrandView.defaultWidth
        let margin = BrandView.defaultMargin
        var frame = CGRect.zero
        frame.origin.x = (viewSize.width - size) * 0.5
        frame.size.width = (size + margin)
        frame.size.height = viewSize.height
        self.brandScrollView.frame = frame
        self.brandScrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        self.view.addSubview(self.brandScrollView)
    }
    
    func initCarListData() {
        let realm = try! Realm()
        
        let cars = realm.objects(Car.self)
        var brands = [String]()
        for car in cars {
            let brand = car.brand
            if brand.characters.count < 1 {
                continue
            }
            guard let _ = brands.index(of: brand) else {
                brands.append(brand)
                continue
            }
        }
        
        self.brands = brands
        self.selectedIndex = self.brands.count > 0 ? 0 : -1
    }
    
    func resetCarListView() {
        // Clear all
        for subView in self.brandScrollView.subviews {
            subView.removeFromSuperview()
        }
        
        if self.selectedIndex < 0 {
            return
        }
        
        // Prepare views
        let count = self.brandViews.count
        if count < 3 {
            for _ in count..<3 {
                self.brandViews.append(BrandView())
            }
        }
        
        let size = BrandView.defaultWidth
        let margin = BrandView.defaultMargin
        var frame = CGRect.zero
        frame.size.width = size
        frame.size.height = size
        var index = -1
        
        // Left
        index = (self.selectedIndex > 0 ? self.selectedIndex : self.brands.count) - 1
        let left = self.brandViews[0]
        left.frame = frame;
        left.brandName = self.brands[index]
        self.brandScrollView.addSubview(left)
        
        // Center
        frame.origin.x += size + margin
        let center = self.brandViews[1]
        center.frame = frame
        center.brandName = self.brands[self.selectedIndex]
        self.brandScrollView.addSubview(center)
        
        // Right
        index = self.selectedIndex + 1 < self.brands.count ? self.selectedIndex + 1 : 0
        frame.origin.x += size + margin
        let right = self.brandViews[2]
        right.frame = frame
        right.brandName = self.brands[index]
        self.brandScrollView.addSubview(right)
        
        self.brandScrollView.contentSize = CGSize(width: frame.origin.x + size + margin, height: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        let offsetX = offset.x
        let size = scrollView.frame.size.width
        let min = size * 0.5
        let max = min + size
        if offsetX < min {
            print("prev")
            offset.x += size
            scrollView.contentOffset = offset
            self.selectPrevious()
        } else if offsetX > max {
            print("next")
            offset.x -= size
            scrollView.contentOffset = offset
            self.selectNext()
        }
    }
    
    func selectNext() {
        if self.selectedIndex + 1 < self.brands.count {
            self.selectedIndex += 1
        } else {
            self.selectedIndex = 0
        }
    }
    
    func selectPrevious() {
        if self.selectedIndex == 0 {
            self.selectedIndex = self.brands.count - 1
        } else {
            self.selectedIndex -= 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}