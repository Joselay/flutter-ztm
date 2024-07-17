import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ztm/models/tweet.dart';
import 'package:flutter_ztm/pages/create.dart';
import 'package:flutter_ztm/pages/settings.dart';
import 'package:flutter_ztm/providers/tweet_provider.dart';
import 'package:flutter_ztm/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 1,
          ),
        ),
        title: const Image(
          image: AssetImage('assets/twitter_blue.png'),
          width: 50,
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  currentUser.user.profilePic,
                ),
              ),
            ),
          );
        }),
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              itemCount: tweets.length,
              itemBuilder: (context, count) {
                return ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(
                      tweets[count].profilePic,
                    ),
                  ),
                  title: Text(
                    tweets[count].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    tweets[count].tweet,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
          },
          error: (err, stackTrace) => const Center(
                child: Text("Error"),
              ),
          loading: () {}),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profilePic),
            ListTile(
              title: Text(
                "Hello, ${currentUser.user.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateTweet(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
