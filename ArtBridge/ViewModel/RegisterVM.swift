//
//  RegisterVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/09.
//

import Foundation
import Alamofire
import Combine

class RegisterVM: ObservableObject {

    var subscription = Set<AnyCancellable>()
    
    // input
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    @Published var userNameInput: String = ""
    @Published var emailInput: String = ""
    
    // output
    @Published var userNameMessage = ""
    @Published var emailMessage = ""
    @Published var passwordMessage = ""
    @Published var isValid = false
    
    //MARK: - Register User
    func registerUser() {
        print("RegisterVM - registerUser() called")
        if isValid {
            UserApiServie.registerUser(userName: userNameInput, password: passwordInput, email: emailInput)
                .sink { (completion: Subscribers.Completion<AFError>) in
                    print("RegisterVM - registerUser() Completion : \(completion)")
                } receiveValue: { (receivedData: AccountData) in
                    print("chang")
                }.store(in: &subscription)
        } else {
            print("is not Valid")
        }
    }
    
    //MARK: - Name Valid
    private var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $userNameInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Email Valid
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $emailInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return (input.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .regularExpression) != nil )
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Password Valid
    // Password Empty
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $passwordInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    // Password Equal
    private var isPasswordEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($passwordInput, $passwordConfirmInput)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { password, passwordConfirm in
                return password == passwordConfirm
            }
            .eraseToAnyPublisher()
    }
    
    // Pasword Strength
    private var isPasswordShortPbulisher: AnyPublisher<Bool, Never> {
        $passwordInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count < 8
            }
            .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case empty
        case noMatch
        case short
    }
    
    // Password Valid
    private var isPasswordVaildPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, isPasswordEqualPublisher, isPasswordShortPbulisher)
            .map { passwordIsEmpty, passwordAreEqual, passwordIsShort in
                if (passwordIsEmpty) {
                    return .empty
                } else if (!passwordAreEqual) {
                    return .noMatch
                } else if (passwordIsShort) {
                    return .short
                } else {
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - All Check
    private var isAllValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isUserNameValidPublisher, isEmailValidPublisher, isPasswordVaildPublisher)
            .map { userNameIsValid, emailIsValid, passwordIsValid in
                return userNameIsValid && emailIsValid && (passwordIsValid == .valid)
            }
            .eraseToAnyPublisher()
    }

    //MARK: - 초기화 할 때 RegisterVM(자신)의 Publisher를 구독
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("RegisterVM - init() called")
                
        isUserNameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "닉네임이 짧습니다. 3글자 이상"
            }
            .assign(to: \.userNameMessage, on: self)
            .store(in: &cancellables)
        
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "이메일 형식이 올바르지 않습니다. example@mail.com"
            }
            .assign(to: \.emailMessage, on: self)
            .store(in: &cancellables)
        
        isPasswordVaildPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch (passwordCheck) {
                case .empty :
                    return "비밀번호가 입력되지 않았습니다."
                case .noMatch:
                    return "비밀번호가 일치하지 않습니다."
                case .short:
                    return "비밀번호가 짧습니다. 8글자 이상"
                default:
                    return ""
                }
            }
            .assign(to: \.passwordMessage, on: self)
            .store(in: &cancellables)
        
        isAllValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
}
