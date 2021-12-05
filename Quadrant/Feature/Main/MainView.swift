//
//  MainViewController.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import UIKit
import Charts

class MainView: UIViewController, MainPresenterToView {
    
    //MARK: Properties
    private let bundle = Bundle(for: MainView.self)
    private let className = String(describing: MainView.self)
    var presenter: MainViewToPresenter?
    
    //MARK: IBoutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: Functions
    init() {
        super.init(nibName: className, bundle: bundle)
        // Initialize VIPE(R)
        let view = self
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func updateDateTitle(dateText: String) {
        dateLabel.text = dateText
    }
    
    func setupTableView() {
        let mainCellViewNib = UINib(nibName: MainCellView.className, bundle: Bundle(for: MainCellView.self))
        tableView.register(mainCellViewNib, forCellReuseIdentifier: MainCellView.className)
    }
    
    func setupChart() {
        chartView.delegate = self
        chartView.setScaleEnabled(true)
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = .zero
        leftAxis.axisMinimum = .zero
        leftAxis.gridLineWidth = .zero
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = .zero
        xAxis.axisMinimum = .zero
        
        chartView.rightAxis.enabled = false
        chartView.legend.form = .empty
    }
    
    func updateChart() {
        chartView.leftAxis.axisMaximum = presenter?.getMaxAxis() ?? .zero
        let dataSet = LineChartDataSet(entries: [], label: .emptyString)
        dataSet.drawIconsEnabled = false
        dataSet.setColor(.clear)
        dataSet.setCircleColor(.clear)
        dataSet.lineWidth = CGFloat(UIConstant.LineWidth.thin.value)
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: .zero)
        dataSet.formLineWidth = CGFloat(UIConstant.LineWidth.thin.value)
        dataSet.formSize = CGFloat(UIConstant.FormSize.small.value)
    
        (presenter?.populateChartDataEntry() ?? []).forEach { (chartData) in dataSet.addEntryOrdered(chartData) }
        dataSet.mode = .cubicBezier
        dataSet.fillAlpha = UIConstant.Alpha.medium.value
        dataSet.fillColor = .green
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.animate(xAxisDuration: UIConstant.Duration.short.value)
        chartView.setNeedsDisplay()
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        loadingIndicator.isHidden = false
    }
    
    func dismissLoading() {
        loadingIndicator.isHidden = true
    }
    
    @IBAction func refreshButtonClicked() {
        presenter?.getCurrencyIndexPrice()
    }
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getTotalPriceIndex() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCellView.className) as? MainCellView else { return UITableViewCell() }
        guard let presenter = presenter else { return cell }
        cell.timeLabel.text = presenter.getTimePriceIndex(index: indexPath.row)
        cell.valueLabel.text = presenter.getValuePriceIndex(index: indexPath.row)
        cell.longitudeLabel.text = presenter.getLongitudePriceIndex(index: indexPath.row)
        cell.latitudeLabel.text = presenter.getLatitudePriceIndex(index: indexPath.row)
        return cell
    }
}

extension MainView: ChartViewDelegate { }



