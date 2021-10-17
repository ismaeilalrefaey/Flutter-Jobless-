//@dart=2.9

import '../Screens/company_profile_screen.dart';
import 'package:toast/toast.dart';

import '../Screens/job_details.dart';
import '../providers/admin_provider.dart';
import '../providers/job.dart';
import 'package:provider/provider.dart';

import '../providers/details.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = '/admin-screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Widget> pages = [NewCompanies(), NewJobs()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobless?'),
      ),
      body: pages[selectedIndex],
      backgroundColor: Colors.blue,
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          Icon(Icons.build, color: Colors.black, size: 25),
          Icon(Icons.add_box_outlined, color: Colors.black, size: 25),
        ],
      ),
    );
  }
}

class NewCompanies extends StatefulWidget {
  @override
  _NewCompaniesState createState() => _NewCompaniesState();
}

class _NewCompaniesState extends State<NewCompanies> {
  ScrollController sc = ScrollController();

  Future<void> onAdminAction(
    List<CompanyDetails> list,
    int index,
    bool isApproval,
  ) async {
    if (await Provider.of<AdminProvider>(context, listen: false)
        .actionOfAdminOnCompanies(list[index].id, isApproval)) {
      setState(() {
        list.removeAt(index);
      });
      Toast.show(
        'Company\'s ${isApproval ? 'Approval' : 'Rejection'} has Succeeded',
        context,
        duration: 2,
        gravity: Toast.BOTTOM,
        backgroundRadius: 10,
      );
    } else {
      // showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     content: Text(
      //         'Couldn\'t ${isApproval ? 'approve' : 'delete'}. Try again later, please'),
      //     actions: [
      //       ElevatedButton(
      //         child: Text('Okay'),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //       )
      //     ],
      //   ),
      // );
      Toast.show(
        'Company\'s ${isApproval ? 'Approval' : 'Rejection'} has Failed !!\nTry again later, please',
        context,
        duration: 2,
        gravity: Toast.BOTTOM,
        backgroundRadius: 10,
      );
    }
  }

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AdminProvider>(context, listen: false)
          .fetchAndSetCompanies()
          .then((_) {
        setState(() {
          _isInit = false;
          _isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AdminProvider>(context, listen: false)
        .fetchAndSetCompanies()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final newCompanies = Provider.of<AdminProvider>(context).companies;
    return _isLoading
        ? LinearProgressIndicator()
        : Container(
            padding: EdgeInsets.all(8),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: sc,
                itemCount: newCompanies.length,
                itemBuilder: (ctx, index) {
                  return Scrollbar(
                    thickness: 24,
                    controller: sc,
                    hoverThickness: 37,
                    // isAlwaysShown: true,
                    showTrackOnHover: true,
                    key: UniqueKey(),
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        await onAdminAction(newCompanies, index, false);
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.white,
                        margin: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            String routeName = CompanyProfileScreen.routeName;
                            // String id = newCompanies[index].id;
                            Navigator.of(context).pushNamed(routeName,
                                arguments: newCompanies[index]);
                          },
                          title: Text(
                              newCompanies[index].name ?? 'Company\'s Name'),
                          leading: CircleAvatar(
                              child: (newCompanies[index]).image != null
                                  ? Image.file(
                                      newCompanies[index].image,
                                    )
                                  : Icon(Icons.person, size: 20)),
                          subtitle: Text(newCompanies[index].email ?? 'Email'),
                          trailing: IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () async => onAdminAction(
                              newCompanies,
                              index,
                              true,
                            ), // Approve
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}

class NewJobs extends StatefulWidget {
  @override
  _NewJobsState createState() => _NewJobsState();
}

class _NewJobsState extends State<NewJobs> {
  ScrollController sc = ScrollController();

  Future<void> onAdminAction(
    List<Job> list,
    int index,
    bool isApproval,
  ) async {
    if (await Provider.of<AdminProvider>(context, listen: false)
        .actionOfAdminOnJobs(list[index].id, isApproval)) {
      setState(() {
        list.removeAt(index);
      });
      Toast.show(
        'Job\'s ${isApproval ? 'Approval' : 'Rejection'} has Succeeded',
        context,
        duration: 2,
        gravity: Toast.BOTTOM,
        backgroundRadius: 10,
      );
    } else {
      // showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     content: Text(
      //         'Couldn\'t ${isApproval ? 'approve' : 'delete'}. Try again later, please'),
      //     actions: [
      //       ElevatedButton(
      //         child: Text('Okay'),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //       )
      //     ],
      //   ),
      // );
      Toast.show(
        'Job\'s ${isApproval ? 'Approval' : 'Rejection'} has Failed !!\nTry again later, please',
        context,
        duration: 2,
        gravity: Toast.BOTTOM,
        backgroundRadius: 10,
      );
    }
  }

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AdminProvider>(context, listen: false)
          .fetchAndSetJobs()
          .then((value) {
        setState(() {
          _isInit = false;
          _isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AdminProvider>(context, listen: false)
        .fetchAndSetJobs()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final newJobs = Provider.of<AdminProvider>(context, listen: false).jobs;
    return _isLoading
        ? LinearProgressIndicator()
        : Container(
            padding: EdgeInsets.all(8),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: sc,
                itemCount: newJobs.length,
                itemBuilder: (ctx, index) {
                  return Scrollbar(
                    thickness: 24,
                    controller: sc,
                    hoverThickness: 37,
                    // isAlwaysShown: true,
                    showTrackOnHover: true,
                    key: UniqueKey(),
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        await onAdminAction(newJobs, index, false);
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.white,
                        margin: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            String routeName = JobDetails.routeName;
                            String id = newJobs[index].id;
                            Navigator.of(context)
                                .pushNamed(routeName, arguments: {
                              'id': id,
                              'mark': 'Browse',
                              'job': newJobs[index],
                            });
                          },
                          title: Text(newJobs[index].title),
                          leading: CircleAvatar(
                              child: (newJobs[index]).image != null
                                  ? Image.file(
                                      (newJobs[index]).image,
                                    )
                                  : Icon(Icons.person, size: 20)),
                          subtitle: Text(
                              '${(newJobs[index]).shift} - ${(newJobs[index]).salary.toString()}\$'),
                          trailing: IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () async => onAdminAction(
                              newJobs,
                              index,
                              true,
                            ), // Approve
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
