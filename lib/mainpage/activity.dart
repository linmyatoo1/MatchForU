import 'package:flutter/material.dart';
import 'package:match_for_u/mainpage/activity_form.dart';
import 'package:match_for_u/models/activity_detail.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<Activity> activities = [];

  bool isLoading = false;
  final ActivityAPI activityAPI = ActivityAPI();

  Future<void> loadActivities() async {
  try {
    setState(() {
      isLoading = true;
    });

    final fetchedActivities = await ActivityAPI.getActivities();

    setState(() {
      activities.clear(); // Clear existing activities
      // Convert the Map<String, dynamic> to Activity objects
      activities.addAll(
        fetchedActivities
            .map((data) => Activity(
                  name: data['name'] ?? '',
                  description: data['description'] ?? '',
                  time: data['time'] ?? '',
                  currentParticipants: data['currentParticipants'] ?? 1,
                  maxParticipants: data['maxParticipants'] ?? 1,
                ))
            .toList(),
      );
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load activities: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  void initState() {
    super.initState();
    loadActivities(); // Load activities when page opens
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activities'),
        ),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : activities.isEmpty
                      ? const Center(child: Text('No activities available'))
                      : ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            return ActivityCard(activity: activities[index]);
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return AddActivityForm(
                        onSuccess: () {
                          loadActivities();
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: const Text(
                    'Add Your Activity',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
