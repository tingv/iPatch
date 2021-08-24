//
//  PatchingProgressView.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct PatchingProgressView: View {
    var body: some View {
        VStack {
            Text("修补中，这可能需要一点时间...")
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
        }
        .padding()
    }
}
