//
//  ContentView.swift
//  AssignmentPagination
//
//  Created by I-Store on 16.12.2019.
//  Copyright © 2019 I-Store. All rights reserved.
//

import SwiftUI


struct ArticlesListView: View {
  
  @EnvironmentObject var viewModel: ArticlesListViewModel
  
  var body: some View {
    NavigationView {
      VStack() {
        Picker(selection: $viewModel.selectedThemeIndex, label: Text("Selected theme")) {
          ForEach((0..<viewModel.themes.count), id: \.self) { index in
            Text(self.viewModel.themes[index].query).tag(index)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)
        
        List(viewModel.articles) { article in
          // Cell
          VStack(alignment: .leading) {
            Text(article.title ?? "")
            // Loading
            if self.viewModel.shouldShowLoadingActivity(for: article) {
              Divider()
              Text("Loading...")
            }
          }
          .onAppear {
            self.onItemShowed(article)
          }
        }
      }
      .navigationBarTitle(viewModel.title)
    }
  }
  
}


extension ArticlesListView {
  
  private func onItemShowed<T:Identifiable>(_ item: T) {
    if self.viewModel.articles.isLastItem(item) {
      self.viewModel.loadPage()
    }
  }
  
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let themes = [
      Theme(query: "SwiftUI", from: "2020-01-14"),
      Theme(query: "Objective-C", from: "2020-01-14"),
      Theme(query: "Kotlin", from: "2020-01-14")
    ]
    return ArticlesListView().environmentObject(ArticlesListViewModel(themes: themes))
  }
}
