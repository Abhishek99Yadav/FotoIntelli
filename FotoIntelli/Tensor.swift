//
//  Tensor.swift
//  FotoIntelli
//
//  Created by Abhishek Yadav on 05/07/24.
//

import Foundation

struct Tensor<T> {
    var shape: [Int]
    var scalars: [T]
    
    init(shape: [Int], scalars: [T]) {
        self.shape = shape
        self.scalars = scalars
    }
}
