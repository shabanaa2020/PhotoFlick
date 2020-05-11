//
//  DataBaseHelper.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 07/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

class DataBaseHelper {
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveImage(data: Data) {
        let imageInstance = Image(context: context)
        imageInstance.img = data
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
}


typealias ImageArray = [UIImage]
typealias ImageArrayRepresentation = Data

extension Array where Element: UIImage {
    // Given an array of UIImages return a Data representation of the array suitable for storing in core data as binary data that allows external storage
    func coreDataRepresentation() -> ImageArrayRepresentation? {
        let CDataArray = NSMutableArray()
        var dataObj = ImageArrayRepresentation()
        
        for img in self {
            guard let imageRepresentation = img.pngData() else {
                print("Unable to represent image as PNG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)    
        }
        do {
            dataObj = try NSKeyedArchiver.archivedData(withRootObject: CDataArray, requiringSecureCoding: true)
            
        } catch {
            return ImageArrayRepresentation()
        }
        return dataObj
    }
}

extension ImageArrayRepresentation {

    func imageArray() -> ImageArray? {
        do {
            if let mySavedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? NSArray {
                let imgArray = mySavedData.compactMap({
                    return UIImage(data: $0 as! Data)
                })
                return imgArray
            }else {
                print("Unable to convert data to ImageArray")
                return nil
            }
        }catch {
            return ImageArray()
        }
    }
}
