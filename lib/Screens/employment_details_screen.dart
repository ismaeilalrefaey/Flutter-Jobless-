//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/previous_work.dart';
import '../widget/previous_work_item.dart';
import '../providers/employment_details.dart';
import '../widget/employment_details_item.dart';
import '../Screens/add_details_screens/add_new_emplyment_details_screen.dart';

class EmploymentDetailsScreen extends StatefulWidget {
  static const routeName = '/employment-details-screen';

  @override
  _EmploymentDetailsScreenState createState() =>
      _EmploymentDetailsScreenState();
}

class _EmploymentDetailsScreenState extends State<EmploymentDetailsScreen> {
  bool isFreelancer;
  var _isInit = true;
  var _isLoading = false;
  String id;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      var data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      id = data['user_id'] as String;
      isFreelancer = !data['is_user'];
      print(isFreelancer);
      // id = '1';
      // isFreelancer = true;
      isFreelancer
          ? await Provider.of<PreviousWorkProvider>(context, listen: false)
              .fetchAndSetPreviousWork(id)
          : await Provider.of<EmploymentDetailsProvider>(context, listen: false)
              .fetchAndSetEmploymentDetails(id);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    PreviousWork previousWork =
        PreviousWork(id: null, link: '', freelancerId: id);
    var emp = Provider.of<EmploymentDetailsProvider>(context).items;
    var pre = Provider.of<PreviousWorkProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Experiences'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              !isFreelancer
                  ? Navigator.of(context).pushNamed(
                      AddNewEmploymentDetailsScreen.routeName,
                      arguments: id,
                    )
                  : showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        elevation: 5,
                        content: TextFormField(
                          onChanged: (value) {
                            previousWork.link = value;
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return 'This field can\'t be empty';
                            return null;
                          },
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Previous Work Link',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Add'),
                            onPressed: () async {
                              await Provider.of<PreviousWorkProvider>(context,
                                      listen: false)
                                  .add(previousWork);
                              await Provider.of<PreviousWorkProvider>(context,
                                      listen: false)
                                  .fetchAndSetPreviousWork(id);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
      body: _isLoading
          ? LinearProgressIndicator()
          : Scrollbar(
              child: ListView.builder(
                itemCount: isFreelancer == true ? pre.length : emp.length,
                itemBuilder: (_, index) => isFreelancer == true
                    ? PreviousWorkItem(pre[index])
                    : EmploymentDetailsItem(emp[index]),
              ),
            ),
    );
  }
}
