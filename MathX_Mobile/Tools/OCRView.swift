import SwiftUI
import Vision

struct OCRView: View {
    @State private var recognizedText = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            if inputImage != nil {
                Image(uiImage: inputImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Select an image to recognize text.")
            }
            
            Button("Select Image") {
                showingImagePicker = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            .sheet(isPresented: $showingImagePicker, onDismiss: recognizeText) {
                ImagePicker(image: $inputImage)
            }
            
            Text(recognizedText)
                .padding()
        }
    }
    
    func recognizeText() {
        guard let inputImage = inputImage else { return }
        
        // Initialize an image request handler to pass the selected image to Vision
        let imageRequestHandler = VNImageRequestHandler(cgImage: inputImage.cgImage!)
        
        // Initialize a request to recognize text
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            // Collect the recognized text from the observations
            var recognizedText = ""
            for observation in results {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.recognizedText = recognizedText
            }
        }
        
        // Specify the recognition level and the languages to recognize
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["en_US"]
        
        // Send the request to Vision
        do {
            try imageRequestHandler.perform([textRecognitionRequest])
        } catch {
            print("Error recognizing text: \(error.localizedDescription)")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct OCRView_Previews: PreviewProvider {
    static var previews: some View {
        OCRView()
    }
}
