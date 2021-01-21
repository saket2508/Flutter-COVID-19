import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/countryData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

Future<List<Country>> fetchData() async {
  final response =
      await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
  if (response.statusCode == 200) {
    List jsonTemp = json.decode(response.body);
    int index = 1;
    return jsonTemp.map((item) => new Country.fromJSON(item, index++)).toList();
  }
}

class _CountriesState extends State<Countries>
    with AutomaticKeepAliveClientMixin<Countries> {
  Future<List<Country>> _listcountries;
  var input = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    setState(() {
      _listcountries = fetchData();
    });
    super.initState();
  }

  onItemChanged(String value) {
    setState(() {
      input = value;
    });
  }

  Widget _searchBar() => Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: TextField(
          // autofocus: true,
          autocorrect: true,
          style: GoogleFonts.openSans(
              fontSize: 16, color: Theme.of(context).secondaryHeaderColor),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Search',
            // helperStyle: TextStyle(fontStyle: FontStyle.italic),
            prefixIcon: Icon(Icons.search,
                color: Theme.of(context).secondaryHeaderColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onChanged: onItemChanged,
        ),
      );

  Widget _countryTile(_country, f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        onTap: () {
          // print('card tapped');
          Navigator.pushNamed(context, '/country', arguments: _country);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        _country.flag_img,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _country.country_name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text('#' + _country.id.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      f.format(_country.cases),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    _country.new_cases > 0
                        ? Row(
                            children: [
                              Text(
                                '+',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                f.format(_country.new_cases),
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          )
                        : Row()
                  ],
                )
              ],
            ),
          ),
        ),
      ));

  Widget _countriesList(List<Country> _countries, refreshList, f) => Expanded(
          child: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView.builder(
          itemCount: _countries.length,
          itemBuilder: (context, index) {
            return _countryTile(_countries[index], f);
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var f = new NumberFormat("###,###", "en_US");
    // var brigthness = MediaQuery.of(context).platformBrightness;
    // bool darkMode = brigthness == Brightness.dark;
    return FutureBuilder<List<Country>>(
        future: _listcountries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Country> _countries = snapshot.data
                .where((e) =>
                    e.country_name.toLowerCase().contains(input.toLowerCase()))
                .toList();
            return Column(children: [
              _searchBar(),
              _countriesList(_countries, refreshList, f)
            ]);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<Null> refreshList() async {
    setState(() {
      _listcountries = fetchData();
    });
  }
}
