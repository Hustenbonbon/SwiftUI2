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
    @State var sheetPokemon: Pokemon?
    
    var columns = [
        GridItem(.adaptive(minimum: 200))
//        GridItem(),
//        GridItem(),
//        GridItem()
    ]
    #if os(tvOS)
    let buttonStyle = CardButtonStyle()
    #else
    let buttonStyle = DefaultButtonStyle()
    #endif
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(pokeFetcher.pokemon) { pokemon in
                    Button(action: {
                        self.sheetPokemon = pokemon
                    }) {
                        URLImage(pokemon.imageURL) { proxy in
                            proxy.image
                                .resizable()                     // Make image resizable
                                .aspectRatio(contentMode: .fit) // Fill the frame
                                .clipped() // Clip overlaping parts
                        }
                        .frame(width: 200, height: 200)
                        .background(Color.white)
                    }
                    .buttonStyle(buttonStyle)
                }
            }
        }
        .padding(50)
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(RadialGradient(gradient: Gradient(colors: [Color.red, Color.blue, Color.gray]), center: .center, startRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/, endRadius: 1000))
        .sheet(item: $sheetPokemon) { pokemon in
            VStack {
                URLImage(URL(string: pokemon.image!)!)
                Text(pokemon.name!).font(.title)
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
        Network.shared.apollo.fetch(query: PokemonsQuery(first: 151)) { result in
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
