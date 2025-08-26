//
//  CustomeRefreshPerformer.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 22.08.2025.
//

import Foundation
import SwiftUI

class CustomeRefreshPerformer: ObservableObject {
    
    func perform(_ action: RefreshAction?) async {
        print ("executing refresh action from custome refresh performer class")
        if let action {
            await action()
        }
    }
}
