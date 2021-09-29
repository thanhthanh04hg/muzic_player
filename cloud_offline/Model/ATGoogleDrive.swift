//
//  ATGoogleDrive.swift
//  cloud_offline
//
//  Created by Macbook on 09/07/2021.
//

import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
enum GDriveError: Error {
    case NoDataAtPath
}

class ATGoogleDrive {
      // Our Google Drive Wrapper
    private let service: GTLRDriveService
    
    init(_ service: GTLRDriveService) {
        self.service = service
    }
    
    public func listFilesInFolder(_ folder: String, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        search(folder) { (folderID, error) in
            guard let ID = folderID else {
                onCompleted(nil, error)
                return
            }
            self.listFiles(ID, onCompleted: onCompleted)
        }
    }
    
    private func listFiles(_ folderID: String, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderID)' in parents"
        service.executeQuery(query) { (ticket, result, error) in
                    onCompleted(result as? GTLRDrive_FileList, error)
                }

    }
    //MARK: THEM VAO
    public func listDrive(onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
//        query.pageSize = 100
//        query.q = "'\(folderID)' in parents"
        service.executeQuery(query) { (ticket, result, error) in
                    onCompleted(result as? GTLRDrive_FileList, error)
                }

    }
    func loadDriveFiles() {
//        var driveFiles = GTLRDrive_File()
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "'\("root")' IN parents"
        service.executeQuery(query, completionHandler: { ticket, files, error in
            if error == nil {
                var driveFiles = [GTLRDrive_File]()
                if let items = files{
                    driveFiles.append(items as! GTLRDrive_File)
                }

                for file in driveFiles {
                    print("File is \(file.name)")
                }
            } else {
                if let error = error {
                    print("An error occurred: \(error)")
                }
            }
        })
    }
    func downloadAndSaveAudioFile(_ audioFile: String, completion: @escaping (String) -> Void) {
            
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
        
        do {
            try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(soundDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: audioFile)
        service.executeQuery(query) { (ticket, file, error) in
            if let audioUrl = URL(string: "https://www.googleapis.com/download/drive/v3/files/1QiBD66O_n7eGFWgMLyN7IudPsAxrzcfa?alt=media") {     //https://www.googleapis.com/download/drive/v3/files/1QiBD66O_n7eGFWgMLyN7IudPsAxrzcfa?alt=media
                // create your document folder url
                let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
                let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
                // your destination file url
                let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
                
                print(destinationUrl)
                // check if it exists before downloading it
                if FileManager().fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                } else {
                    //  if the file doesn't exist
                    //  just download the data from your url
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                            // after downloading your data you need to save it to your destination url
                            if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                                print("file saved")
                                completion(destinationUrl.absoluteString)
                            } else {
                                print("error saving file")
                                completion("")
                            }
                        }
                    })
                }
            }
            
             
        }
        
       
    }
        
    //
    public func uploadFile(_ folderName: String, filePath: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
        
        search(folderName) { (folderID, error) in
            
            if let ID = folderID {
                self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
            } else {
                self.createFolder(folderName, onCompleted: { (folderID, error) in
                    guard let ID = folderID else {
                        onCompleted?(nil, error)
                        return
                    }
                    self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
                })
            }
        }
    }
            
    private func upload(_ parentID: String, path: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
        
        guard let data = FileManager.default.contents(atPath: path) else {
            onCompleted?(nil, GDriveError.NoDataAtPath)
            return
        }
               
       let file = GTLRDrive_File()
       file.name = path.components(separatedBy: "/").last
       file.parents = [parentID]
       
       let uploadParams = GTLRUploadParameters.init(data: data, mimeType: MIMEType)
       uploadParams.shouldUploadWithSingleRequest = true
       
       let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
       query.fields = "id"
       
       self.service.executeQuery(query, completionHandler: { (ticket, file, error) in
           onCompleted?((file as? GTLRDrive_File)?.identifier, error)
       })
   }
                   
    public func download(_ fileID: String, onCompleted: @escaping (Data?, Error?) -> ()) {
       let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
       service.executeQuery(query) { (ticket, file, error) in
//        print(ticket.)
           onCompleted((file as? GTLRDataObject)?.data, error)
            
       }
    }
    
    public func search(_ fileName: String, onCompleted: @escaping (String?, Error?) -> ()) {
           let query = GTLRDriveQuery_FilesList.query()
           query.pageSize = 1
           query.q = "name contains '\(fileName)'"
           
           service.executeQuery(query) { (ticket, results, error) in
               onCompleted((results as? GTLRDrive_FileList)?.files?.first?.identifier, error)
           }
       }
       
    public func createFolder(_ name: String, onCompleted: @escaping (String?, Error?) -> ()) { // tạo Folder trên GGDrive
       let file = GTLRDrive_File()
       file.name = name
       file.mimeType = "application/vnd.google-apps.folder"
       let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
       query.fields = "id"
       
       service.executeQuery(query) { (ticket, folder, error) in
            
           onCompleted((folder as? GTLRDrive_File)?.identifier, error)
       }
    }
       
    public func delete(_ fileID: String, onCompleted: ((Error?) -> ())?) {
       let query = GTLRDriveQuery_FilesDelete.query(withFileId: fileID)
       service.executeQuery(query) { (ticket, nilFile, error) in
           onCompleted?(error)
       }
    }
    

}
