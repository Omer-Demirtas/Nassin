
class Profile{
  String name;
  String image;
  String id;
  String token;

  Profile({this.id, this.name, this.image, this.token});

  factory Profile.fromJson(data) {
    return Profile(
      name: data["userName"],
      id: data["id"],
      image: data["image"],
      token: data["token"]
    );
  }
}