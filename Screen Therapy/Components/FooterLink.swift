//
//  FooterLink.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import SwiftUI

struct FooterLink: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
                .underline()
        }
    }
}

struct FooterLink_Previews: PreviewProvider {
    static var previews: some View {
        FooterLink(title: "Privacy Policy", action: {})
    }
}
