//
//  AP+Extensions.swift
//  rumspielprojekt
//
//  Created by Max Tharr on 26.06.20.
//

import Foundation

typealias Pokemon = PokemonsQuery.Data.Pokemon

extension Pokemon: Identifiable {}

extension Pokemon {
    var imageURL: URL {
        URL(string: image!)!
    }
}
