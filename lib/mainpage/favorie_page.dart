import 'package:flutter/material.dart';
import 'package:match_for_u/welcome.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Activity> activities = [
    Activity(
      name: 'Eat Moo Kra Tha, Okay Shabu',
      description: 'Brianna B.',
      time: '18:30',
      currentParticipants: 2,
      maxParticipants: 6,
    ),
    Activity(
      name: 'Jogging, Outdoor stadium',
      description: 'Casper K.',
      time: '18:00',
      currentParticipants: 2,
      maxParticipants: 4,
    ),
    Activity(
      name: 'Isabelle A.',
      description: 'Board game, Ducatim',
      time: '20:30',
      currentParticipants: 5,
      maxParticipants: 10,
    ),
    Activity(
      name: 'Casper K.',
      description: 'Jogging, Outdoor stadium',
      time: '18:00',
      currentParticipants: 2,
      maxParticipants: 4,
    ),
    Activity(
      name: 'Casper K.',
      description: 'Jogging, Outdoor stadium',
      time: '18:00',
      currentParticipants: 2,
      maxParticipants: 4,
    ),
    Activity(
      name: 'Casper K.',
      description: 'Jogging, Outdoor stadium',
      time: '18:00',
      currentParticipants: 2,
      maxParticipants: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activities'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ActivityCard(activity: activities[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Your Activity',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Activity {
  final String name;
  final String description;
  final String time;
  final int currentParticipants;
  final int maxParticipants;

  Activity({
    required this.name,
    required this.description,
    required this.time,
    required this.currentParticipants,
    required this.maxParticipants,
  });
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.pink.shade200),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: ${activity.time}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people, size: 16),
                          const SizedBox(width: 4),
                          Text(
                              '${activity.currentParticipants}/${activity.maxParticipants}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Join'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Dismiss'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
