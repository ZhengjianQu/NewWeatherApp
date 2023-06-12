String apiKey = '8dab3e149329990d1d9456befa085601';
String weather = 'Clear';
String units = "metric";
String unitSymbol = "°C";
double latitude = 0.0;
double longitude = 0.0;
String location = "";

void setPosition(double lat,double lon){
  latitude = lat;
  longitude = lon;
}

String getBackgroundPath(){
  return "assets/images/Background/$weather.png";
}