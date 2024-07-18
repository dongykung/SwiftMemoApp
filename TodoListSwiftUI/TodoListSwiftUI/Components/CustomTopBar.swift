//
//  CustomTopBar.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/09.
//

import SwiftUI

struct CustomTopBar: View {
    let isVisibleBackBtn: Bool
    let isVisibleActionBtn: Bool
    let backBtnAction: () -> Void
    let actionBtnAction: () -> Void
    let actionBtnType: CustomTopBarType
    
    init(
        isVisibleBackBtn: Bool = true,
        isVisibleActionBtn: Bool = true,
        backBtnAction: @escaping () -> Void = {},
        actionBtnAction: @escaping () -> Void = {},
        actionBtnType: CustomTopBarType = .complete
    ) {
        self.isVisibleBackBtn = isVisibleBackBtn
        self.isVisibleActionBtn = isVisibleActionBtn
        self.backBtnAction = backBtnAction
        self.actionBtnAction = actionBtnAction
        self.actionBtnType = actionBtnType
    }
    var body: some View {
        HStack {
            if isVisibleBackBtn {
                Button {
                    backBtnAction()
                } label: {
                    Image("leftArrow")
                }
                Spacer()
                if isVisibleActionBtn {
                    Button{
                        actionBtnAction()
                    } label: {
                        Text(actionBtnType.rawValue)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

#Preview {
    CustomTopBar()
}
