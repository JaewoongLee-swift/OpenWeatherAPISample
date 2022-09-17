//
//  ViewController.swift
//  WeatherAPISample
//
//  Created by 이재웅 on 2022/09/17.
//

import UIKit

class ViewController: UIViewController {    
    let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(APIKey.key)&numOfRows=288&pageNo=1&dataType=JSON&base_date=\(TodayData.today)&base_time=\(TodayData.nowTime)&nx=55&ny=127"
    
    var item: [WeatherItem]?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        print("오늘 : \(TodayData.today)")
        print("기준시간 : \(TodayData.nowTime)")
        print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
        
        request(self.url, "GET") { [weak self] success, data in
            guard let self = self else { return }
            guard let data = data as? Response else {
                print("Error: API 호출 실패")
                return
            }
            
            let body = data.body.items
            print(body)
            
            var filteredItem = [WeatherItem]()
            body.item.forEach { itemData in
                if itemData.category.contains("TMP") || itemData.category.contains("SKY") || itemData.category.contains("POP") || itemData.category.contains("PTY")  {
                    filteredItem.append(itemData)
                }
            }
            
            self.item = filteredItem
            print("item 개수: \(self.item?.count ?? 0)")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let weatherData = item?[indexPath.row]

        cell.textLabel?.text = "\(weatherData?.timeValue ?? "시간출력오류"), \(weatherData?.categoryName ?? "기상카테고리 출력오류") : \(weatherData?.categoryValue ?? "기상값 출력오류")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 1
    }
}

extension ViewController {
    func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
