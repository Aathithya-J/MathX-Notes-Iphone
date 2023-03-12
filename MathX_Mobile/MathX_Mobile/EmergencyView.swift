import SwiftUI

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let imageName: String
}

struct EmergencyView: View {
    let contacts = [
        Contact(name: "Police", phoneNumber: "911", imageName: "shield"),
        Contact(name: "Ambulance", phoneNumber: "999", imageName: "heart"),
        Contact(name: "Fire Department", phoneNumber: "+6588372629", imageName: "flame")
    ]
    
    var body: some View {
        List(contacts) { contact in
            HStack {
                Image(systemName: contact.imageName)
                    .foregroundColor(.blue)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                    Text(contact.phoneNumber)
                        .font(.subheadline)
                }
                Spacer()
                Button(action: {
                    let phoneNumber = "telprompt:\(contact.phoneNumber)"
                    guard let url = URL(string: phoneNumber) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
                Button(action: {
                    let phoneNumber = "sms:\(contact.phoneNumber)"
                    guard let url = URL(string: phoneNumber) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
        }
        .navigationTitle("Emergency Contacts")
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView()
    }
}
