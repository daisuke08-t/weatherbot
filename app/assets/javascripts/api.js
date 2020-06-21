function getweather() {
 
var url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010";
var json = UrlFetchApp.fetch(url).getContentText();
var jsonData = JSON.parse(json);

var date = jsonData["forecasts"][0]["date"];
var telop = jsonData["forecasts"][0]["telop"];
var icon = '=IMAGE("' + jsonData["forecasts"][0]["image"]["url"] + '")';

  console.log(date);
  console.log(telop);
  console.log(icon);
 
}