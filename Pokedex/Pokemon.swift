//
//  Pkemon.swift
//  Pokedex
//
//  Created by Noroc iOS 1 on 24/07/17.
//  Copyright © 2017 Noroc iOS 1. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _height: String!
    private var _weight: String!
    private var _type: String!
    private var _defence: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionID: Int!
    private var _pokemon_URL: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defence: String {
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var nxtEvolvutionID: Int {
        if _nextEvolutionID == nil {
            _nextEvolutionID = -1
        }
        return _nextEvolutionID
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemon_URL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemons(completed: @escaping DownloadComplete) {

        print(_pokemon_URL)
        Alamofire.request(_pokemon_URL).responseJSON { (response) in
           
//            print(response.result.value)
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                    
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                     print("height ", height)
                }
                
                if let attack = dict["attack"] as? Double {
                    self._attack = "\(attack)"
                    
                }
                
                if let name = dict["name"] as? String {
                    self._name = name.capitalized
                  
                }
                
                if let pkdx_id = dict["pkdx_id"] as? Int {
                    self._pokedexId = pkdx_id
                    
                }
                
                if let defense = dict["defense"] as? Double {
                    self._defence = "\(defense)"
                    
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    var pokeType = ""
                    for type in types {
                        if let name = type["name"] as? String {
                           
                            if pokeType.isEmpty {
                                pokeType = name.capitalized
                            } else {
                                pokeType = "\(pokeType) / \(name.capitalized)"
                            }
                        }
                    }
                    self._type = pokeType
                    
                }
                
                if let evolvutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolvutions.count > 0  {
                        var evolve = evolvutions[0]
                        if var evolveTo = evolve["to"] as? String {
                            if let method = evolve["method"] as? String {
                                if method == "level_up" {
                                    if let level = evolve["level"] as? Double {
                                        evolveTo = "\(evolveTo) LVL \(level)"
                                    }
                                }
                            }
                            self._nextEvolutionTxt = "Next Evolution: \(evolveTo)"
                    }
                    if let resource_uri = evolve["resource_uri"] as? String {
//                        var id = resource_uri.substring(to: (resource_uri.endIndex - 1))
                        
                        let evolvedPoke_URL = "\(BASE_URL)\(resource_uri)"
                        Alamofire.request(evolvedPoke_URL).responseJSON(completionHandler: { (response) in
                            
                            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                                if let NxtPokeId = dict["pkdx_id"] as? Int {
                                    
                                    self._nextEvolutionID = NxtPokeId
                                    print(self._nextEvolutionID)
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    //Wonder what to write here..
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>] {
                    var desc = descriptions[0]
                    
                    if let resource_uri = desc["resource_uri"] as? String {
                        let description_URL = "\(BASE_URL)\(resource_uri)"
                        Alamofire.request(description_URL).responseJSON(completionHandler: { (response) in
                            
                            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                                if let pokeDesc = dict["description"] as? String {
                                    
                                    let newDesc = pokeDesc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                    print(self._description)
                                }
                            }
                            completed()
                        })
                    }
                }
               
            }
          completed()
        }
    }
}
