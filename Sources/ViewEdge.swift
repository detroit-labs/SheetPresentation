//
//  ViewEdge.swift
//  SheetPresentation
//
//  Created by Jon Shier on 6/29/20.
//  Copyright © 2020 Detroit Labs. All rights reserved.
//

public enum ViewEdge: Equatable {
    case top
    case leading
    case trailing
    case bottom
}

extension Array where Element == ViewEdge {

    public static let all: [ViewEdge] = [.top, .leading, .trailing, .bottom]

    public static let bottomEdges: [ViewEdge] = [.leading, .trailing, .bottom]

}
