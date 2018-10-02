//
//  ViewController.swift
//  Pokedex
//
//  Created by Noroc iOS 1 on 24/07/17.
//  Copyright © 2017 Noroc iOS 1. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var searchView: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredpokemons = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchView.delegate = self
        
        searchView.returnKeyType = UIReturnKeyType.done
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
                musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                if let pokeId = row["id"] as? Int, let pokeName = row["identifier"] {
                    let poke = Pokemon(name: pokeName, pokedexId: pokeId)
                    pokemons.append(poke)
                }
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
           
            let poke = getPokemon(id: indexPath.row)
            
            cell.configureCell(poke)
            return cell
         } else {
            
            return UICollectionViewCell()
        }
    }
    
    func getPokemon(id: Int) -> Pokemon {
        if inSearchMode {
            return filteredpokemons[id]
        }
        return pokemons[id]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredpokemons.count
        } else {
        
        return pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "DetailVC", sender: getPokemon(id: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    @IBAction func musicBtnPressed(_ sender: Any) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            (sender as! UIButton).alpha = 0.2
        } else {
            musicPlayer.play()
            (sender as! UIButton).alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            view.endEditing(true)
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredpokemons = pokemons.filter({$0.name.range(of: lower) != nil})
        }
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
}

