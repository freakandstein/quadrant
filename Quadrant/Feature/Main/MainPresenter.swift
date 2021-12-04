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
    var latestPriceIndex: [PriceIndex] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getCurrencyIndex()
        view?.setupTableView()
        view?.setupChart()
    }
    
    func getTotalPriceIndex() -> Int {
        return latestPriceIndex.count
    }
    
    func getPriceIndex(index: Int) -> PriceIndex {
        return latestPriceIndex[index]
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
        for priceIndex in listPriceIndex {
            let day = Double(priceIndex.dateTime.formatDateInString(convertDateTo: DateFormatConstant.days.value)) ?? .zero
            let chartDataEntry = ChartDataEntry(x: day, y: priceIndex.value)
            chartDataEntries.append(chartDataEntry)
        }
        return chartDataEntries
    }
    
    func getMaxAxis() -> Double {
        guard let priceIndex = latestPriceIndex.first else { return .zero }
        let rounded = priceIndex.value.rounded(.towardZero)
        let maxAxis = rounded + 10_000
        return maxAxis
    }
}

extension MainPresenter: MainInteractorToPresenter {
    
    func loadCurrencyIndexFailure(error: ErrorResponse) {
        view?.dismissLoading()
        debugPrint(error)
    }
    
    func didGetCurrencyIndexSuccess(response: CurrentPriceResponse) {
        currentPrice = response
        listPriceIndex = interactor?.loadCurrencyIndex() ?? []
        if listPriceIndex.count > 5 {
            latestPriceIndex = Array(listPriceIndex.prefix(5))
        } else {
            latestPriceIndex = listPriceIndex
        }
        let currentDate = currentPrice?.time.updatedISO.formatDateInString(convertDateTo: DateFormatConstant.daily.value)
        view?.updateDateTitle(dateText: currentDate ?? .emptyString)
        view?.updateChart()
        view?.reloadTableView()
        view?.dismissLoading()
    }
    
    func didGetCurrencyIndexFailure(error: ErrorResponse) {
        view?.dismissLoading()
        debugPrint(error)
    }

}
