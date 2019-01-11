//
//  HistoryViewController.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/11.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var historyPhotos: HistoryPhotos = HistoryPhotos.find()
    
    var searchDate: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        loadData()
        
        // MARK: - Notification Center Config
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.historyUpdated, object: nil)
    }
    
    @objc func loadData() {
        self.historyPhotos = HistoryPhotos.find()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.historyPhotos.photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identity, for: indexPath) as! HistoryCell

        cell.updateCell(photo: self.historyPhotos.photos[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = self.historyPhotos.photos[indexPath.row]
        performSegue(withIdentifier: "HistoryDetailSegue", sender: photo)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HistoryDetailSegue" {
            let destination = segue.destination as! HistoryDetailViewController
            destination.historyPhoto = sender as? Photo
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let searchForm = UIAlertController(title: "Search", message: "Please enter the date", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            searchForm.dismiss(animated: true, completion: nil)
        }
        
        searchForm.addAction(cancelAction)
        
        let searchAction: UIAlertAction = UIAlertAction(title: "Search", style: .default) { action -> Void in
            if let date = self.searchDate?.text {
                Photo.fetchPhotoInfo(date: date, callback: { (photo) in
                    if let photo = photo {
                        DispatchQueue.main.sync {
                            self.performSegue(withIdentifier: "HistoryDetailSegue", sender: photo)
                            self.storeData(photo: photo)
                        }
                    }
                })
            }
        }
        
        searchForm.addAction(searchAction)
        
        searchForm.addTextField { textField -> Void in
            self.searchDate = textField
            self.searchDate!.addTarget(self, action: #selector(self.dateEditing), for: .editingDidBegin)
        }
        
        self.present(searchForm, animated: true, completion: nil)
    }
    
    @objc func dateEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy-MM-dd";
        self.searchDate!.text = dateFormatter.string(from: sender.date)
    }
    
    func storeData(photo: Photo) {
        if historyPhotos.photos.contains(where: { (historyPhoto) -> Bool in
            return photo.date == historyPhoto.date
        }) {
            return
        }
        
        historyPhotos.photos.insert(photo, at: 0)
        historyPhotos.store()
    }
}
