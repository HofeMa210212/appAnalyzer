
import 'package:instagramanalyzer/Apps/Instagram/Posts/post.dart';

class Channel{
  final String name;
  int likedPostCnt = 0;
  List<Post> _posts = [];

  Channel({
    required this.name,
  });

  List<Post> get posts{
    return _posts;
  }



  void addPost(Post p){
    _posts.add(p);
    likedPostCnt++;
  }

  @override
  bool operator ==(Object other) {
    return other is Channel && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;


}