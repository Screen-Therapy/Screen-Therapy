//
//  FamilyActivityModel.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import FamilyControls
import Combine

class FamilyActivityModel: ObservableObject {
    @Published var selectionToDiscourage = FamilyActivitySelection()
}
