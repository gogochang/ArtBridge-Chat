//
//  RegisterVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/09.
//

import Foundation
import Alamofire
import Combine
import Firebase

class RegisterVM: ObservableObject {
    let service = UserService()
    let db = Firestore.firestore()

    var subscription = Set<AnyCancellable>()

    //회원가입 완료 이벤트
    var registrationSuccess = PassthroughSubject<(), Never>()
    
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
    
    //회원가입 완료 여부 체크
    @Published var didRegisterUser = false
    //MARK: - 초기화 할 때 RegisterVM(자신)의 Publisher를 구독
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("RegisterVM - init() called")
                
        isUserNameValidPublisher
            .receive(on: RunLoop.main)
            .map { nameCheck in
                switch (nameCheck) {
                case .short:
                    return "닉네임이 짧습니다. 3글자 이상"
                case .duplicate:
                    return "이미 존재하는 닉네임입니다."
                default:
                    return ""
                }
            }
            .assign(to: \.userNameMessage, on: self)
            .store(in: &cancellables)
        
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { mailCheck in
                switch (mailCheck) {
                case .format:
                    return "이메일 형식이 올바르지 않습니다. example@mail.com"
                case .duplicate:
                    return "이미 존재하는 이메일입니다."
                default:
                    return ""
                }
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
    
    //MARK: - Register User
    func registerUser() {
        print("RegisterVM - registerUser() called")
        if isValid {
            service.register(email: emailInput,
                             password: passwordInput,
                             username: userNameInput) { success in
                if success {
                    print("RegisterVM - registerUser() success")
                    self.didRegisterUser = true
                    return
                } else {
                    print("RegisterVM - registerUser() Fail")
                }
            }
        } else {
            print("RegisterVM - registerUser() Invalid")
        }
        print("RegisterVM - registerUser() Failed")
    }
    
    //MARK: - Name Valid
    enum NameCheck {
        case valid
        case duplicate
        case short
    }

    //Name Strength
    private var isNameShortPublisher: AnyPublisher<Bool, Never> {
        $userNameInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count < 3
            }
            .eraseToAnyPublisher()
    }
    
    // Name Duplicate func
    private func checkDuplicateName(name: String) -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { promise in
            self.db.collection("users").whereField("username", isEqualTo: name).getDocuments { snapshot, _ in
                if snapshot?.count ?? 0 > 0 {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Name Duplicate
    private var isNameDuplicatePublisher: AnyPublisher<Bool, Never> {
        $userNameInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { input -> AnyPublisher<Bool, Never> in
                return self.checkDuplicateName(name: input)
            }
            .eraseToAnyPublisher()
    }
    
    // Name Valid
    private var isUserNameValidPublisher: AnyPublisher<NameCheck, Never> {
        Publishers.CombineLatest(isNameShortPublisher, isNameDuplicatePublisher)
            .map { nameIsShort, nameIsDuplicate in
                if(nameIsShort) {
                    return .short
                } else if (nameIsDuplicate) {
                    return .duplicate
                } else {
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Email Valid
    enum EmailCheck {
        case valid
        case duplicate
        case format
    }
    
    // Email format
    private var isEmailFormatPublisher: AnyPublisher<Bool, Never> {
        $emailInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return (input.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .regularExpression) != nil )
            }
            .eraseToAnyPublisher()
    }
    
    // Email Duplicate func
    private func checkDuplicateEmail(email: String) -> AnyPublisher<Bool,Never> {
        return Future<Bool, Never> { promise in
            self.db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, _ in
                if snapshot?.count ?? 0 > 0 {
                    print("changgyu1 \(email)")
                    promise(.success(true))
                } else {
                    print("changgyu2 \(email)")
                    promise(.success(false))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Email Duplicate
    private var isEmailDuplicatePublisher: AnyPublisher<Bool, Never> {
        $emailInput
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { input -> AnyPublisher<Bool, Never> in
                return self.checkDuplicateEmail(email: input)
            }
            .eraseToAnyPublisher()
    }
    
    // Email Valid
    private var isEmailValidPublisher: AnyPublisher<EmailCheck, Never> {
        Publishers.CombineLatest(isEmailFormatPublisher, isEmailDuplicatePublisher)
            .map { emailIsFormat, emailIsDuplicate in
                if(!emailIsFormat) {
                    return .format
                } else if (emailIsDuplicate) {
                    return .duplicate
                } else {
                    return .valid
                }
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
                if (userNameIsValid == .valid), (emailIsValid == .valid), (passwordIsValid == .valid) {
                    return true
                } else {
                    return false
                }
//                return true
            }
            .eraseToAnyPublisher()
    }


}
