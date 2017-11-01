/* Weather */
const json_url_now = 'meteo.php?chart=0';
const PRESSURE_multiplier = 0.000750061683;

const chart_list = [
	{"json_url": "meteo.php?chart=86400", "comment": "24 hours", charts: [
		{"title": 'Temperature. Last 24h', "hint": 'Temperature, C', "color": '#FF0000', "field": 'T', "date_format": 'HH:mm', "id": 'chartTemperature24h'},
		{"title": 'Pressure. Last 24h', "hint": 'Pressure, mmHg', "color": '#00FF00', "field": 'P', "date_format": 'HH:mm', "id": 'chartPressure24h'},
		{"title": 'Humidity. Last 24h', "hint": 'Humidity, %', "color": '#0000FF', "field": 'H', "date_format": 'HH:mm', "id": 'chartHumidity24h'}
	]},
	{"json_url": "meteo.php?chart=259200", "comment": "3 days", charts: [
		{"title": 'Temperature. Last 3 days', "hint": 'Temperature, C', "color": '#FF0000', "field": 'T', "date_format": 'dd.MM.yyyy', "id": 'chartTemperature3d'},
		{"title": 'Pressure. Last 3 days', "hint": 'Pressure, mmHg', "color": '#00FF00', "field": 'P', "date_format": 'dd.MM.yyyy', "id": 'chartPressure3d'},
		{"title": 'Humidity. Last 3 days', "hint": 'Humidity, %', "color": '#0000FF', "field": 'H', "date_format": 'dd.MM.yyyy', "id": 'chartHumidity3d'}
	]},
	{"json_url": "meteo.php?chart=604800", "comment": "7 days", charts: [
		{"title": 'Temperature. Last week', "hint": 'Temperature, C', "color": '#FF0000', "field": 'T', "date_format": 'dd.MM.yyyy', "id": 'chartTemperature7d'},
		{"title": 'Pressure. Last week', "hint": 'Pressure, mmHg', "color": '#00FF00', "field": 'P', "date_format": 'dd.MM.yyyy', "id": 'chartPressure7d'},
		{"title": 'Humidity. Last week', "hint": 'Humidity, %', "color": '#0000FF', "field": 'H', "date_format": 'dd.MM.yyyy', "id": 'chartHumidity7d'}
	]}	
 ];

 // Load json file
function loadJSON(json_url, callback) {
    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', json_url, true);
    xobj.onreadystatechange = function () {
          if (xobj.readyState == 4 && xobj.status == "200") {
            callback(xobj.responseText);
          }
    };
    xobj.send(null);
}

// Refresh current weather data
function refresh_info() {
	loadJSON(json_url_now, function(response) {
    	var json_obj = JSON.parse(response);
		document.getElementById("date").innerHTML = dateFormat(new Date(json_obj.data[0].D*1000),"ddd mmm dd yyyy HH:MM:ss");
		document.getElementById("temperature").innerHTML = json_obj.data[0].T;
		document.getElementById("pressure").innerHTML = Math.round(json_obj.data[0].P * PRESSURE_multiplier);
		document.getElementById("humidity").innerHTML = Math.round(json_obj.data[0].H);
	});
          
	clearTimeout(timerID);
	timerID = setTimeout("refresh_info()",60000);
}

// Draw a chart
function drawWeatherChart(dataObj, сartTitle, axisTitle, axisColors, dataField, dateFormat, divID) {
	var data = new google.visualization.DataTable();
	data.addColumn('datetime', 'X');
	data.addColumn('number', axisTitle);

	for (var i = 0; i < dataObj.data.length; i++) {
		data.addRows([[new Date(dataObj.data[i].D*1000), dataObj.data[i][dataField]]]);
	}

	var options = {
		title: сartTitle,
		chartArea:{left:"50",top:"40", right:"10"},
        hAxis: {
          //format: 'dd.MM.yyyy hh:mm',
          format: dateFormat,
          //title: 'Time',
          logScale: false,
          textStyle: {fontSize: 10},
          slantedText: true, slantedTextAngle: 30
        },
        vAxis: {
          //title: axisTitle,
          logScale: false,
          textStyle: {fontSize: 10}
        },
        colors: axisColors,
        width: ($(window).width()*0.95 > 800)?800: $(window).width()*0.95,
	height: 250,
        legend: {position: 'none'}
	};

	var chart = new google.visualization.LineChart(document.getElementById(divID));
	chart.draw(data, options);
}

// convert to mm Hg
function convertPresshureToMMHG(dataObj) {
	for (var i = 0; i < dataObj.data.length; i++) {
		dataObj.data[i].P = dataObj.data[i].P * PRESSURE_multiplier;
	}
}

// Load data and draw all charts
function drawAllCharts() {
	chart_list.forEach(function(json) {
		loadJSON(json.json_url, function(response) {
			var chart_data = JSON.parse(response);
			convertPresshureToMMHG(chart_data);
			json.charts.forEach(function(chart) {
				drawWeatherChart(chart_data, chart.title, chart.hint, [chart.color], chart.field, chart.date_format, chart.id);
			});
		});
	}, this);
}

// Start a Timer
var timerID = setTimeout("refresh_info()",100);

google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawAllCharts);
$( window ).resize(drawAllCharts);
