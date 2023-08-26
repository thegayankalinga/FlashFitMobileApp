//
//  LogoShapeView.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-13.
//

import SwiftUI

struct LogoShapeView: View {
    
    var heightLimiter: CGFloat = 0.7
    var logoTypeName: String
    
    var body: some View {
        
                GeometryReader { geometry in
                    VStack(alignment: .leading){
                        ZStack{
                            
                            Rectangle()
                            
                                .foregroundColor(CustomColors.primaryColor)
                            
                                .cornerRadius(radius: 2000, corners: [.bottomLeft, .bottomRight])
                            
                                .frame(width: geometry.size.width, height: geometry.size.width * heightLimiter, alignment: .top)
//                                .frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.width * heightLimiter, maxHeight: .infinity, alignment: .center)
                                .clipped()
                            
                            Image(logoTypeName)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.4, alignment: .center)
                                .clipped()
                            
                            
                        }.edgesIgnoringSafeArea(.all)
                    }.edgesIgnoringSafeArea(.all)
                    
                }

            

    }
}

//step 1 -- Create a shape view which can give shape
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//step 2 - embed shape in viewModifier to help use with ease
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
        
    }
}
//step 3 - crate a polymorphic view with same name as swiftUI's cornerRadius
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
        


/*struct LogoShapeView_Previews: PreviewProvider {
    static var previews: some View {
        LogoShapeView()
    }
}*/
