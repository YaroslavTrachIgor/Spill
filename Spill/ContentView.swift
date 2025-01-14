//
//  ContentView.swift
//  Spill
//
//  Created by User on 2025-01-10.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import FirebaseCore
import CryptoKit


final class SignInViewModel: ObservableObject {
    
    func signIn(email: String, password: String) async throws {
        try await AuthenticationHelper.shared.signInUser(email: email, password: password)
    }
    
    func forgotPassword(email: String) async throws {
        try await AuthenticationHelper.shared.resetPassword(email: email)
    }
    
    func signInGoogle(on viewController: UIViewController) async throws {
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let tokens = GoogleSignResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationHelper.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        try await AuthenticationHelper.shared.signInWithApple()
    }
    
    func signInAnonymusly() async throws {
        try await AuthenticationHelper.shared.signInAnonymously()
    }
    
    func createUser(email: String, password: String) async throws {
        try await AuthenticationHelper.shared.createUser(email: email, password: password)
    }
}





struct EmailSignInView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = EmailSignInViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.gilroyMedium16)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.gilroyMedium16)
            
            Button(action: {
                Task {
                    viewModel.signInWithEmail
                }
            }, label: {
                Text("Sign In")
                    .font(.gilroyMedium16)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.baseBackgroundColor)
                    .cornerRadius(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.3)
                    }
            })
        }
        .padding()
        .background(Color.baseBackgroundColor)
    }
}

class EmailSignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    
    func signInWithEmail() async throws {
        try await AuthenticationHelper.shared.signInUser(email: email, password: password)
    }
}

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    @State private var presentCreateProfileView = false
    @State private var showEmailSignIn = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                Image("SpillIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Spacer()
                
                // Sign in with Apple
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            presentCreateProfileView.toggle()
                        } catch {
                            print("error signing in with Apple: \(error.localizedDescription)")
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .foregroundColor(.white)
                        Text("Continue with Apple")
                            .font(.gilroyMedium16)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.baseAppleBackgroundColor)
                    .cornerRadius(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.3)
                    }
                })
                
                // Sign in with Google
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInGoogle(on: UIApplication.topViewController()!)
                            presentCreateProfileView.toggle()
                        } catch {
                            print("error signing in with Google: \(error.localizedDescription)")
                        }
                    }
                }, label: {
                    HStack {
                        Image("google_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Continue with Google")
                            .font(.gilroyMedium16)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.baseGoogleBackgroundColor)
                    .cornerRadius(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.3)
                    }
                })
                
                // Sign in with Email
                Button(action: { showEmailSignIn = true }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                        Text("Sign in with Email")
                            .font(.gilroyMedium16)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.3)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color.baseBackgroundColor)
            .sheet(isPresented: $showEmailSignIn) {
                EmailSignInView()
            }
            .navigationDestination(isPresented: $presentCreateProfileView) {
                CreateProfileView()
            }
            .onTapGesture {
                presentCreateProfileView.toggle()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        SignInView()
    }
}

#Preview {
    ContentView()
}


























//MARK: - Auth Provider Options
public enum AuthProviderOption: String, Codable {
    case google = "google.com"
    case apple = "apple.com"
    case email = "password"
    case mock = "mock"
}


//MARK: - Auth Errors
private enum AuthError: LocalizedError {
    case noResponse
    case userNotFound
    case verificationCodeNotFound
    case verificationIDNotFound
    
    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "Bad response."
        case .userNotFound:
            return "Current user not found."
        case .verificationCodeNotFound:
            return "Verification code not found."
        case .verificationIDNotFound:
            return "Verification ID not found."
        }
    }
}





final class AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: URL?
    
    init(uid: String, email: String?, photoURL: URL?) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
    }
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
    }
}

struct GoogleSignResultModel {
    let idToken: String
    let accessToken: String
}



//MARK: - Constants
final class AuthenticationConstants {
    static var JWT = ""
}


//MARK: - Main Helper
final class AuthenticationHelper {
    
    static let shared = AuthenticationHelper()
    
    private let signInWithAppleHelper = SignInWithAppleHelper()
    
    private init() {}
    
    @discardableResult
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResultModel = try await Auth.auth().createUser(withEmail: email, password: password); getIDToken()
        return AuthDataResultModel(user: authDataResultModel.user)
    }
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authDataResultModel = try await Auth.auth().signInAnonymously(); getIDToken()
        return AuthDataResultModel(user: authDataResultModel.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResultModel = try await Auth.auth().signIn(withEmail: email, password: password); getIDToken()
        return AuthDataResultModel(user: authDataResultModel.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    func getIDToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil { return }
            guard let JWT = idToken else { return }
            AuthenticationConstants.JWT = JWT
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}


//MARK: - Google Sign In
extension AuthenticationHelper {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(with: credential)
    }
    
    func signIn(with credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential); getIDToken()
        return AuthDataResultModel(user: authDataResult.user)
    }
}


//MARK: - Apple Sign In
extension AuthenticationHelper {
    
    @MainActor
    @discardableResult
    func signInWithApple() async throws -> AuthDataResultModel {
        let helper = SignInWithAppleHelper()
        for try await appleResponse in helper.startSignInWithAppleFlow() {
            let credential = OAuthProvider.credential(
                withProviderID: AuthProviderOption.apple.rawValue,
                idToken: appleResponse.token,
                rawNonce: appleResponse.nonce
            )
            return try await signIn(with: credential)
        }
        throw AuthError.noResponse
    }
}


//MARK: - Error Descriptions
extension AuthenticationHelper {
    func errorDescription(for localizedDescription: String?) -> String {
        switch localizedDescription {
        case "The supplied auth credential is malformed or has expired.":
            return "The password is incorrect. \n Please, try again."
        default:
            return "Unknown Authentication Error"
        }
    }
}






struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let nickName: String?

    var fullName: String? {
        if let firstName, let lastName {
            return firstName + " " + lastName
        } else if let firstName {
            return firstName
        } else if let lastName {
            return lastName
        }
        return nil
    }
    
    var displayName: String? {
        fullName ?? nickName
    }

    init?(authorization: ASAuthorization, nonce: String) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let token = String(data: appleIDToken, encoding: .utf8)
        else {
            return nil
        }

        self.token = token
        self.nonce = nonce
        self.email = appleIDCredential.email
        self.firstName = appleIDCredential.fullName?.givenName
        self.lastName = appleIDCredential.fullName?.familyName
        self.nickName = appleIDCredential.fullName?.nickname
    }
}

final class SignInWithAppleHelper: NSObject {
        
    private var completionHandler: ((Result<SignInWithAppleResult, Error>) -> Void)? = nil
    private var currentNonce: String? = nil
    
    /// Start Sign In With Apple and present OS modal.
    ///
    /// - Parameter viewController: ViewController to present OS modal on. If nil, function will attempt to find the top-most ViewController. Throws an error if no ViewController is found.
    @MainActor
    func startSignInWithAppleFlow(viewController: UIViewController? = nil) -> AsyncThrowingStream<SignInWithAppleResult, Error> {
        AsyncThrowingStream { continuation in
            startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInWithAppleResult):
                    continuation.yield(signInWithAppleResult)
                    continuation.finish()
                    return
                case .failure(let error):
                    continuation.finish(throwing: error)
                    return
                }
            }
        }
    }
    
    @MainActor
    private func startSignInWithAppleFlow(viewController: UIViewController? = nil, completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void) {
        guard let topVC = viewController ?? UIApplication.topViewController() else {
            completion(.failure(SignInWithAppleError.noViewController))
            return
        }

        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        showOSPrompt(nonce: nonce, on: topVC)
    }
    
}

// MARK: PRIVATE
private extension SignInWithAppleHelper {
        
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func showOSPrompt(nonce: String, on viewController: UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = viewController

        authorizationController.performRequests()
    }
    
    private enum SignInWithAppleError: LocalizedError {
        case noViewController
        case invalidCredential
        case badResponse
        case unableToFindNonce
        
        var errorDescription: String? {
            switch self {
            case .noViewController:
                return "Could not find top view controller."
            case .invalidCredential:
                return "Invalid sign in credential."
            case .badResponse:
                return "Apple Sign In had a bad response."
            case .unableToFindNonce:
                return "Apple Sign In token expired."
            }
        }
    }
    
}

extension SignInWithAppleHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        do {
            guard let currentNonce else {
                throw SignInWithAppleError.unableToFindNonce
            }
            
            guard let result = SignInWithAppleResult(authorization: authorization, nonce: currentNonce) else {
                throw SignInWithAppleError.badResponse
            }
            
            completionHandler?(.success(result))
        } catch {
            completionHandler?(.failure(error))
            return
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
        return
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension UIApplication {
    
    //MARK: Static
    static private func rootViewController() -> UIViewController? {
        var rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?
                .rootViewController
        } else {
            rootVC = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }?
                .rootViewController
        }
        
        return rootVC ?? UIApplication.shared.keyWindow?.rootViewController
    }
    
    @MainActor static func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? rootViewController()
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


