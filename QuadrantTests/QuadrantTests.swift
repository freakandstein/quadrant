//
//  QuadrantTests.swift
//  QuadrantTests
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Quick
import Nimble
import Moya
import Charts

@testable import Quadrant

class QuadrantTests: QuickSpec {
    
    class MainViewMock: MainPresenterToView {
        var presenter: MainViewToPresenter?
        
        var isSetupTableViewCalled = false
        func setupTableView() {
            isSetupTableViewCalled = true
        }

        var isSetupChartCalled = false
        func setupChart() {
            isSetupChartCalled = true
        }
        
        var isReloadTableViewCalled = false
        func reloadTableView() {
            isReloadTableViewCalled = true
        }
        
        var isUpdateChartCalled = false
        func updateChart() {
            isUpdateChartCalled = true
        }
        
        var isShowLoadingCalled = false
        func showLoading() {
            isShowLoadingCalled = true
        }
        
        var isDismissLoadingCalled = false
        func dismissLoading() {
            isDismissLoadingCalled = true
        }
        
        var isUpdateDateTitleCalled = false
        func updateDateTitle(dateText: String) {
            isUpdateDateTitleCalled = true
        }
    }
    
    class MainInteractorMock: MainPresenterToInteractor {
        var presenter: MainInteractorToPresenter?
        var networkService: NetworkService = NetworkService(networkServiceProtocol: NetworkServiceMock())
        var dataService: DataServiceProtocol = DataServiceMock()
        var locationService: LocationServiceProtocol = LocationServiceMock()
        
        var isGetCurrencyIndexCalled = false
        func getCurrencyIndex() {
            isGetCurrencyIndexCalled = true
        }
        
        var isLoadCurrencyIndexCalled = false
        func loadCurrencyIndex() -> [PriceIndex] {
            isLoadCurrencyIndexCalled = true
            return []
        }
        
        var isGetCurrentLocationCalled = false
        func getCurrentLocation() {
            isGetCurrentLocationCalled = true
        }
        
        var isGetDailyCurrentIndexCalled = false
        func getDailyCurrencyIndex() {
            isGetDailyCurrentIndexCalled = true
        }
    }
    
    class MainPresenterMock: MainInteractorToPresenter {
        var currentPrice: CurrentPriceResponse?
        var listPriceIndex: [PriceIndex] = []
        
        var isDidGetCurrencyIndexSuccessCalled = false
        func didGetCurrencyIndexSuccess(response: CurrentPriceResponse) {
            isDidGetCurrencyIndexSuccessCalled = true
        }
        
        var isDidGetCurrencyIndexFailureCalled = false
        func didGetCurrencyIndexFailure(error: ErrorResponse) {
            isDidGetCurrencyIndexFailureCalled = true
        }
        
        var isDidLoadCurrencyIndexSuccessCalled = false
        func didLoadCurrencyIndexSuccess(priceIndex: PriceIndex) {
            isDidLoadCurrencyIndexSuccessCalled = true
        }
    }
    
    class NetworkServiceMock: NetworkServiceProtocol {
        var isRequestCalled = false
        func request<T, M>(target: T, model: M.Type, completion: @escaping (Result<M, Error>) -> Void) where T : TargetType, M : Decodable {
            isRequestCalled = true
        }
    }
    
    class DataServiceMock: DataServiceProtocol {
        var isSaveCalled = false
        func save<T>(data: [T], key: String) throws where T : Decodable, T : Encodable {
            isSaveCalled = true
        }
        
        var isLoadCalled = false
        func load(key: String) throws -> Data {
            isLoadCalled = true
            return Data()
        }
        
        var isRemoveCalled = false
        func remove(key: String) throws {
            isRemoveCalled = true
        }
    }
    
    class LocationServiceMock: LocationServiceProtocol {
        var isGetLatitudeCalled = false
        func getLatitude() -> Double {
            isGetLatitudeCalled = true
            return .zero
        }
        
        var isGetLongitudeCalled = false
        func getLongitude() -> Double {
            isGetLongitudeCalled = true
            return .zero
        }
        
        var isReqestLocationCalled = false
        func requestLocation() {
            isReqestLocationCalled = true
        }
    }
    
    override func spec() {
        
        //MARK: Unit Test MainViewPresenter
        describe("MainViewPresenter") {
            var sut: MainPresenter!
            var viewMock: MainViewMock!
            var interactorMock: MainInteractorMock!
            
            beforeEach {
                sut = MainPresenter()
                viewMock = MainViewMock()
                interactorMock = MainInteractorMock()
                sut.interactor = interactorMock
                sut.view = viewMock
                sut.listPriceIndex = [PriceIndex(dateTime: "2021-12-05T10:22:00+00:00", value: 5566.5566, longitude: "24.4444", latitude: "42.2222")]
            }
            afterEach {
                sut.listPriceIndex = []
            }
            
            context("viewDidLoad function") {
                it("called") {
                    sut.viewDidLoad()
                    expect(viewMock.isShowLoadingCalled).to(beTrue())
                    expect(interactorMock.isGetDailyCurrentIndexCalled).to(beTrue())
                    expect(viewMock.isSetupChartCalled).to(beTrue())
                    expect(viewMock.isSetupTableViewCalled).to(beTrue())
                }
            }
            
            context("getTotalPriceIndex function") {
                it("called") {
                    sut.getTotalPriceIndex()
                    expect(sut.listPriceIndex.count).to(equal(1))
                }
            }
            
            context("getPriceIndex function") {
                it("called") {
                    let priceIndex = sut.getPriceIndex(index: 0)
                    expect(priceIndex.value).to(equal(5566.5566))
                }
            }
            
            context("getTimePriceIndex function") {
                it("called") {
                    let timeString = sut.getTimePriceIndex(index: 0)
                    expect(timeString).to(equal("Time: 17:22"))
                }
            }

            context("getValuePriceIndex function") {
                it("called") {
                    let value = sut.getValuePriceIndex(index: 0)
                    expect(value).to(equal("USD: 5566.5566"))
                }
            }
            
            context("getLongitudePriceIndex function") {
                it("called") {
                    let longitude = sut.getLongitudePriceIndex(index: 0)
                    expect(longitude).to(equal("Longitude: 24.4444"))
                }
            }
            
            context("getLatitudePriceIndex function") {
                it("called") {
                    let latitude = sut.getLatitudePriceIndex(index: 0)
                    expect(latitude).to(equal("Latitude: 42.2222"))
                }
            }
            
            context("getCurrencyIndexPrice function") {
                it("called") {
                    sut.getCurrencyIndexPrice()
                    expect(viewMock.isShowLoadingCalled).to(beTrue())
                    expect(interactorMock.isGetCurrencyIndexCalled).to(beTrue())
                }
            }
            
            context("populateChartDataEntry function") {
                it("called") {
                    let chartDataEntries = sut.populateChartDataEntry()
                    expect(chartDataEntries.count).to(equal(0))
                }
            }
            
            context("renderView function") {
                it("called") {
                    sut.renderView()
                    expect(viewMock.isUpdateChartCalled).to(beTrue())
                    expect(viewMock.isReloadTableViewCalled).to(beTrue())
                    expect(viewMock.isDismissLoadingCalled).to(beTrue())
                }
            }
            
            context("getMaxAxis function") {
                it("called") {
                    let maxAxis = sut.getMaxAxis()
                    expect(maxAxis).to(equal(15566))
                }
            }
        }
        
        //MARK: Unit Test MainViewInteractor
        describe("MainViewInteractor") {
            var sut: MainInteractor!
            var presenterMock: MainPresenterMock!
            var networkServiceMock: NetworkServiceMock!
            var dataServiceMock: DataServiceMock!
            var locationServiceMock: LocationServiceMock!
            
            beforeEach {
                sut = MainInteractor()
                presenterMock = MainPresenterMock()
                networkServiceMock = NetworkServiceMock()
                dataServiceMock = DataServiceMock()
                locationServiceMock = LocationServiceMock()
                sut.presenter = presenterMock
                sut.networkService = NetworkService(networkServiceProtocol: networkServiceMock)
                sut.dataService = dataServiceMock
                sut.locationService = locationServiceMock
            }
            
            context("getCurrencyIndex function") {
                it("called") {
                    sut.getCurrencyIndex()
                    expect(networkServiceMock.isRequestCalled).to(beTrue())
                }
            }
            
            context("getCurrentLocation function") {
                it("called") {
                    sut.getCurrentLocation()
                    expect(locationServiceMock.isReqestLocationCalled).to(beTrue())
                }
            }
        }
    }
}
