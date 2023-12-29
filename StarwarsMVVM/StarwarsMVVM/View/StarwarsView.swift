//
//  StarwarsView.swift
//  Starwars
//
//  Created by Dongseok Lee on 12/29/23.
//

import SwiftUI

struct StarwarsView: View {
    @StateObject var viewModel: StarwarsViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.films) { film in
                    Text(film.title + " " + film.director)
                }
                .onDelete(perform: deleteFilms)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addNewFilm) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.task {
            if await viewModel.hasFilms() == false {
                await viewModel.loadFilms()
            }
        }
    }
    
    private func addNewFilm() {
        withAnimation {
            viewModel.addNewFilm()
        }
    }
    
    private func deleteFilms(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteFilms(offsets: offsets)
        }
    }
}
