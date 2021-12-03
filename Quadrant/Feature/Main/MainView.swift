//
//  MainViewController.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import UIKit

class MainView: UIViewController {

    //MARK: Properties
    private let bundle = Bundle(for: MainView.self)
    private let className = String(describing: MainView.self)
    
    //MARK: IBoutlets
    
    
    //MARK: Functions
    init() {
        super.init(nibName: className, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let networkService = NetworkService(networkServiceProtocol: Provider())
        networkService.request(target: MainService.getCurrentPrice, model: CurrentPrice.self) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

