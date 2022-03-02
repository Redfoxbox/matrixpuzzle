import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math';

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  bool isWinner(List<List<String>> matrix) {
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (matrix[i][z] == Player.none ||
            Player.decisions.contains(matrix[i][z])) {
          return false;
        }
      }
    }
    return true;
  }

  bool isEnd(List<List<String>> matrix) {
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (Player.decisions.contains(matrix[i][z])) {
          return false;
        }
      }
    }
    return true;
  }

  List<List<String>> setDirections(List<List<String>> matrix, step) {
    for (var x = 0; x < matrix.length; x++) {
      for (var y = 0; y < matrix.length; y++) {
        if (matrix[x][y] == step.toString()) {
          if (matrix.asMap().containsKey(x - 1) && matrix[x - 1][y] == "") {
            matrix[x - 1][y] = Player.up;
          }
          if (matrix.asMap().containsKey(x + 1) && matrix[x + 1][y] == "") {
            matrix[x + 1][y] = Player.down;
          }
          if (matrix.asMap().containsKey(y + 1) && matrix[x][y + 1] == "") {
            matrix[x][y + 1] = Player.right;
          }
          if (matrix.asMap().containsKey(y - 1) && matrix[x][y - 1] == "") {
            matrix[x][y - 1] = Player.left;
          }
        }
      }
    }
    return matrix;
  }

  List<List<String>> generateBarrier(List<List<String>> matrix, count) {
    Random rndx;
    Random rndy;
    int min = 0;
    int max = matrix.length;
    for (var i = 0; i < count; i++) {
      rndx = new Random();
      int x = min + rndx.nextInt(max - min);
      rndy = new Random();
      int y = min + rndy.nextInt(max - min);
      if (matrix[x][y] == Player.X) {
        i = i - 1;
      } else {
        matrix[x][y] = Player.X;
      }
    }

    return matrix;
  }

  List<List<String>> setRoad(List<List<String>> matrix, int x, int y, step) {
    matrix[x][y] = Player.O;
    var last = [0, 0];
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (matrix[i][z] == step.toString()) {
          last = [i, z];
        }
      }
    }
    //print(last);
    if (x < last[0]) {
      //print("UP");
      if (matrix.asMap().containsKey(x - 1) && matrix[x - 1][y] == "") {
        while (matrix.asMap().containsKey(x - 1) && matrix[x - 1][y] == "") {
          matrix[x - 1][y] = Player.O;
          last = [x - 1, y];
          x = x - 1;
        }
      } else {
        last = [x, y];
      }
    } else if (x > last[0]) {
      //print("DOWN");
      if (matrix.asMap().containsKey(x + 1) && matrix[x + 1][y] == "") {
        while (matrix.asMap().containsKey(x + 1) && matrix[x + 1][y] == "") {
          matrix[x + 1][y] = Player.O;
          last = [x + 1, y];
          x = x + 1;
        }
      } else {
        last = [x, y];
      }
    } else if (y > last[1]) {
      //print("RIGHT");
      if (matrix.asMap().containsKey(y + 1) && matrix[x][y + 1] == "") {
        while (matrix.asMap().containsKey(y + 1) && matrix[x][y + 1] == "") {
          matrix[x][y + 1] = Player.O;
          last = [x, y + 1];
          y = y + 1;
        }
      } else {
        last = [x, y];
      }
    } else if (y < last[1]) {
      //print("LEFT");
      if (matrix.asMap().containsKey(y - 1) && matrix[x][y - 1] == "") {
        while (matrix.asMap().containsKey(y - 1) && matrix[x][y - 1] == "") {
          matrix[x][y - 1] = Player.O;
          last = [x, y - 1];
          y = y - 1;
        }
      } else {
        last = [x, y];
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
    return matrix;
  }

  List<List<int>> getDirection(matrix) {
    List<List<int>> result = [];
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (Player.decisions.contains(matrix[i][z])) {
          result.add([i, z]);
        }
      }
    }
    return result;
  }

  bool solvable(matrix) {
    for (var i = 0; i < matrix.length; i++) {
      for (var z = 0; z < matrix.length; z++) {
        if (matrix[i][z] != Player.X) {}
      }
    }

    return false;
  }
}
