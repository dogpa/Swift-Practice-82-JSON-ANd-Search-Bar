//
//  SingerTableViewController.swift
//  Swift Practice # 82 JSON ANd Search Bar
//
//  Created by Dogpa's MBAir M1 on 2021/9/21.
//

import UIKit

class SingerTableViewController: UITableViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingerTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }

    @IBOutlet weak var singerSearchBar: UISearchBar!
    
    var singerDataFromASA = [SingerDetails]()
    func getDetailsFromASA () {
        
        self.singerDataFromASA = []
        self.tableView.reloadData()
        
        let searchIndex = (singerSearchBar.text ?? "")
        let searchAPI = "https://itunes.apple.com/search?term=\(searchIndex)&media=music"
        
        if let urlString = searchAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            if let JSONUrl = URL(string: urlString){
                
                URLSession.shared.dataTask(with: JSONUrl) { data, response, error in
                    //指派data為DATA類別
                    if let date = data {
                        
                        let decoder = JSONDecoder()
                        
                        decoder.dateDecodingStrategy = .iso8601

                        do {
                            let searchResponse = try decoder.decode(SearchResponse.self, from: date)
                            self.singerDataFromASA = searchResponse.results
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }catch{
                            //若無法do或是失敗列印失敗原因
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        singerSearchBar.becomeFirstResponder()

    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //row的數量透過singerDataFromASA透過JSON抓到的網路數量來指派
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return singerDataFromASA.count
    }

    //TableView顯示內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //指派Cell為轉型SingerNameAndPhotoTableViewCell內的"singerDetailsCell"這個Table View
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchInfo", for: indexPath) as! SearchInfoTableViewCell
        //指派item為自定義的 singerDataFromASA[indexPath.row]（取得每一列）
        let item = singerDataFromASA[indexPath.row]
        
        //歌手Label與歌名Label的字串指派為artistName與trackName
        cell.singerNameLabel.text = item.artistName
        cell.songNameLabel.text = item.trackName
        
        //因為照片是URL格式，所以在Table再次執行從網路上抓資料取得照片後再指派給songAlbumImageView
        URLSession.shared.dataTask(with: item.artworkUrl100) { data, response , error in
        if let data = data {
            DispatchQueue.main.async {
                cell.ablumImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        //回傳cell
        return cell
        
    }
    
    

}


//延伸SingerTableViewController功能使其可以代理UISearchBarDelegate
extension SingerTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //執行自定義的 getDetailsFromASA()
        getDetailsFromASA()
        singerSearchBar.resignFirstResponder()
        
        
    }
    
}
