import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/previous_work.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousWorkItem extends StatelessWidget {
  final PreviousWork pre;
  PreviousWorkItem(this.pre);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
        trailing: IconButton(
            onPressed: () {
              Provider.of<PreviousWorkProvider>(context, listen: false)
                  .delete(pre.id, pre.freelancerId);
            },
            icon: Icon(Icons.delete)),
        title: InkWell(
          child: Text(pre.link),
          onTap: () => launch(pre.link),
        ),
      ),
    );
  }
}
