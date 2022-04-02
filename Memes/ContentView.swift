//
//  ContentView.swift
//  Memes
//
//  Created by Андрей Воробьев on 01.04.2022.
//

import SwiftUI

struct ContentView: View {

    @State private var memeData: MemeData?
    @State var imageView: UIImage
   
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Button {
                    let url = memeData?.url
                    let data = try? Data(contentsOf: url!)
                    imageView = UIImage(data: data!) ?? UIImage(named: "1234")!
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: imageView)
                } label: {
                    HStack {
                        Text("save")
                            
                            .foregroundColor(.black)
                        Image(systemName: "square.and.arrow.down")
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.black)
                    }
            }
            }.padding()
            
            AsyncImage(url: memeData?.url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                
            } placeholder: {
                VStack {
                    Text("Start by tap New Meme")
                        .font(.title)
                    ProgressView()
                        .frame(width: 30, height: 30, alignment: .center)
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .clipped()
            
            Button {
                loadMeme()
            } label: {
                Text("New Meme")
                    .foregroundColor(.black)
                    .font(.title)
            }
            

   

        }
        
        


    }
    
    private func loadMeme() {
        guard let url = URL(string: "https://meme-api.herokuapp.com/gimme") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            
            if let decodedData = try? JSONDecoder().decode(MemeData.self, from: data) {
                DispatchQueue.main.async {
                    self.memeData = decodedData
                }
            }
        }.resume()
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(imageView: UIImage(named: "1234")!)
        
    }
}


struct MemeData: Decodable {
    var postLink: String
    var subreddit: String
    var title: String
    var url: URL
    var nsfw: Bool
    var spoiler: Bool
    var author: String
    var ups: Int
    var preview: [String]

}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
