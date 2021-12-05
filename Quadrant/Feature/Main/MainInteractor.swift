//
//  MainInteractor.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation

class MainInteractor: MainPresenterToInteractor {
    var presenter: MainInteractorToPresenter?
    var networkService: NetworkService = NetworkService(networkServiceProtocol: Provider(isDebugMode: true))
    var dataService: DataServiceProtocol = DataService.shared
    var locationService: LocationServiceProtocol = LocationService.shared
    
    func getCurrencyIndex() {
        networkService.request(target: MainService.getCurrentPrice, model: CurrentPriceResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let dateTime = response.time.updatedISO
                    let value = response.bpi.usd.rateFloat
                    let longitude = String((self?.locationService.getLongitude() ?? .zero))
                    let latitude = String(self?.locationService.getLatitude() ?? .zero)
                    let priceIndex = PriceIndex(dateTime: dateTime, value: value, longitude: longitude, latitude: latitude)
                    if var listPriceindex = self?.loadCurrencyIndex() {
                        listPriceindex.append(priceIndex)
                        let sortedList = listPriceindex.sorted { $0.dateTime.toDate().compare($1.dateTime.toDate()) == .orderedDescending }
                        try self?.dataService.save(data: sortedList, key: PriceIndex.structName)
                    } else {
                        try self?.dataService.save(data: [priceIndex], key: PriceIndex.structName)
                    }
                    self?.presenter?.didGetCurrencyIndexSuccess(response: response)
                } catch {
                    self?.presenter?.didGetCurrencyIndexFailure(error: .saveError())
                }
            case .failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    self?.presenter?.didGetCurrencyIndexFailure(error: errorResponse)
                } else {
                    self?.presenter?.didGetCurrencyIndexFailure(error: .generalError())
                }
            }
        }
    }
    
    func loadCurrencyIndex() -> [PriceIndex] {
        do {
            let data = try dataService.load(key: PriceIndex.structName)
            let listPriceIndex = try JSONDecoder().decode([PriceIndex].self, from: data)
            return listPriceIndex
        } catch {
            return []
        }
    }
    
    func getCurrentLocation() {
        locationService.requestLocation()
    }
    
    func getDailyCurrencyIndex() {
        let listPriceIndex = loadCurrencyIndex()
        let today = Date().toString(withFormat: DateFormatConstant.days.value)
        let listPriceIndexDaily = listPriceIndex.filter {
            return ($0.dateTime.toDate().toString(withFormat: DateFormatConstant.days.value) == today)
        }
        let sortedList = listPriceIndexDaily.sorted { $0.dateTime.toDate().compare($1.dateTime.toDate()) == .orderedDescending }
        try? dataService.save(data: sortedList, key: PriceIndex.structName)
        if let latestPriceIndex = sortedList.first {
            presenter?.didLoadCurrencyIndexSuccess(priceIndex: latestPriceIndex)
        } else {
            getCurrencyIndex()
        }
    }
}
