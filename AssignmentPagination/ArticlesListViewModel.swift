//
//  ArticlesListViewModel.swift
//  AssignmentPagination
//
//  Created by I-Store on 16.12.2019.
//  Copyright © 2019 I-Store. All rights reserved.
//

import Foundation


struct Theme: Identifiable, Equatable {
  var id = UUID()
  var query: String
  var from: String
}


final class ArticlesListViewModel: ObservableObject {
  
  @Published private(set) var articles = [Article]()
  @Published private(set) var themes: [Theme]
  
  @Published var selectedThemeIndex: Int = 0 {
    didSet {
      articles = []
      pageIndex = 1
      loadPage()
    }
  }
  
  @Published var pageIndex: Int = 1
  @Published var isNewPageLoading: Bool = false
  @Published var error: Error?
  
  var title: String {
    guard let selectedTheme = selectedTheme else { return "News" }
    return "\(selectedTheme.query) News"
  }
  
  var selectedTheme: Theme? {
    guard selectedThemeIndex >= 0 && selectedThemeIndex < themes.count else { return nil }
    return themes[selectedThemeIndex]
  }
  
  // MARK: -
  
  init(themes: [Theme]) {
    self.themes = themes
    loadPage()
  }
  
  func shouldShowLoadingActivity(for article: Article) -> Bool {
    return isNewPageLoading && articles.isLastItem(article)
  }
  
  func loadPage() {
    loadPage(for: selectedTheme)
  }
  
  func loadPage(for theme: Theme?) {
    guard let theme = theme, isNewPageLoading == false else { return }
    
    isNewPageLoading = true
    
    ArticlesAPI.everythingGet(
      q: theme.query,
      from: theme.from,
      sortBy: "publishedAt",
      apiKey: "5eaaa19bb26342f3a3f4c75cbe8e0021",
      page: pageIndex,
      completion: { list, error in
        if let error = error {
          self.error = error
        }
        else {
          self.articles.append(contentsOf: list?.articles ?? [])
          self.pageIndex += 1
        }
        
        self.isNewPageLoading = false
      })
  }
  
}
