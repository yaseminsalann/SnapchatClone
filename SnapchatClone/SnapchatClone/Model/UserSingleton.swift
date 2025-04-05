//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.04.2025.
//

/*Swift programlama dilinde Singleton, bir sınıfın (class) yalnızca bir örneğinin (instance) oluşturulmasını ve bu örneğe global olarak erişilebilmesini sağlayan bir tasarım desenidir (design pattern). Genellikle uygulama genelinde paylaşılan tek bir nesneye ihtiyaç duyulduğunda kullanılır. Örneğin, bir ağ yöneticisi (network manager), veri yöneticisi (data manager), oturum yöneticisi (session manager) gibi sınıflar singleton olabilir.*/
class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
    }
    
    
}
