//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_stuff.dart';
import '../../providers/accounts.dart';
import '../../providers/freelance_offer.dart';
import '../../widget/freelance_offer_item.dart';

class FreelancerRequests extends StatefulWidget {
  static const routeName = 'freelancer-request';
  @override
  _FreelancerRequestsState createState() => _FreelancerRequestsState();
}

class _FreelancerRequestsState extends State<FreelancerRequests> {
  List<FreelanceOffer> offers;
  Account freelancer;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      freelancer = ModalRoute.of(context).settings.arguments as Account;
      await Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .specificOffers(
              '$ipAddress/freelancer/get_applied_frJob', freelancer.userId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<FreelanceOfferBusiness>(context, listen: false)
        .specificOffers(
            '$ipAddress/freelancer/get_applied_frJob', freelancer.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    offers = Provider.of<FreelanceOfferBusiness>(context).getRequests;
    return Scaffold(
        appBar: AppBar(
          title: Text('My requests'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : offers.isEmpty
                  ? Center(child: Text('You haven\'t send any request yet'))
                  : Scrollbar(
                      child: ListView.builder(
                          itemCount: offers.length,
                          itemBuilder: (ctx, index) =>
                              FreelanceOfferItem(offers[index], freelancer, 1,false)),
                    ),
        ));
  }
}
