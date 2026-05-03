//
//  WatchView.swift
//  Pair
//
//  Created by Evan Best on 2026-05-02.
//

import SwiftUI

struct WatchMainView: View {
	let watchVM: WatchViewModel

	var body: some View {
		Text("Watch")
	}
}

#Preview {
	WatchMainView(watchVM: WatchViewModel())
}
