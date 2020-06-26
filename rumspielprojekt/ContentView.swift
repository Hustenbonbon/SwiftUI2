//
//  ContentView.swift
//  rumspielprojekt
//
//  Created by Max Tharr on 24.06.20.
//

import SwiftUI
import Apollo
import URLImage

struct ContentView: View {
    @ObservedObject var pokeFetcher = PokeFetcher()
    @State var sheetPokemon: PokemonsQuery.Data.Pokemon?
    
    var body: some View {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 100, alignment: .top)]) {
                ForEach(pokeFetcher.pokemon) { pokemon in
                        Button(action: {
                            self.sheetPokemon = pokemon
                        }, label: {
                            VStack {
                                URLImage(URL(string: pokemon.image!)!) { proxy in
                                    proxy.image
                                        .resizable()                     // Make image resizable
                                        .aspectRatio(contentMode: .fit) // Fill the frame
                                        .clipped()                       // Clip overlaping parts
                                }
                                .frame(width: 150, height: 150.0)
                                .background(Color.white)
                                Text(pokemon.name ?? "Unknown")
                            }
                        }).buttonStyle(CardButtonStyle())
                    }
                }
            .sheet(item: $sheetPokemon) { pokemon in
                VStack {
                    URLImage(URL(string: pokemon.image!)!)
                    Text(pokemon.name!)
                    Text(pokemon.number!).font(.caption)
                    Text(pokemon.classification!).font(.caption)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
            }
    }
}

struct Tile: View, Identifiable {
    let id = UUID()
    //let colors: [Color] = [.red,.blue,.gray,.green,.yellow,.orange,.pink]
    @State var color: Color
    
    var body: some View {
        color
            .cornerRadius(25)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class PokeFetcher: ObservableObject {
    @Published var pokemon: [PokemonsQuery.Data.Pokemon] = []

    init() {
        Network.shared.apollo.fetch(query: PokemonsQuery(first: 20)) { result in
            switch result {
                case .success(let graphQLResult):
                    if let pokemon = graphQLResult.data?.pokemons {
                        self.pokemon = pokemon.compactMap { $0 }
                    }
                case .failure(let error):
                    print("Failure! Error: \(error)")
            }
        }
    }

}
