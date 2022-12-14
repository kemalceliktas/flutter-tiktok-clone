import 'package:flutter/material.dart';
import 'package:tiktok_clone_app/constants.dart';
import 'package:tiktok_clone_app/controllers/video_controller.dart';
import 'package:tiktok_clone_app/views/screens/comment_screen.dart';
import 'package:tiktok_clone_app/views/widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../widgets/circle_animation.dart';

class VideoScreen extends StatelessWidget {
   VideoScreen({super.key});

  final VideoControler videoControler = Get.put(VideoControler());
  

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                    image: NetworkImage(profilePhoto),
                    fit: BoxFit.cover,
                  )),
            ),
          )
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
               
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () {
          return PageView.builder(
            itemCount: videoControler.videoList.length,
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1,
            ),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = videoControler.videoList[index];
              return Stack(
                children: [
                  VideoPlayerItem(videoUrl: data.videoUrl,),
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      data.username,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data.caption,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          data.songName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfile(
                                      data.profilePhoto),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          videoControler.likesVideo(data.id);
                                          
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color:data.likes.contains(authController.user.uid) ? Colors.red:Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        data.likes.length.toString(),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(id: data.id,),),),
                                        child: Icon(
                                          Icons.comment,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        data.commentCount.toString(),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.reply,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                       data.shareCount.toString(),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  CircleAnimation(
                                    child: buildMusicAlbum(data.profilePhoto),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          );
        }
      ),
    );
  }
}
