import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';
import 'utils.dart';
import 'dart:math';

class AI {
  bool Solvable(List<List<String>> matrix) {
    matrix[0][0] = Player.none;
    matrix[0][1] = Player.none;
    matrix[0][2] = Player.none;
    matrix[1][0] = Player.none;
    matrix[1][1] = Player.none;
    matrix[1][2] = Player.none;
    matrix[2][0] = Player.none;
    matrix[2][1] = Player.none;
    matrix[2][2] = Player.none;
    var step = 1;
    List<List<Map<String, dynamic>>> road = [];
    List<int> stepxy = [0, 0];
    List<List<int>> route = [];
    List<List<int>> directions = [];

    //for (var x = 0; x < matrix.length; x++) {
    //for (var y = 0; y < matrix.length; y++) {
    var x = 0;
    var y = 0;

    if (matrix[x][y] != Player.X) {
      stepxy = [x, y];
      step = 1;
      matrix[x][y] = step.toString();
      route.add(stepxy);
      Utils().setDirections(matrix, step);
      directions = Utils().getDirection(matrix);
      var result =
          setPath(matrix, directions[0][0], directions[0][1], step, route);
      matrix = result[0];
      route = result[1];
      step++;
      Utils().setDirections(matrix, step);
      print(matrix);
      print("route");
      print(route);
    }

    //  }
    //}

    //route.add(step);
    //road.add(route);
    //print(road);
    return false;
  }

  List setPath(List<List<String>> matrix, int x, int y, step, route) {
    matrix[x][y] = Player.O;
    route.add([x, y]);
    var last = [0, 0];
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (matrix[i][z] == step.toString()) {
          last = [i, z];
        }
      }
    }
    if (x < last[0]) {
      print("UP");
      if (matrix.asMap().containsKey(x - 1) && matrix[x - 1][y] == "") {
        while (matrix.asMap().containsKey(x - 1) && matrix[x - 1][y] == "") {
          matrix[x - 1][y] = Player.O;
          last = [x - 1, y];
          route.add(last);
          x = x - 1;
        }
      } else {
        last = [x, y];
        route.add(last);
      }
    } else if (x > last[0]) {
      print("DOWN");
      if (matrix.asMap().containsKey(x + 1) && matrix[x + 1][y] == "") {
        while (matrix.asMap().containsKey(x + 1) && matrix[x + 1][y] == "") {
          matrix[x + 1][y] = Player.O;
          last = [x + 1, y];
          route.add(last);
          x = x + 1;
        }
      } else {
        last = [x, y];
        route.add(last);
      }
    } else if (y > last[1]) {
      print("RIGHT");
      if (matrix.asMap().containsKey(y + 1) && matrix[x][y + 1] == "") {
        while (matrix.asMap().containsKey(y + 1) && matrix[x][y + 1] == "") {
          matrix[x][y + 1] = Player.O;
          last = [x, y + 1];
          print(last);
          route.add(last);
          y = y + 1;
        }
      } else {
        last = [x, y];
        route.add(last);
      }
    } else if (y < last[1]) {
      print("LEFT");
      if (matrix.asMap().containsKey(y - 1) && matrix[x][y - 1] == "") {
        while (matrix.asMap().containsKey(y - 1) && matrix[x][y - 1] == "") {
          matrix[x][y - 1] = Player.O;
          last = [x, y - 1];
          route.add(last);
          y = y - 1;
        }
      } else {
        last = [x, y];
        route.add(last);
      }
    }
    //print(last.toString());
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (Player.decisions.contains(matrix[i][z])) {
          matrix[i][z] = Player.none;
        }
      }
    }
    step++;
    matrix[x][y] = step.toString();
    return [matrix, route];
  }
}
