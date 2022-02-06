import 'package:flutter/material.dart';
import 'package:movie_app/ui/pages/paint_indicator/paint_indecator.dart';

class DetailInfoPage extends StatefulWidget {
  const DetailInfoPage({Key? key}) : super(key: key);

  @override
  State<DetailInfoPage> createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HeadImageWidget(),
    );
  }
}

class HeadImageWidget extends StatelessWidget {
  const HeadImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            backgroundColor: Colors.red,
            pinned: true,
            // title: const Text('Spider Man'),
            expandedHeight: 216,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Spider Man'),
              background: ColoredBox(
                color: Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/backPhoto.jpg'),
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            )),
        SliverList(
          delegate: SliverChildListDelegate(
            const [
              MainInfoWidget(),
              UserScoreWidget(),
              MovieDiscriptionWidget(),
              CastsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class MainInfoWidget extends StatelessWidget {
  const MainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 26, right: 20),
      child: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Text(
                            'Spider  Man',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text('UA | Nov 22, 2019',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '1 hr 43 min | Drama, Fantasy',
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    SizedBox(height: 10),
                    Text('19,123 votes'),
                  ],
                ),
                const Text(
                  'English',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserScoreWidget extends StatelessWidget {
  const UserScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 28),
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: PaintIndecator(
                        percent: 80,
                        widthLine: 4.3,
                      ),
                    ),
                    const Text(
                      'User Score',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.grey,
                width: 2,
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Play Trailer',
                      style: TextStyle(color: Colors.red, fontSize: 17.6),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class MovieDiscriptionWidget extends StatelessWidget {
  const MovieDiscriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 20, right: 20),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Movie description',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(height: 9),
            Text(
              'Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CastsWidget extends StatelessWidget {
  const CastsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Casts'),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) => _SingleActiorWidget(
                    index: index,
                  )),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SingleActiorWidget extends StatelessWidget {
  final int index;
  const _SingleActiorWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 117,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: const [
            AspectRatio(
              aspectRatio: 1,
              child: Image(
                image: AssetImage('assets/images/actor.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Text('Tom Holland'),
            Text('Peter Parker /'),
            Text('Spider Man'),
          ],
        ),
      ),
    );
  }
}
