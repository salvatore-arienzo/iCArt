
import AVFoundation
import UIKit
import CoreData

class CoreDataController
{
    static func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //to be removed
    static func newEmptyItem () -> Favorites
    {
        
        let context = getContext()
        
        
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as! Favorites;
        
        favorite.imagePath = "red_cube";
        favorite.title = "new empty title";
        favorite.author = "new empty author";
        
        return favorite;
        
    }
    
    static func addFavorite(imagePath: String, title: String, author: String)
    {
        let speecher = AVSpeechSynthesizer();
        
        if (fetchData().isEmpty)
        {
            let context = getContext();
            let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as! Favorites;
            favorite.imagePath = imagePath;
            favorite.title = title;
            favorite.author = author;
            let speechUtterence = AVSpeechUtterance(string: "Added to favorites");
            speechUtterence.rate = 0.5;
            speecher.speak(speechUtterence);
            saveContext();
        }
        else
        {
            for element in fetchData()
            {
                if (!(element.author == author && element.title == title && element.imagePath == imagePath))
                {
                    let context = getContext();
                    let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as! Favorites;
                    favorite.imagePath = imagePath;
                    favorite.title = title;
                    favorite.author = author;
                    let speechUtterence = AVSpeechUtterance(string: "Added to favorites");
                    speechUtterence.rate = 0.5;
                    speecher.speak(speechUtterence);
                    saveContext();
                    return;
                }
            }
            let speechUtterence = AVSpeechUtterance(string: "Already in favorites");
            speechUtterence.rate = 0.5;
            speecher.speak(speechUtterence);
        }
    }
    
    static func fetchData() -> [Favorites]
    {
        
        var items = [Favorites]()
        
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do
        {
            try items = context.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Errore in fetch \(error.code)")
        }
        return items
        
    }
    
    static func saveContext()
    {
        let context = getContext()
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Error in saving: \(error.code)")
        }
    }
    
    /*to be removed*/
    static func deleteAll()
    {
        let context = getContext();
        
        for element in fetchData()
        {
            context.delete(element);
        }
    }
}
