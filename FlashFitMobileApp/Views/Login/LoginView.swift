//
//  LoginView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var loggedInUser: LoggedInUserModel
    @ObservedObject var loginVM = LoginViewModel()
    @State private var nextView: IdentifiableView? = nil
    @FocusState private var isFocused: FocusedField?
    @State private var showingAlert = false
    @State var data: UserModel
    
    enum FocusedField{
        case email, password
        
    }
    
   
    
    var body: some View {
        NavigationStack{
            VStack {
                
                LogoShapeView()
                
                
                Text("Welcome Back")
                    .font(.headline)
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                
                
                VStack {
                    
                    EntryField(bindingField: $loginVM.email, placeholder: "Email", promptText: "", isSecure: false)
                        .focused($isFocused, equals: .email)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "person", colorList: [.cyan, .green]))
                        .padding(.bottom)
                    
                    EntryField(bindingField: $loginVM.password, placeholder: "Password", promptText: "", isSecure: true)
                        .focused($isFocused, equals: .password)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "key.horizontal", colorList: [.cyan, .green]))
                        .padding(.bottom)
                    
                }
                .padding(.bottom, 50)
                .padding(25)
                
                
                PrimaryActionButton(actionName: "Login", icon: "chevron.forward", disabled: false){
                    print("Login Clicked")
                    do{
                        data = try loginVM.login(email: loginVM.email, password: loginVM.password, moc: moc)

                        
                        print("successfull login")
                        self.nextView = IdentifiableView(view: AnyView(ContentView()))
                    }catch LoginError.invalidCredentials{
                        showingAlert.toggle()
                        print("Invalid Credentials")
                    }catch LoginError.invalidUser{
                        showingAlert.toggle()
                        print("Invalid user")
                    }catch{
                        showingAlert.toggle()
                        print("Something went wrong")
                    }
                    
                    
                }.fullScreenCover(item: self.$nextView, onDismiss: { nextView = nil}) { view in
                    view.view
                }
                
                
                HStack{
                    Text("Do not have an Account ? ")
                    Button("Register..."){
                        self.nextView = IdentifiableView(view: AnyView(RegistrationView()))
                    }
                    .fullScreenCover(item: self.$nextView, onDismiss: { nextView = nil}) { view in
                        view.view
                        
                        
                    }
                }
                
                Spacer(minLength: 50)
                
            }
            .environmentObject(LoggedInUserModel(
                email: data.email,
                name: data.name
                                        ))
            .alert(isPresented: $showingAlert) { () -> Alert in
                Alert(title: Text("Invalid User Details"), message: Text("Please re-tr with correct user details"))
            }
            
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Dismiss") {
                        isFocused = nil
                    }
                    
                }
            }
            .background(LinearGradient(colors: [CustomColors.backgroundGray, CustomColors.gradientLower], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        
    }
            

}
    
    

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedInUser: LoggedInUserModel(email: "bg15407@gmail.com", name: "Gayan Kalinga"), data: UserModel(email: "bg15407@gmail.com", name: "Gayan Kalinga", passwordSalt: "", passwordHash: "", genderType: GenderTypeEnum.Male, weightInKilos: 62, heightInCentiMeter: 165, bodyMassIndex: 20, healthStatus: HealthStatusEnum.Normalweight, createdDate: Date.now))
    }
}
