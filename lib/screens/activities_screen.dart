import 'package:flutter/material.dart';
import 'package:gaitmate/providers/activity.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:provider/provider.dart';
import '../widgets/collection_listview.dart';

class ActivitiesScreen extends StatefulWidget {
  static const routeName = '/activities';

  //final List<Activity> actvities;
  final String title;

  ActivitiesScreen(this.title);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  bool _isInit = true;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Collection>(context).initSetActivities().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final String type = widget.title == 'Runs' ? 'run' : 'walk';
    //need to make this cleaner above
    final List<Activity> activities =
        Provider.of<Collection>(context).getActvitiesByType(type);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15.0),
        child: CollectionListView(widget.title, activities),
      ),
    );
  }
}
