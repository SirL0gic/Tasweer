
import 'package:tasweer/leaderboard_user.dart';


class LeaderYT {
  final UserYT lbUser;
  final int rank;
  final String leaderPost;
  final int flag;

  LeaderYT({
      this.lbUser,
      this.rank,
      this.leaderPost,
      this.flag
    });
}

  final UserYT alex = UserYT(
    id: 0,
    username: 'Alex Field',
    profilePic: 'assets/images/Alex Field.jpg',
  );

  final UserYT jane = UserYT(
    id: 1,
    username: 'Jane',
    profilePic: 'assets/images/Jane Doe PP.jpg',
  );

  final UserYT john = UserYT(
    id: 2,
    username: 'John Doe',
    profilePic: 'assets/images/John Doe.jpg',
  );

  final UserYT paul = UserYT(
    id: 3,
    username: 'Paul B',
    profilePic: 'assets/images/Paul Bettany.jpg',
  );

  final UserYT taylor = UserYT(
    id: 4,
    username: 'Taylor Swift',
    profilePic: 'assets/images/Red lantern photo.jpg',
  );

  final UserYT theweeknd = UserYT(
    id: 5,
    username: 'The Weeknd',
    profilePic: 'assets/images/Purple photo.jpg',
  );

  final UserYT dora = UserYT(
    id: 6,
    username: 'Dora',
    profilePic: 'assets/images/Green photo.jpg',
  );

  List<UserYT> users_on_lb = [taylor, jane, dora, paul, alex, theweeknd, john];

   List<LeaderYT> lb = [
     LeaderYT(
       lbUser: taylor,
       rank: (users_on_lb.indexOf(taylor) + 1),
       leaderPost: 'assets/images/Orange street.jpg',
       flag: 0,
     ),

     LeaderYT(
       lbUser: jane,
       rank: (users_on_lb.indexOf(jane) + 1),
       leaderPost: 'assets/images/Green sea photo.jpg',
       flag: 0,
     ),

     LeaderYT(
       lbUser: paul,
       rank: (users_on_lb.indexOf(paul) + 1),
       leaderPost: 'assets/images/Purple photo.jpg',
       flag: 0,
     ),

     LeaderYT(
       lbUser: alex,
       rank: (users_on_lb.indexOf(alex) + 1),
       leaderPost: 'assets/images/Orange Photo.jpg',
       flag: 1,
     ),

     LeaderYT(
       lbUser: theweeknd,
       rank: (users_on_lb.indexOf(theweeknd) + 1),
       leaderPost: 'assets/images/Red lantern photo.jpg',
       flag: 0,
     ),

     LeaderYT(
       lbUser: john,
       rank: (users_on_lb.indexOf(john) + 1),
       leaderPost: 'assets/images/Flo\'s Cafe.jpg',
       flag: 0,
     ),

     LeaderYT(
       lbUser: dora,
       rank: (users_on_lb.indexOf(dora) + 1),
       leaderPost: 'assets/images/Green photo.jpg',
       flag: 0,
     ),
   ];

