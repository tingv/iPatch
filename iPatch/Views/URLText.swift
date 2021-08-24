//
//  URLText.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct URLText: View {
    let url: URL?
    @State private var popoverPresented = false
    
    var body: some View {
        Text(url?.lastPathComponent ?? "选择一个文件")
            .onTapGesture { popoverPresented = true }
            .popover(isPresented: $popoverPresented) {
                Text(url?.path ?? "")
                    .padding()
            }
    }
}
