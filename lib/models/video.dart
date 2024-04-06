class Video {
  String username;
  String uid;
  String id;
  List likes;
  double? price;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;
  String? productName;
  bool isVerified;
  Video({
    this.price,
    this.productName,
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "id": id,
        "likes": likes,
        "price": price,
        "productName": productName,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "isVerified": isVerified,
      };

  static Video fromSnap(Map<String, dynamic> json) {
    return Video(
      username: json['username'],
      uid: json['uid'],
      id: json['id'],
      likes: json['likes'],
      isVerified: json['isVerified'],
      price: json['price'],
      productName: json['productName'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      songName: json['songName'],
      caption: json['caption'],
      videoUrl: json['videoUrl'],
      profilePhoto: json['profilePhoto'],
      thumbnail: json['thumbnail'],
    );
  }
}
