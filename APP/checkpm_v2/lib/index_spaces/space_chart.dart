import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

List<FlSpot> _pm10Spot = [];
List<FlSpot> _pm25Spot = [];
bool _isEmptyChart;

space_pmChart(pm10, pm2p5) {
  final pmchart_controller = new PageController();
  _pm10Spot = pm10;
  _pm25Spot = pm2p5;

  _isEmptyChart = (_pm10Spot.isNotEmpty) ? false : true;

  List<Widget> pm_items = [
    Column(
      children: [
        Text(
          "미세",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: AspectRatio(
            // aspectRatio: 1.23,
            aspectRatio: 2.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 37,
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            PM10Data(),
                            swapAnimationDuration:
                                const Duration(milliseconds: 250),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    Column(
      children: [
        Text(
          "초미세",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: AspectRatio(
            // aspectRatio: 1.23,
            aspectRatio: 2.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 37,
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            PM25Data(),
                            swapAnimationDuration:
                                const Duration(milliseconds: 250),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    )
  ];

  return Row(
    children: [
      Expanded(
        child: PageView(
          controller: pmchart_controller,
          scrollDirection: Axis.vertical,
          children: pm_items,
        ),
      ),
      Container(
        width: 10,
        child: ScrollingPageIndicator(
          dotColor: Colors.grey[400],
          dotSelectedColor: Colors.white,
          dotSize: 6,
          dotSelectedSize: 8,
          dotSpacing: 12,
          controller: pmchart_controller,
          itemCount: pm_items.length,
          orientation: Axis.vertical,
        ),
      ),
    ],
  );
}

// 차트 위젯
LineChartData PM10Data() {
  return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 6:
                return '3';
              case 12:
                return '6';
              case 18:
                return '9';
              case 24:
                return '12';
              case 30:
                return '15';
              case 36:
                return '18';
              case 42:
                return '21';
              case 48:
                return '24';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '최고';
              // case 15:
              //   return '좋음';
              // case 30:
              //   return '양호';
              case 40:
                return '보통';
              // case 50:
              //   return '나쁨';
              // case 75:
              // return '상당히\n나쁨';
              case 100:
                return '매우\n나쁨';
              case 150:
                return '최악';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 48,
      maxY: 160,
      minY: 0,
      lineBarsData: _isEmptyChart ? EmptyLinesBarData() : linesBarData1());
}

LineChartData PM25Data() {
  return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 6:
                return '3';
              case 12:
                return '6';
              case 18:
                return '9';
              case 24:
                return '12';
              case 30:
                return '15';
              case 36:
                return '18';
              case 42:
                return '21';
              case 48:
                return '24';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '최고';
              // case 10:
              //   return '좋음';
              // case 15:
              //   return '양호';
              case 20:
                return '보통';
              // case 25:
              //   return '나쁨';
              // case 35:
              //   return '상당히\n나쁨';
              case 50:
                return '매우\n나쁨';
              case 75:
                return '최악';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 48,
      maxY: 80,
      minY: 0,
      lineBarsData: _isEmptyChart ? EmptyLinesBarData() : linesBarData2());
}

// 빈 차트 데이터
List<LineChartBarData> EmptyLinesBarData() {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: [FlSpot(1, 114)],
    show: false,
    isCurved: true,
    colors: [
      const Color(0xffffce1f),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );

  return [
    lineChartBarData1,
  ];
}

// 실제 차트 데이터
List<LineChartBarData> linesBarData1() {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: _pm10Spot,
    isCurved: true,
    colors: [
      const Color(0xffffce1f),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: true, colors: [
      const Color(0x33ffce1f),
    ]),
  );

  return [lineChartBarData1];
}

List<LineChartBarData> linesBarData2() {
  final LineChartBarData lineChartBarData2 = LineChartBarData(
    spots: _pm25Spot,
    isCurved: true,
    colors: [
      const Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: true,
      colors: [
        const Color(0x33aa4cfc),
      ],
    ),
  );

  return [lineChartBarData2];
}
