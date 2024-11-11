//
//  TaskModel.swift
//  TODO List
//
//  Created by Enver's Macbook Pro on 11/9/24.
//

import UIKit

// Type codable makes saving and loading data as JSON file.
struct TaskModel: Codable {
    var text: String
    var isCompleted: Bool
}
