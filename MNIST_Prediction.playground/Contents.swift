//
//  ImageToPixelBufferConverter.swift
//  MNIST_Prediction (playground)
//
//  Created by Sergio Fraile on 7/31/19.
//  Copyright © 2019 Sergio Fraile. All rights reserved.
//

import UIKit

let samples: [String: String] = [
  "img_1" : "2",
  "img_2" : "0",
  "img_3" : "9",
  "img_4" : "0",
  "img_5" : "3",
  "img_6" : "7",
  "img_7" : "0",
  "img_8" : "3",
  "img_9" : "0",
  "img_10" : "3",
  "img_11" : "5",
  "img_12" : "7",
  "img_13" : "4",
  "img_14" : "0",
  "img_15" : "4",
  "img_16" : "3",
  "img_17" : "3",
  "img_18" : "1",
  "img_19" : "9",
  "img_20" : "0",
  "img_21" : "9",
  "img_22" : "1",
  "img_23" : "1",
  "img_24" : "5",
  "img_25" : "7",
  "img_26" : "4",
  "img_27" : "2",
  "img_28" : "7",
  "img_29" : "4",
  "img_30" : "7",
  "img_31" : "7",
  "img_32" : "5",
  "img_33" : "4",
  "img_34" : "2",
  "img_35" : "6",
  "img_36" : "2",
  "img_37" : "5",
  "img_38" : "5",
  "img_39" : "1",
  "img_40" : "6",
];

func recognize(image: UIImage) -> String? {
  guard let resizedImage = image.resize(to: CGSize(width: 28, height: 28)) else {
    print("The image couldn't be resized")
    return nil
  }
  
  if let pixelBufferImage = resizedImage.pixelBuffer() {
    return predict(pixelBufferImage)
  }
  
  print("The image couldn't be converted to a pixel buffer")
  return nil
}

func predict(_ pixelBufferImage: CVPixelBuffer) -> String? {
  if let prediction = try? model.prediction(image: pixelBufferImage) {
    return String(prediction.classLabel)
  }
  print("The pixel buffer couldn't be predicted")
  return nil
}

let model = MNISTClassifier()

for (imageName, label) in samples {
  if let image = UIImage(named: "samples/\(imageName).jpg") {
    let predictionResult = recognize(image: image)
    if label == predictionResult {
      print("Success!! 🥳, it was a \(label) for \(imageName)")
    } else {
      print("Failure... 😭, it was a \(label) and we predicted \(predictionResult ?? "undefined") for \(imageName)")
    }
  } else {
    print("The image couldn't be loaded")
  }
}
