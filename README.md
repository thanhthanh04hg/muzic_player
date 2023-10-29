# muzic_player
#### Description:
>Muzic player is an offline music application which allows you to manage and play music or videos in the mobile phone's files. Function includes:
- Play music/video. Change playback, play next, previous, repeat
- Delete, sort track/video
- Create playlist, play playlist: repeat, next, previous, delete, rename playlist
- Search by category
> Swift, Xcode, Cocoapod
## Features
I've used xcode and cocoapod framework based in Swift.
Besides i used some extension library such as SCLAlertView, EVTopTabBar, ...
My main database is Realm Swift
## Explaining the project and the database
- First of all, you need to import video or music from the file in your mobile phone into the application. Then you will have music/video playlists. Now your local file will be saved in database of app (Realm Swift)

- You can play all of music/video in app with all advantage of changing playback, repeating, playing all playlist, playing next or previous, watching full video, ...
  
- After users finish listening to the video, it will display in the list of recently watched videos which saved in database.
  
-  Users can also sort the order of videos according to the 4 criteria above. In terms of playlist mode, users can create their own playlists, rename, delete, and play entire.
  
- Finally, the search function allows users to search by the song category they need.

### Object database in Realm Swift:
I needed three object for my database:

- First, all musics and videos. Where I put, id, username, hash (for password) and email, notice that id must be a primary key here.

- Second, video playlist and music playlist. I put person_id, case_id, adress, email (could have referenced the users table), description, reason, photo. In photo I store the filename of the image, and in my filesystem I store all images that were uploads with flask-wtf extension. Notice that here person_id must be a foreign key.

- Three, recent videos and recent musics , this table is for store the relationship between persons and cases, one person might have many cases likewise one case might have many peoples interested

### Play music and video.
- Phat nhac 
![Validation gif](Screenshots/validation.gif)
## Pictures
- Login and Adopt page

| Login | Adopt |
| :---: | :---: |
| <img src="Screenshots/img1.png" width="400">  | <img src="Screenshots/img3adopt.png" width="400">|

- Homepage and Responsive show case

| Homepage | Responsive Web |
| :---: | :---: |
| <img src="Screenshots/img4home.png" width="400"> | <img src="Screenshots/responsive.gif" width = "400">


#### Video Demo:
For the CS50 final project you have to make a video showning your project,
[MUZIC PLAYER](https://youtu.be/if2wiRfEgyM)

## Documentation
- Link tai lieu Realm Swift
- Link tai lieu AVPlay
- Link tai lieu Swift doc

## About CS50
CS50 is a openware course from Havard University and taught by David J. Malan

- Cai thien nhung gi sau khoa hoc

Thank you for all CS50.

- Where I get CS50 course?
https://cs50.harvard.edu/x/2023/
