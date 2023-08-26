//
//  LoginView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var loggedInUser = LoggedInUserModel()
    @ObservedObject var loginVM = LoginViewModel()
    @State private var nextView: IdentifiableView? = nil
    @FocusState private var isFocused: FocusedField?
    @State private var showingAlert = false
    @State var data: UserModelEntity?
    
    enum FocusedField{
        case email, password
        
    }
    
   
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                
                LogoShapeView(logoTypeName: "home-logo")
                
                
                Text("Welcome Back")
                    .font(.title)
//                    .padding(.top, 10)
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
                        print(data?.name ?? "")
                        
                        if data == nil || data?.email == nil || data?.name == nil{
                            self.presentationMode.wrappedValue.dismiss()
                        }else{
                            print("User data set for Env Obj")
                            loggedInUser.email = data?.email
                            loggedInUser.name = data?.name
                            loggedInUser.height = data?.height
                            loggedInUser.weight = data?.weight
                            loggedInUser.userImage = data?.uiImage
                        }
                        
                        print("successfull login \(data?.email ?? "")")
                        self.nextView = IdentifiableView(view: AnyView(ContentView()))
                    }catch LoginError.invalidCredentials{
                        showingAlert.toggle()
                        print("Invalid Credentials")
                        
                    }catch LoginError.invalidUser{
                        print("Invalid user")
                        showingAlert.toggle()
                        
                    }catch{
                        print("Something went wrong \(error.localizedDescription)")
                        showingAlert.toggle()
                        
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
                }.padding(.top, 10)
                
                
                Spacer(minLength: 50)
                
            }
            .environmentObject(loggedInUser)
            .alert(isPresented: $showingAlert) { () -> Alert in
                Alert(title: Text("Invalid User Details"), message: Text("Please re-try with correct user details"))
            }
            
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button{
                        isFocused = nil
                    }label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                }
            }
            .background(LinearGradient(colors: [CustomColors.backgroundGray, CustomColors.gradientLower], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        
    }
            

}
    
    

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedInUser: LoggedInUserModel(email: "bg15407@gmail.com", name: "Gayan Kalinga", height: 160, weight: 62, image: UIImage(imageLiteralResourceName: "profile picture")), data: UserModelEntity())
    }
}
