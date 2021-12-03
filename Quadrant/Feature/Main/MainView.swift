//
//  MainViewController.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import UIKit
import Charts

class MainView: UIViewController {

    //MARK: Properties
    private let bundle = Bundle(for: MainView.self)
    private let className = String(describing: MainView.self)
    private lazy var data: [PriceIndex] = {
        return [
            PriceIndex(time: "11:00", value: "62.0000", longitude: "24.4444", latitude: "33.3333"),
            PriceIndex(time: "11:05", value: "63.0000", longitude: "24.4448", latitude: "33.3332"),
            PriceIndex(time: "11:10", value: "64.0000", longitude: "24.4447", latitude: "33.3331"),
            PriceIndex(time: "11:15", value: "65.0000", longitude: "24.4446", latitude: "33.3336"),
            PriceIndex(time: "11:20", value: "61.0000", longitude: "24.4443", latitude: "33.3335"),
            PriceIndex(time: "11:25", value: "60.0000", longitude: "24.4442", latitude: "33.3334"),
            PriceIndex(time: "11:30", value: "59.0000", longitude: "24.4441", latitude: "33.3330"),
            PriceIndex(time: "11:35", value: "69.0000", longitude: "24.4440", latitude: "33.3339")
        ]
    }()
    
    //MARK: IBoutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: Functions
    init() {
        super.init(nibName: className, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: MainCellView.className, bundle: Bundle(for: MainCellView.self)), forCellReuseIdentifier: MainCellView.className)
        setupChart()
        // Do any additional setup after loading the view.
//        let networkService = NetworkService(networkServiceProtocol: Provider())
//        networkService.request(target: MainService.getCurrentPrice, model: CurrentPrice.self) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    private func setupChart() {
        chartView.delegate = self
        chartView.setScaleEnabled(true)

        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = 10000
        leftAxis.axisMinimum = .zero
        leftAxis.gridLineWidth = .zero
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = .zero
        xAxis.axisMinimum = .zero
        
        chartView.rightAxis.enabled = false
        chartView.legend.form = .empty
        
        let set1 = LineChartDataSet(entries: [], label: "")
        set1.drawIconsEnabled = false
        set1.setColor(.clear)
        set1.setCircleColor(.clear)
        set1.lineWidth = CGFloat(UIConstant.LineWidth.thin.value)
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: .zero)
        set1.formLineWidth = CGFloat(UIConstant.LineWidth.thin.value)
        set1.formSize = CGFloat(UIConstant.FormSize.small.value)

        let value1 = ChartDataEntry(x: Double(8), y: 0)
        let value2 = ChartDataEntry(x: Double(10), y: 9000)
        let value3 = ChartDataEntry(x: Double(12), y: 0)
        set1.addEntryOrdered(value1)
        set1.addEntryOrdered(value2)
        set1.addEntryOrdered(value3)
        set1.mode = .cubicBezier
        set1.fillAlpha = 0.5
        set1.fillColor = .green
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        chartView.data = data
        chartView.animate(xAxisDuration: UIConstant.Duration.short.value)
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCellView.className) as? MainCellView else { return UITableViewCell() }
        cell.timeLabel.text = "Time: \(data[indexPath.row].time)"
        cell.valueLabel.text = "USD: \(data[indexPath.row].value)"
        cell.longitudeLabel.text = "Longitude: \(data[indexPath.row].longitude)"
        cell.latitudeLabel.text = "Latitude: \(data[indexPath.row].latitude)"
        return cell
    }
}

extension MainView: ChartViewDelegate {
    
}



