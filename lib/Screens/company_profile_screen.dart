//@dart=2.9
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../providers/accounts.dart';
import '../providers/details.dart';
import 'package:provider/provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  static const routeName = '/company-profile-screen';

  Widget _listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rate = 0.0;
    final deviceSize = MediaQuery.of(context).size;
    final companyData =
        ModalRoute.of(context).settings.arguments as CompanyDetails;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: CircleAvatar(
                  radius: 70,
                  child: companyData.image == null
                      ? Icon(
                          Icons.person,
                          size: 90,
                        )
                      : Image.file(companyData.image),
                ),
              ),
            ),
            SizedBox(height: 8),
            FittedBox(
              child: Text(
                '${companyData.name}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              child: Center(
                child: Text(
                  'rate this company',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (ctx) => Container(
                    height: deviceSize.height * 0.22,
                    child: StatefulBuilder(
                      builder: (ctx, setState) {
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.green[700],
                            inactiveTrackColor: Colors.green[100],
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: Colors.greenAccent,
                            overlayColor: Colors.green.withAlpha(32),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.green[700],
                            inactiveTickMarkColor: Colors.green[100],
                            valueIndicatorShape:
                                PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.greenAccent,
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: 100,
                            divisions: 10,
                            label: '$rate',
                            value: rate,
                            onChanged: (_) {},
                            onChangeEnd: (selection) async {
                              setState(() {
                                rate = selection;
                              });
                              try {
                                await Provider.of<CompanyAccount>(context,
                                            listen: false)
                                        .rate(companyData.id, rate)
                                    ? Toast.show(
                                        'Rate Succeeded',
                                        context,
                                      )
                                    : Toast.show(
                                        'Sorry, you can\'t rate a company\nif you did\'n work in it before',
                                        context,
                                        backgroundColor: Colors.red,
                                      );
                              } catch (e) {}
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            _title('Basic Details'),
            _listTile('${companyData.name}', 'Name of this company'),
            Divider(),
            _listTile(companyData.email, 'Company\'s email'),
            Divider(),
            _listTile(companyData.dateOfAaccountCreation.toString(),
                'Company\'s account\'s date of creation'),
            Divider(),
            _listTile(
                companyData.specialization == null
                    ? ''
                    : companyData.specialization,
                'Company\'s specialization'),
            Divider(),
            _listTile(
                companyData.description == null ? '' : companyData.description,
                'About this company'),
            Divider(),
            _listTile(
                companyData.location == null ||
                        companyData.location.country == null
                    ? ''
                    : companyData.location.country,
                'Country'),
            Divider(),
            _listTile(
                companyData.location == null ||
                        companyData.location.city == null
                    ? ''
                    : companyData.location.city,
                'City'),
            Divider(),
            _title('Accounts'),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.twitter == null
                    ? ''
                    : companyData.accounts.twitter,
                'Twitter'),
            Divider(),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.telegram == null
                    ? ''
                    : companyData.accounts.telegram,
                'Telegram'),
            Divider(),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.instagram == null
                    ? ''
                    : companyData.accounts.instagram,
                'Instagram'),
            Divider(),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.facebook == null
                    ? ''
                    : companyData.accounts.facebook,
                'Facebook'),
            Divider(),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.linkedin == null
                    ? ''
                    : companyData.accounts.linkedin,
                'Linkedin'),
            Divider(),
            _listTile(
                companyData.accounts == null ||
                        companyData.accounts.gmail == null
                    ? ''
                    : companyData.accounts.gmail,
                'Gmail'),
            Divider(),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
