//
//  MainPresenter.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation
import Charts

class MainPresenter: MainViewToPresenter {
    var view: MainPresenterToView?
    var interactor: MainPresenterToInteractor?
    var currentPrice: CurrentPriceResponse?
    var listPriceIndex: [PriceIndex] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getDailyCurrencyIndex()
        view?.setupTableView()
        view?.setupChart()
    }
    
    func getTotalPriceIndex() -> Int {
        return listPriceIndex.count
    }
    
    func getPriceIndex(index: Int) -> PriceIndex {
        return listPriceIndex[index]
    }
    
    func getTimePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        let time = priceIndex.dateTime.formatDateInString(convertDateTo: DateFormatConstant.time.value)
        let timeText = "Time: \(time)"
        return timeText
    }
    
    func getValuePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        let valueText = "USD: \(priceIndex.value)"
        return valueText
    }
    
    func getLongitudePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        let longitudeText = "Longitude: \(priceIndex.longitude)"
        return longitudeText
    }
    
    func getLatitudePriceIndex(index: Int) -> String {
        let priceIndex = getPriceIndex(index: index)
        let latitudeText = "Latitude: \(priceIndex.latitude)"
        return latitudeText
    }
    
    func populateChartDataEntry() -> [ChartDataEntry] {
        var chartDataEntries: [ChartDataEntry] = []
        if let allListPriceIndex = interactor?.loadCurrencyIndex() {
            for priceIndex in allListPriceIndex {
                let hours = Double(priceIndex.dateTime.formatDateInString(convertDateTo: DateFormatConstant.hours.value)) ?? .zero
                let chartDataEntry = ChartDataEntry(x: hours, y: priceIndex.value)
                chartDataEntries.append(chartDataEntry)
            }
        }
        return chartDataEntries
    }
    
    func getMaxAxis() -> Double {
        guard let priceIndex = listPriceIndex.first else { return .zero }
        let rounded = priceIndex.value.rounded(.towardZero)
        let maxAxis = rounded + 10_000
        return maxAxis
    }
    
    func getCurrencyIndexPrice() {
        view?.showLoading()
        interactor?.getCurrencyIndex()
    }
    
    private func pickLatestCurrencyIndex() -> [PriceIndex] {
        var listPriceIndex = interactor?.loadCurrencyIndex() ?? []
        if listPriceIndex.count > 5 {
            listPriceIndex = Array(listPriceIndex.prefix(5))
        }
        return listPriceIndex
    }
    
    private func renderView() {
        view?.updateChart()
        view?.reloadTableView()
        view?.dismissLoading()
    }
}

extension MainPresenter: MainInteractorToPresenter {
    
    func loadCurrencyIndexFailure(error: ErrorResponse) {
        view?.dismissLoading()
        debugPrint(error)
    }
    
    func didGetCurrencyIndexSuccess(response: CurrentPriceResponse) {
        currentPrice = response
        listPriceIndex = pickLatestCurrencyIndex()
        let currentDate = currentPrice?.time.updatedISO.formatDateInString(convertDateTo: DateFormatConstant.daily.value)
        view?.updateDateTitle(dateText: currentDate ?? .emptyString)
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstant.Duration.glance.value, execute: {
            self.renderView()
        })
    }
    
    func didGetCurrencyIndexFailure(error: ErrorResponse) {
        view?.dismissLoading()
        debugPrint(error)
    }
    
    func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex) {
        listPriceIndex = pickLatestCurrencyIndex()
        let currentDate = priceIndex.dateTime.formatDateInString(convertDateTo: DateFormatConstant.daily.value)
        view?.updateDateTitle(dateText: currentDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstant.Duration.glance.value, execute: {
            self.renderView()
        })
    }

}
