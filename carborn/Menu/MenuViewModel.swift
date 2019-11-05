//
//  MenuViewModel.swift
//  carborn
//
//  Created by jud.lee on 2019/11/04.
//  Copyright © 2019 jud.lee. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

protocol MenuViewModelProrocol {
    var menuCollection: Observable<[Menu]> { get }
}

class MenuViewModel: NSObject, MenuViewModelProrocol {
    
    private var _db: Firestore?
    private var db: Firestore {
        get {
            if let db = _db {
                return db
            }
            let db = Firestore.firestore()
            _db = db
            return db
        }
    }
    private var menuCollectionSubject = BehaviorSubject<[Menu]>(value: [])
    var menuCollection: Observable<[Menu]> {
        get {
            return menuCollectionSubject.asObservable()
        }
    }
    
    override init() {
        
    }
    
    func load() {
        db.collection("menu").getDocuments() { [unowned self] (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                let obj = snapshot!.documents.map({ document -> [String: Any] in
                    var data = document.data()
                    data["id"] = document.documentID
                    return data
                })
                let data = try! JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                let collection = try! JSONDecoder().decode([Menu].self, from: data)
                self.menuCollectionSubject.onNext(collection)
//                for document in snapshot!.documents {
//                    print("\(document.documentID):\(document.data())")
//                }
                
            }
        }
    }
    
}
