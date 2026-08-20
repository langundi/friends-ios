//
//  LoadingViewState.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import Foundation

enum LoadingViewState<Result> {
    case loading
    case loaded(Result)
    case empty
}
