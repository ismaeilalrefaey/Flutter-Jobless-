//@dart=2.9
import 'package:flutter/material.dart';
import '../providers/accounts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/freelance_offer.dart';

class OfferDetails extends StatelessWidget {
  static const routeName = 'offer-details';

  @override
  Widget build(BuildContext context) {
    final String offerId = ModalRoute.of(context).settings.arguments as String;
    final FreelanceOffer offer =
        Provider.of<FreelanceOfferBusiness>(context, listen: false)
            .findById(offerId);
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(child: CircleAvatar()),
        ), //child: Image.file(offer.image),
        title: Text(offer.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'offer details:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Text(
                  '\u2022 Wage: ${(offer.wage)}\$ \n\u2022 deadline:${(DateFormat('dd/MM/yyy hh:mm').format(offer.deadLine))}',
                  style: TextStyle(fontSize: 17)),
              Divider(),
              Text(
                'Full details:',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Text(offer.description, style: TextStyle(fontSize: 17)),
              //SizedBox(height: 17),
              Divider(),
              Text('Skills: ',
                  style: TextStyle(fontSize: 22, color: Colors.blue)),
              Text('\u2022 ${(offer.skills)}', style: TextStyle(fontSize: 17)),
              SizedBox(height: 17),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 300),
                  child: ElevatedButton(
                    child: Text('Apply Now'),
                    onPressed: () {
                      print('apply');
                      
                      Provider.of<FreelancerAccount>(context).applyForAJob(offerId);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 300),
                  child: ElevatedButton(
                    child: Text('Save For Later'),
                    onPressed: () {
                      //offer.toggleFavoriteState(authToken.token);
                      scaffold.showSnackBar(SnackBar(
                        content: Text('Added to favorite '),
                        duration: Duration(seconds: 2),
                      ));
                      print('favorite');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
