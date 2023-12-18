import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app_advanced/data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_app_advanced/models/models.dart';
import 'package:flutter_app_advanced/screens/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static const defaultFontFamily = "Avenir";
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff0D253C);
    final secondaryTextColor = Color(0xff2D4379);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: MyApp.defaultFontFamily)))),
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                fontFamily: MyApp.defaultFontFamily,
                fontSize: 24,
                color: primaryTextColor,
                fontWeight: FontWeight.w700),
            titleMedium: TextStyle(
                fontFamily: MyApp.defaultFontFamily,
                color: secondaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w200),
            titleLarge: TextStyle(
                fontFamily: MyApp.defaultFontFamily,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
            bodyMedium: TextStyle(
                color: secondaryTextColor,
                fontFamily: MyApp.defaultFontFamily)),
      ),
      home: Stack(
        children: [
          Positioned.fill(
            child: Home(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomNavigation(),
          )
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final stories = AppDatabase.stories;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi, imanFact!",
                      style: themeData.textTheme.titleMedium,
                    ),
                    Image.asset(
                      "assets/img/icons/notification.png",
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 16),
                child: Text(
                  "Explore today's",
                  style: themeData.textTheme.headlineMedium,
                ),
              ),
              _StoryList(stories: stories, themeData: themeData),
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.9,
                    child: PageView.builder(
                      itemCount: dataList.length,
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return carouselView(index);
                      },
                    ),
                  ),
                ],
              ),
              PostList(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: pi * value,
          child: carouselCard(dataList[index]),
        );
      },
    );
  }

  Widget carouselCard(DataModel data) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: data.imageName,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(data: data)));
                },
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage(
                        data.imageName,
                      ),
                      fit: BoxFit.fill),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 7),
                        blurRadius: 4,
                        color: Colors.black26)
                  ],
                )),
              ),
            ),
          ),
        ),
        Text(
          data.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45),
        ),
      ],
    );
  }
}

class _StoryList extends StatelessWidget {
  const _StoryList({
    super.key,
    required this.stories,
    required this.themeData,
  });

  final List<Story> stories;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(32, 2, 32, 0),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return _Story(story: story, themeData: themeData);
          }),
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({
    super.key,
    required this.story,
    required this.themeData,
  });

  final Story story;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Column(
        children: [
          Stack(
            children: [
              story.isViewed ? _profileImageViewed() : _profileImageNormal(),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/img/icons/${story.iconFileName}",
                  width: 24,
                  height: 24,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            story.name,
            style: themeData.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Container _profileImageNormal() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(begin: Alignment.topLeft, colors: [
          Color(0xff376AED),
          Color(0xff49B0E2),
          Color(0xff9CECFB),
        ]),
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22), color: Colors.white),
        padding: EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        child: _profileImage(),
      ),
    );
  }

  Widget _profileImageViewed() {
    return SizedBox(
      width: 68,
      height: 68,
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        radius: Radius.circular(24),
        color: Color(0xff7B8BB2),
        dashPattern: [8, 3],
        padding: EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: _profileImage(),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Image.asset("assets/img/stories/${story.imageFileName}"),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = AppDatabase.posts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest News',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Color(0xff376AED),
                  ),
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          itemExtent: 141,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _Post(post: post);
          },
        ),
      ],
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({
    super.key,
    required this.post,
  });

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 149,
      margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Color.fromARGB(77, 135, 134, 134))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/img/posts/small/${post.imageFileName}'),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.caption,
                    style: TextStyle(
                        fontFamily: MyApp.defaultFontFamily,
                        color: Color(0xff376AED),
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(post.title,
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.hand_thumbsup,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.likes,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        CupertinoIcons.clock,
                        size: 15,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            post.isBookmarked
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            size: 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 20, color: Color(0xaa9B8487))
              ]),
              child: Row(
                children: [],
              ),
            ),
          ),
          Center(
            child: Container(
              height: 85,
              width: 65,
              alignment: Alignment.topCenter,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.5),
                  color: Color(0xff376AED),
                ),
                child: Image.asset("assets/img/icons/plus.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
