import './worldObject.dart';

class Country {
  String country_name;
  String flag_img;
  int cases;
  var casespermillion;
  var deathspermillion;
  var testspermillion;
  int new_cases;
  int deaths;
  int new_deaths;
  int recovered;
  int new_recoveries;
  int active;
  int id;

  Country({
    this.cases,
    this.id,
    this.country_name,
    this.flag_img,
    this.new_cases,
    this.deaths,
    this.new_deaths,
    this.recovered,
    this.new_recoveries,
    this.casespermillion,
    this.deathspermillion,
    this.testspermillion,
    this.active,
  });

  factory Country.fromJSON(Map<String, dynamic> json, int index) {
    return Country(
      country_name: countryName(json['country']),
      id: index,
      flag_img: json['countryInfo']['flag'],
      cases: json['cases'],
      deaths: json['deaths'],
      new_cases: json['todayCases'],
      new_deaths: json['todayDeaths'],
      new_recoveries: json['todayRecovered'],
      active: json['active'],
      recovered: json['recovered'],
      casespermillion: (json['casesPerOneMillion']),
      testspermillion: (json['testsPerOneMillion']),
      deathspermillion: (json['deathsPerOneMillion']),
      // casesData: tempCases,
      // deathsData: tempDeaths
    );
  }
}

String countryName(String initialName) {
  if (initialName == "USA") {
    return "United States";
  } else if (initialName == "UK") {
    return "United Kingdom";
  } else if (initialName == "S. Korea") {
    return "South Korea";
  } else if (initialName == "Libyan Arab Jamahiriya") {
    return "Libya";
  } else if (initialName == "Syrian Arab Republic") {
    return "Syria";
  } else {
    return initialName;
  }
}
