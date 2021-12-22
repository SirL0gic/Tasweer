import 'post_data.dart';
import 'awards.dart';
import 'community_data.dart';

/**
 * Code based on GitHub: https://github.com/MarcusNg/flutter_chat_ui
 * This repository is part of the "Apps From Scratch: Flutter Chat UI" series by
 * Marcus Ng. YouTube link: https://www.youtube.com/watch?v=h-igXZCCrrc (Accessed 26/1/2021)
 */

class User {
  final int id;
  final String username;
  final String ppURL;
  final List<User> followers;
  final List<User> following;
  final List<PostData> posts;
  final List<Awards> awards;
  final List<CommunityData> userCommunities;

  User({
    this.id,
    this.username,
    this.ppURL,
    this.followers,
    this.following,
    this.posts,
    this.awards,
    this.userCommunities,
  });
}
