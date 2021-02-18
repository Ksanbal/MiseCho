import 'package:flutter/material.dart';
import 'package:circle_chart/circle_chart.dart';
import '../main.dart';

space_circle(double pm10, double pm2p5) {
  if (pm10 == null && pm2p5 == null) {
    return Column(
      children: [
        Text(
          '현재 상황',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Icon(
            Icons.cloud_off,
            color: Colors.white,
            size: 70,
          ),
        )
      ],
    );
  }

  return Column(
    children: [
      Text(
        '현재 상황',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: CircleChart(
                progressNumber: pm10,
                maxNumber: 160,
                width: 300,
                height: 220,
                progressColor: make_color('pm10', pm10),
                backgroundColor: Colors.white,
                rateTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  Text(
                    getPMGrade('pm10', pm10.toInt()),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '미세',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CircleChart(
                progressNumber: pm2p5,
                maxNumber: 80,
                width: 300,
                height: 220,
                progressColor: make_color('pm2p5', pm2p5),
                backgroundColor: Colors.white,
                rateTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  Text(
                    getPMGrade("pm2p5", pm2p5.toInt()),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '초미세',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getPMGrade(String type, int value) {
  String return_text;
  if (type == 'pm10') {
    if (value <= 15) {
      return_text = "최고";
    } else if (value <= 30) {
      return_text = "좋음";
    } else if (value <= 40) {
      return_text = "양호";
    } else if (value <= 50) {
      return_text = "보통";
    } else if (value <= 75) {
      return_text = "나쁨";
    } else if (value <= 100) {
      return_text = "상당히 나쁨";
    } else if (value <= 150) {
      return_text = "매우 나쁨";
    } else if (value > 150) {
      return_text = "최악";
    }
  } else if (type == 'pm2p5') {
    if (value <= 8) {
      return_text = "최고";
    } else if (value <= 15) {
      return_text = "좋음";
    } else if (value <= 20) {
      return_text = "양호";
    } else if (value <= 25) {
      return_text = "보통";
    } else if (value <= 37) {
      return_text = "나쁨";
    } else if (value <= 50) {
      return_text = "상당히 나쁨";
    } else if (value <= 75) {
      return_text = "매우 나쁨";
    } else if (value > 76) {
      return_text = "최악";
    }
  }
  return return_text;
}
