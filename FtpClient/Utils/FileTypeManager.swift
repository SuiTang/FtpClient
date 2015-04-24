//
//  FileTypes.swift
//  FtpClient
//
//  Created by damingdan on 15/4/24.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

enum FileType:String {
    case Image = "image"
    case Photo = "photo"
    case Video = "video"
    case Vector = "vector"
    case Setting = "setting"
    case Powerpoint = "powerpoint"
    case Music = "music"
    case Mail = "mail"
    case Folder = "folder"
    case Downloaded = "downloaded"
    case Data = "data"
    case Contact = "contact"
    case Code = "code"
    case Cloud = "cloud"
    case Calendar = "calendar"
    case Blank = "blank"
    case Bitmap = "bitmap"
    case Audio = "audio"
    case Attachment = "attachment"
    case Article = "article"
    case Achive = "achive"
    case Application = "application"
}

struct ExtensionsBinder {
    var imageName:FileType
    var extensions:[String]
    
    init(fileType:FileType, extensions:[String]) {
        self.imageName = fileType
        self.extensions = extensions
    }
}

/**
*  Bind the file extensions and the icon
*/
class FileTypeManager: NSObject {
    var image:UIImage {
        get {
            var imageName = self.fetchImageNameByExtension(self.fileExtension)
            return UIImage(named:imageName)!
        }
    }
    
    var bindExtensions:[ExtensionsBinder] = []
    
    var fileExtension:String = ""
    
    private func bind () {
        var extensions = ["BMP", "JPG", "JPEG", "GIF", "TIFF", "PSD", "PNG", "SVG", "PCX", "WMF", "EMF", "EPS", "TGA"]
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Image, extensions: extensions))
        
        extensions = ["AVI", "RMVB", "MOV", "ASF", "WMV", "NAVI", "3GP", "MKV", "FLV", "MPEG", "QT", "RA", "RAM", "RM", "MP4"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Video, extensions:extensions))
        
        extensions = ["CDX", "TTF", "AI", "CDR"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Vector, extensions:extensions))
        
        extensions = ["INI", "CONFIG", "CONF", "SYS"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Setting, extensions:extensions))
        
        extensions = ["WMA", "MMF", "MP3", "MID", "AIF", "SVX", "SND", "VOC"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Music, extensions:extensions))
        
        extensions = ["ZIP", "RAR", "JAR", "CAB", "ISO", "TAR", "UUE", "ZR"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Achive, extensions:extensions))
        
        extensions = ["TXT", "DOC", "PPT", "DOCX", "PPTX", "XLS", "XLSX", "VSD", "PDF", "HTML", "XHTML", "CHM"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Article, extensions:extensions))
        
        extensions = ["C", "CPP", "SWIFT", "M", "H", "CSS", "JS", "PHP", "CS", "SH", "JAVA"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Code, extensions:extensions))
        
        extensions = ["EXE", "BAT"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Application, extensions:extensions))
        
        extensions = ["DAT"];
        bindExtensions.append(ExtensionsBinder(fileType:FileType.Data, extensions:extensions))
    }
    
    func fetchImageNameByExtension(ext:String)->String {
        var ext = ext.uppercaseString
        for extBinder in self.bindExtensions {
            if contains(extBinder.extensions, ext) {
                extBinder.imageName.rawValue
            }
        }
        return FileType.Blank.rawValue
    }
    
    init(fileExtension: String) {
        super.init()
        bind()
        self.fileExtension = fileExtension
    }
   
}
