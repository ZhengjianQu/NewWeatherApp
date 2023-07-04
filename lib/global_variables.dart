String apiKey = '8dab3e149329990d1d9456befa085601';
String publicApiKey = '8dab3e149329990d1d9456befa085601';


String weather = 'Clouds';
bool isCelsius = true;
String unitSymbol = "°C";
bool modifiable = true;

double latitude = 0.0;
double longitude = 0.0;

void setPosition(double lat, double lon){
  if(modifiable == true){
    latitude = lat;
    longitude = lon;
  }
}


String getBackgroundPath(){
  return "assets/images/Backgrounds/$weather.png";
}


final List groupMembers = [
  ['Zhengjian Qu', 'APP Developer', 'zhengjian.qu@ue-germany.de'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
];
