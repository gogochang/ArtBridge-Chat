//
//  RegisterVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/09.
//

import Foundation
import Combine

class RegisterVM: ObservableObject {
    
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    var isHidden : Bool = true
    
    //MARK: - Password 값이 서로 일치하는지에 대한 결과를 보내는 Publisher
    lazy var isMatchPasswordInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map({ (password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - 초기화 할 때 RegisterVM(자신)의 Publisher를 구독
    init() {
        print("RegisterVM - init() called")
        self.isMatchPasswordInput.sink { (newValue) in
            self.isHidden = newValue
        }.store(in:&cancellables)
    }
    
}
