//
//  ParseCoordinator.swift
//  My store
//
//  Created by Михаил Супрун on 1/23/25.
//

import ParseCore


class ParseManager: ObservableObject {
    let classNameKey = "KeyString"
    let nameKey = "Name"
    let costKey = "Cost"
    let descriptionKey = "Description"
    let imageKey = "Image"
    
    func checkParseConnection(completion: @escaping (Bool, Error?) -> Void) {
        let query = PFQuery(className: "Test")
        query.limit = 1
        
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print("Failed to connect to Parse: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully connected to Parse!")
                completion(true, nil)
            }
        }
    }
    
    func uploadImage(image: UIImage, name: String, classStorage: String) {
        // Ensure the user is logged in
        guard let currentUser = PFUser.current() else {
            print("User must be logged in to upload files.")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Failed to convert image to data.")
            return
        }
        let parseFile = PFFileObject(name: name, data: imageData)
        let acl = PFACL()
        acl.setReadAccess(true, for: currentUser)
        acl.setWriteAccess(true, for: currentUser)
        
        let imageObject = PFObject(className: classStorage)
        imageObject["imageData"] = parseFile
        
        imageObject.saveInBackground(block: { (success, error) in
            if success {
                print("Image uploaded successfully. URL: \(parseFile?.url ?? "No URL")")
            } else if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            }
        })
    }
    
    func signUpUser(username: String, password: String, email: String) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackground { (succeeded, error) in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("User signed up successfully")
            }
        }
    }
    
    func logInUser(username: String, password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
            } else {
                print("User logged in successfully: \(String(describing: user?.username))")
            }
        }
    }
    func checkAuthenticationStatus() -> Bool {
        return PFUser.current() != nil
    }
    
    func fetchObjectArray(className: String, completion: @escaping ( [PFObject]?) -> Void)  {
        let query = PFQuery(className: className)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print("Error fetching image URLs: \(error.localizedDescription)")
                completion(nil)
            } else if let objectsArray = objects {
                completion(objectsArray)
            }
        }
    }
    func downloadImage(file: PFFileObject, completion: @escaping (UIImage?) -> Void) {
        file.getDataInBackground { (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    func sendOrderToServer(orderString: String, userAddress: String){
        let order = PFObject(className: "Orders")
        order["Description"] = orderString
        order["address"] = userAddress
        order.saveInBackground { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Order send successfuly!")}
        }
    }
}

