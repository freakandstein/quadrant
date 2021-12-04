//
//  MainProtocol.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation
import Charts

protocol MainViewToPresenter {
    var view: MainPresenterToView? { get set }
    var interactor: MainPresenterToInteractor? { get set }
    
    func viewDidLoad()
    func getTotalPriceIndex() -> Int
    func getPriceIndex(index: Int) -> PriceIndex
    func getTimePriceIndex(index: Int) -> String
    func getValuePriceIndex(index: Int) -> String
    func getLongitudePriceIndex(index: Int) -> String
    func getLatitudePriceIndex(index: Int) -> String
    func populateChartDataEntry() -> [ChartDataEntry]
    func getMaxAxis() -> Double
}

protocol MainPresenterToView {
    var presenter: MainViewToPresenter? { get set }
    
    func setupTableView()
    func setupChart()
    func reloadTableView()
    func updateChart()
    func showLoading()
    func dismissLoading()
    func updateDateTitle(dateText: String)
}

protocol MainPresenterToInteractor {
    var presenter: MainInteractorToPresenter? { get set }
    var networkService: NetworkService { get set }
    var dataService: DataServiceProtocol { get set }
    var locationService: LocationProtocol { get set }
    
    func getCurrencyIndex()
    func loadCurrencyIndex() -> [PriceIndex]
    func getCurrentLocation()
}

protocol MainInteractorToPresenter {
    var currentPrice: CurrentPriceResponse? { get set }
    var listPriceIndex: [PriceIndex] { get set }
    var latestPriceIndex: [PriceIndex] { get set }
    
    func didGetCurrencyIndexSuccess(response: CurrentPriceResponse)
    func didGetCurrencyIndexFailure(error: ErrorResponse)
}
