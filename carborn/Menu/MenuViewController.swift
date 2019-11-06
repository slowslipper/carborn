//
//  MenuViewController.swift
//  carborn
//
//  Created by jud.lee on 2019/11/04.
//  Copyright © 2019 jud.lee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class MenuViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var tableView = UITableView()
    
    var viewModel: MenuViewModel? {
        didSet {
            print("viewModel did set")
            if isViewLoaded {
                self.bindMenuViewModel()
            }
            self.viewModel?.load()
//            self.viewModel?.menuCollection.subscribe(onNext: { collection in
//                debugPrint(collection)
//            }, onError: { error in
//                debugPrint(error.localizedDescription)
//            }, onCompleted: {
//                debugPrint("MenuViewModel menuCollection completed")
//            }, onDisposed: {
//                debugPrint("MenuViewModel menuCollection disposed")
//            }).disposed(by: disposeBag)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.center.size.equalToSuperview()
        }
        
        bindMenuViewModel()
    }
    
    private func bindMenuViewModel() {
        guard let viewModel = viewModel else {
            return
        }
//        tableView.rx.
        viewModel.menuCollection.bind(to: tableView.rx.items(cellIdentifier: "MenuTableViewCell", cellType: UITableViewCell.self)) { (index: Int, element: Menu, cell: UITableViewCell) in
            print(element.name)
            cell.textLabel?.text = element.name
        }.disposed(by: disposeBag)
    }
    
}
