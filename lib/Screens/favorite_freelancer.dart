//@dart=2.9
import 'package:flutter/material.dart';
import '../global_stuff.dart';
import '../providers/accounts.dart';
import '../widget/freelance_offer_item.dart';
import '../providers/freelance_offer.dart';
import 'package:provider/provider.dart';

class FreelancerFavorite extends StatefulWidget {
  static const routeName = 'freelancer-favorite';
  @override
  _FreelancerFavoriteState createState() => _FreelancerFavoriteState();
}

class _FreelancerFavoriteState extends State<FreelancerFavorite> {
  List<FreelanceOffer> offers;
  Account freelancer;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      freelancer = ModalRoute.of(context).settings.arguments as Account;
      await Provider.of<FreelanceOfferBusiness>(context, listen: false)
          .specificOffers(
              '$ipAddress/freelancer/favorite_frjob_offer', freelancer.userId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
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
            '$ipAddress/freelancer/favorite_frjob_offer', freelancer.userId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    offers = Provider.of<FreelanceOfferBusiness>(context).getFavorite;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorite'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : offers.isEmpty
                ? Center(
                    child: Text('You haven\'t add any offer to favorite yet'))
                : Scrollbar(
                    child: ListView.builder(
                        itemCount: offers.length,
                        itemBuilder: (ctx, index) => FreelanceOfferItem(
                            offers[index], freelancer, null,false)),
                  ),
      ),
    );
  }
}
