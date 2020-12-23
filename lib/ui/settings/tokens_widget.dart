import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:my_bismuth_wallet/model/tokenRef.dart';
import 'package:my_bismuth_wallet/service/app_service.dart';
import 'package:my_bismuth_wallet/service_locator.dart';
import 'package:my_bismuth_wallet/styles.dart';
import 'package:my_bismuth_wallet/app_icons.dart';
import 'package:my_bismuth_wallet/appstate_container.dart';
import 'package:my_bismuth_wallet/localization.dart';
import 'package:my_bismuth_wallet/model/address.dart';

class TokensList extends StatefulWidget {
  final AnimationController tokensListController;
  bool tokensListOpen;

  TokensList(this.tokensListController, this.tokensListOpen);

  _TokensListState createState() => _TokensListState();
}

class _TokensListState extends State<TokensList> {
  final Logger log = sl.get<Logger>();

  List<TokenRef> _tokenRefs;

  @override
  void initState() {
    super.initState();

    //
    loadTokenRefList();
  }

  void loadTokenRefList() async {
    AppService appService = new AppService();
    _tokenRefs = await appService.getTokensReflist();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: StateContainer.of(context).curTheme.backgroundDark,
          boxShadow: [
            BoxShadow(
                color: StateContainer.of(context).curTheme.overlay30,
                offset: Offset(-5, 0),
                blurRadius: 20),
          ],
        ),
        child: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.035,
            top: 60,
          ),
          child: Column(
            children: <Widget>[
              // Back button and Contacts Text
              Container(
                margin: EdgeInsets.only(bottom: 10.0, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        //Back button
                        Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: FlatButton(
                              highlightColor:
                                  StateContainer.of(context).curTheme.text15,
                              splashColor:
                                  StateContainer.of(context).curTheme.text15,
                              onPressed: () {
                                setState(() {
                                  widget.tokensListOpen = false;
                                });
                                widget.tokensListController.reverse();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              padding: EdgeInsets.all(8.0),
                              child: Icon(AppIcons.back,
                                  color:
                                      StateContainer.of(context).curTheme.text,
                                  size: 24)),
                        ),
                        //Contacts Header Text
                        Text(
                          AppLocalization.of(context).tokensListHeader,
                          style: AppStyles.textStyleSettingsHeader(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contacts list + top and bottom gradients
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Contacts list
                    ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 15.0, bottom: 15),
                      itemCount: _tokenRefs == null ? 0 : _tokenRefs.length,
                      itemBuilder: (context, index) {
                        // Build contact
                        return buildSingleToken(context, _tokenRefs[index]);
                      },
                    ),
                    //List Top Gradient End
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 20.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark,
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark00
                            ],
                            begin: AlignmentDirectional(0.5, -1.0),
                            end: AlignmentDirectional(0.5, 1.0),
                          ),
                        ),
                      ),
                    ),
                    //List Bottom Gradient End
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 15.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark00,
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark,
                            ],
                            begin: AlignmentDirectional(0.5, -1.0),
                            end: AlignmentDirectional(0.5, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSingleToken(BuildContext context, TokenRef tokenRef) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(children: <Widget>[
        Divider(
          height: 2,
          color: StateContainer.of(context).curTheme.text15,
        ),
        // Main Container
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          margin: new EdgeInsetsDirectional.only(start: 12.0, end: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 80,
                  margin: EdgeInsetsDirectional.only(start: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(tokenRef.token,
                          style: AppStyles.textStyleSettingItemHeader(context)),
                           Text(
                        AppLocalization.of(context).tokensListTotalSupply + NumberFormat.compact(locale: Localizations.localeOf(context)
                                    .languageCode).format(tokenRef.totalSupply),
                        style: TextStyle(
                          color: StateContainer.of(context).curTheme.primary60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        AppLocalization.of(context).tokensListCreatedThe +
                            DateFormat.yMd(Localizations.localeOf(context)
                                    .languageCode)
                                .add_Hms()
                                .format(tokenRef.creationDate)
                                .toString(),
                        style: TextStyle(
                          color: StateContainer.of(context).curTheme.primary60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        AppLocalization.of(context).tokensListCreatedBy + Address(tokenRef.creator).getShorterString(),
                        style: TextStyle(
                          color: StateContainer.of(context).curTheme.primary60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}