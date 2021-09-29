//
//  File.swift
//  cloud_offline
//
//  Created by Macbook on 19/07/2021.
//

import Foundation
import RealmSwift

class RealmService {
    static var shared = RealmService()
    
    func load<T: Object>(listOf: T.Type) -> [T] {
        do {
            let objects = try Realm().objects(T.self)
            var list = [T]()
            for obj in objects {
                list.append(obj)
            }
            return list
        } catch {}
        return []
    }
    func add(_ object : Object ) {
        do{
            let realm = try! Realm()
            try! realm.write {
                realm.add(object)
            }
        }catch{
            print ("Can't add")
        }
    }
    func delete(_ object : Object ){
        do{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(object)
            }
        }catch{
            print ("Can't add")
        }
    }
    func deleteAll(){
        do{
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }catch{
            print ("Can't add")
        }
    }
    func sort(by : Int) -> [Song] {
        do {
            switch by {
            case 0:
                var list = load(listOf: Song.self)
                list.sort{
                    (($0.name as AnyObject) as? String) ?? "Unknown" < (($1.name as AnyObject) as? String) ?? "Unknown"
                }
                return list
            case 1 :
                var list = load(listOf: Song.self)
                list.sort{
                    (($0.name as AnyObject) as? String) ?? "Unknown" > (($1.name as AnyObject) as? String) ?? "Unknown"
                }
                return list
            case 2 :
                var list = load(listOf: Song.self)
                var listReserve = [Song]()
                for i in (0..<list.count).reversed(){
                    listReserve.append(list[i])
                }
                return listReserve
            case 3 :
                var list = load(listOf: Song.self)
                list = load(listOf: Song.self)
                return list
            default:
                print("default")
            }
//            return list
        } catch {}
        return []
    }
    func sortVideos(by : Int) -> [Video] {
        do {
            switch by {
            case 0:
                var list = load(listOf: Video.self)
                list.sort{
                    (($0.videoName as AnyObject) as? String) ?? "Unknown" < (($1.videoName as AnyObject) as? String) ?? "Unknown"
                }
                return list
            case 1 :
                var list = load(listOf: Video.self)
                list.sort{
                    (($0.videoName as AnyObject) as? String) ?? "Unknown" > (($1.videoName as AnyObject) as? String) ?? "Unknown"
                }
                return list
            case 2 :
                var list = load(listOf: Video.self)
                var listReserve = [Video]()
                for i in (0..<list.count).reversed(){
                    listReserve.append(list[i])
                }
                return listReserve
            case 3 :
                var list = load(listOf: Video.self)
                return list
            default:
                print("default")
            }
//            return list
        } catch {}
        return []
    }
    func loadByFilter<T: Object>(listOf: T.Type, filter: String? = nil) -> [T] {
        do {
            var objects = try Realm().objects(T.self)
            if let filter = filter {
                objects = objects.filter(filter)
            }
            var list = [T]()
            for obj in objects {
                list.append(obj)
            }
            return list
        } catch {}
        return []
    }
    func get<T:Object>(_: T.Type,filter:String?=nil) -> T {
        do{
            let realm = try Realm()
            let result = realm.objects(T.self).filter(filter!).last
            return result!
        }catch{
            print("unsuccessful")
        }
        return T()
    }
    func removeAudio(index : Int , playlist : Playlist) {
        let newSongs = List<Song>()
        for i in 0..<playlist.songs.count {
            if i == index {
                continue
            }
            else{
                newSongs.append(playlist.songs[i])
            }
        }

        let realm = try! Realm()
        try! realm.write {
            playlist.songs.removeAll()
            newSongs.forEach { newSong in
                playlist.songs.append(newSong)
            }
        }
    }
    func removeVideo(index : Int , playlist : PlaylistVideo) {
        let newVideos = List<Video>()
        for i in 0..<playlist.videos.count {
            if i == index {
                continue
            }
            else{
                newVideos.append(playlist.videos[i])
            }
        }

        let realm = try! Realm()
        try! realm.write {
            playlist.videos.removeAll()
            newVideos.forEach { newVideo in
                playlist.videos.append(newVideo)
            }
        }
    }
    func updateSong(playlist : Playlist , song : Song){
        
        let realm = try! Realm()
        try! realm.write {
            playlist.songs.append(song)
        }
    }
    func updateVideo(playlist : PlaylistVideo , video : Video){
        let realm = try! Realm()
        try! realm.write {
            playlist.videos.append(video)
        }
    }
    func updateRecentAudio(audio : Song , position : Int ){
        let realm = try! Realm()
        let recent = get(RecentAudio.self, filter: "name contains 'Recent Audio'")
        try! realm.write {
            recent.songs[position] = audio
        }
    }

}
