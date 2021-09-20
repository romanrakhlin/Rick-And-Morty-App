//
//  CharactersManager.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 13.09.2021.
//

import UIKit

protocol NetworkManagerDelegate {
    func didUpdateData(_ charactersManager: NetworkManager, characters: Characters)
    func didFailWithError(error: Error)
}

struct NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    let cache = NSCache<NSString,UIImage>()
    
    let RickAndMortyAPI = "https://rickandmortyapi.com/api/character"
    
    func fetchCharacters(page: Int) {
        let urlString = "\(RickAndMortyAPI)?page=\(page)"
        performRequest(urlString: urlString)
    }
    
    // for character
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let characters = parseJSON(characterData: safeData) {
                        delegate?.didUpdateData(self, characters: characters)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(characterData: Data) -> Characters? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Characters.self, from: characterData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    // get images
    func getImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(nil)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            } else {
                completed(nil)
                return
            }
        }
        task.resume()
    }
    
    // for episodes
    func getEpisode(from urlString: String, completed: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(nil)
                return
            }
            if let safeData = data {
                if let episode = parseEpisodeJSON(characterData: safeData) {
                    completed(episode.name)
                    return
                }
            }
        }
        task.resume()
    }
    
    func parseEpisodeJSON(characterData: Data) -> Episode? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Episode.self, from: characterData)
            return decodedData
        } catch {
            return nil
        }
    }
}
