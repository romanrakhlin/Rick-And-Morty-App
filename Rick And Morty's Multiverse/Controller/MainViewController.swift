//
//  MainViewController.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 13.09.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var networkManager = NetworkManager()
    var listOfCharacters: [Character] = []
    var currentPage = 1
    var isLoading = false
    let refreshControl = UIRefreshControl() // for pull up to refresh
    var activityIndicator = UIActivityIndicatorView(style: .large) // for indicator
    
    var preparedCharacters: [PreparedCharecter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegates
        tableView.dataSource = self
        tableView.delegate = self
        networkManager.delegate = self
        
        // registrating custom cells
        let nib1 = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "customCell")
        
        let nib2 = UINib(nibName: "LoadingTableViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "loadingCell")
        
        // setting up spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = (UIColor (white: 0.3, alpha: 0.8))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        
        // get data from Rick And Morty API
        getData(page: currentPage, centerIndicate: false)
    }
    
    func getData(page: Int, centerIndicate: Bool) {
        let dispatchGroup = DispatchGroup()
        
        // start spinner if need to
        if centerIndicate == true {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
        
        // fetching the data
        dispatchGroup.enter()
        networkManager.fetchCharacters(page: page)
        
        // make a delay for 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dispatchGroup.leave() // then leaving
            
            // go through listOfCharacters
            for character in self.listOfCharacters {
                // add new character to preparedCharacters array
                self.preparedCharacters.append(
                    PreparedCharecter(
                        name: character.name,
                        image: nil, // set to nil for now
                        status: character.status,
                        location: character.location.localName,
                        episode: nil // set to nil for now too
                    )
                )
                
                // cause image and episode are need to load independantly
                // we will get them separetly
                let index = self.preparedCharacters.count - 1
                let lastEpisodeIndex = character.episode.count - 1
                let lastEpisode = character.episode[lastEpisodeIndex]
                self.networkManager.getImage(from: character.image) { image in
                    self.preparedCharacters[index].image = image
                }
                Thread.sleep(forTimeInterval: 0.01)
                self.networkManager.getEpisode(from: lastEpisode) { episode in
                    self.preparedCharacters[index].episode = episode
                }
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            // and updating all data + view
            dispatchGroup.notify(queue: DispatchQueue.main) {
                print(self.preparedCharacters.count)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                print("NEW CHARACTERS LOADED")
            }
        }
    }
    
    // method for reloading content on the screen button refresh
    @IBAction func reloadButtonPressed(_ sender: UIBarButtonItem) {
        listOfCharacters = []
        preparedCharacters = []
        getData(page: 1, centerIndicate: true)
        refreshControl.endRefreshing()
    }
    
    // mrthod for loading more data for infinite scroll
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(1)
                self.currentPage += 1
                self.getData(page: self.currentPage, centerIndicate: false)
                self.isLoading = false
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return preparedCharacters.count
        } else if section == 1 { // for last cell with activity indicator
            return 1
        } else {
            return 0
        }
    }
    
    // icluding cell with activity indicator there are two sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // setting up cells in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell

            cell.portretImage.image = preparedCharacters[indexPath.row].image
            cell.nameLabel.text = preparedCharacters[indexPath.row].name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTableViewCell
            
            cell.loadingIndicator.startAnimating()
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    // change UI in DetailViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
       
        detailVC.image = preparedCharacters[indexPath.row].image
        detailVC.name = preparedCharacters[indexPath.row].name
        detailVC.status = preparedCharacters[indexPath.row].status
        detailVC.location = preparedCharacters[indexPath.row].location
        detailVC.episode = preparedCharacters[indexPath.row].episode
        
        // go to DetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadMoreData()
        }
    }
}

// MARK: - CharactersManagerDelegate

extension MainViewController: NetworkManagerDelegate {
    
    // when we got data we need to update listOfCharacters (add new characters to it)
    func didUpdateData(_ charactersManager: NetworkManager, characters: Characters) {
        listOfCharacters = characters.results
    }
    
    // if any error were catched then displaying alert
    func didFailWithError(error: Error) {
        listOfCharacters = []
    }
}
