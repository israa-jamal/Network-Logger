//
//  ViewController.swift
//  Example
//
//  Created by Esraa Gamal on 30/04/2022.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {

    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let networkClient = NetworkClient.shared
    let cellIdentifier = "RecordTableViewCell"
    
    var count : Int = 0 {
        didSet {
            totalCountLabel.text = "Total Network Call: \(count)"
        }
    }
    
    var records : [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count = 0
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()
    }

    //MARK:- Actions
    
    @IBAction func getButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://httpbin.org/get") else { return }
        networkClient.get(url) { [weak self] _ in
            self?.updateDataSource()
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://httpbin.org/post") else { return }
        networkClient.post(url) { [weak self] _ in
            self?.updateDataSource()
        }
    }
    
    @IBAction func putButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://httpbin.org/put") else { return }
        networkClient.put(url) { [weak self] _ in
            self?.updateDataSource()
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://httpbin.org/delete") else { return }
        networkClient.delete(url) { [weak self] _ in
            self?.updateDataSource()
        }
    }
    
    //MARK: Helpers
    
    func updateDataSource() {
        self.records = networkClient.allNetworkRequests()
        self.count = records.count
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: records.count - 1, section: 0), at: .top, animated: true)
    }
}

//MARK:- TableView

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecordTableViewCell
        cell.configureCellWith(records[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
