//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Noroc iOS 1 on 26/07/17.
//  Copyright © 2017 Noroc iOS 1. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var nextEvolveLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var imgBeforeEvolve: UIImageView!
    @IBOutlet weak var imgAfterEvolve: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemon.downloadPokemons {
            print("Arrived To VC")
            self.updateUI()
        }
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        nameLabel.text = pokemon.name
        descLbl.text = pokemon.description
        typeLabel.text = pokemon.type
        pokedexIDLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        baseAttackLbl.text = pokemon.attack
        defenceLbl.text = pokemon.defence
        
        if pokemon.nextEvolutionTxt.isEmpty {
            nextEvolveLbl.text = "No Further Evolution"
            arrow.isHidden = true
            imgAfterEvolve.isHidden = true

        } else  {
            nextEvolveLbl.text = pokemon.nextEvolutionTxt
            imgBeforeEvolve.image = UIImage(named: "\(pokemon.pokedexId)")
            imgAfterEvolve.image = UIImage(named: "\(pokemon.nxtEvolvutionID)")
        }
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
    }
    
}
