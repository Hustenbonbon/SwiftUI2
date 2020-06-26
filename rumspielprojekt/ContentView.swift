//
//  ContentView.swift
//  rumspielprojekt
//
//  Created by Max Tharr on 24.06.20.
//

import SwiftUI
import Combine
import Apollo
import URLImage

struct ContentView: View {
    @ObservedObject var pokeFetcher = PokeFetcher()
    @State var items = ["Bisasam","Schiggy","Glumanda"]
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(alignment: .center) {
                    ForEach(pokeFetcher.pokemon, id: \.number) { pokemon in
                        VStack {
                            URLImage(URL(string: pokemon.image!)!).padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            Text(pokemon.name!).foregroundColor(.black).font(.title3)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .bottomLeading, endPoint: .topTrailing))
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
        Network.shared.apollo.fetch(query: PokemonsQuery(first: 30)) { result in
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
