//
//  ContentView.swift
//  IconHarness
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Icon()
            .frameIcon()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
