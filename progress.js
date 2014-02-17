// Generated by CoffeeScript 1.7.1
(function() {
  var app;

  app = angular.module('simpleApp', []);

  app.directive('myProgress', function() {
    return {
      restrict: 'E',
      template: "Actual: <input ng-model='actual' ng-change='change()' /><br/>\nExpected: <input ng-model='expected' ng-change='change()' />\n<br/><br/>\n<div id='progress-indicator'></div>",
      link: function(scope, element) {
        var a, b, dimension, lTween, padding, points, progress, r1, r2, svg, update;
        r1 = 56;
        r2 = 50;
        padding = 10;
        points = 100;
        dimension = (2 * r1) + (2 * padding);
        svg = d3.selectAll("#progress-indicator").append("svg").attr("width", dimension).attr("height", dimension).append("g").attr("transform", "translate(" + (r1 + padding) + "," + (r1 + padding) + ")");
        svg.append("circle").attr('cx', 0).attr('cy', 0).attr("r", 43.5).attr("class", "circ");
        a = svg.append("path").datum(d3.range(points)).attr("class", "line");
        b = svg.append("path").datum(d3.range(points)).attr("class", "sm-line");
        progress = svg.append("text").attr("x", 10).attr("y", 0).attr("text-anchor", "end").attr("font-size", "30px").attr("fill", "#454545");
        svg.append("text").attr("x", 10).attr("y", 0).attr("text-anchor", "start").text("%").attr("font-size", "18px").attr("fill", "#454545");
        svg.append("text").attr("x", 0).attr("y", 15).text("Progress").attr("text-anchor", "middle").attr("font-size", "12px").attr("fill", "#898989");
        lTween = function(transition, newAngle, r) {
          return transition.attrTween("d", function(d) {
            var interpolate;
            interpolate = d3.interpolate(0, newAngle);
            return function(t) {
              var angleint, bline, rads;
              rads = interpolate(t);
              angleint = d3.scale.linear().domain([0, points - 1]).range([0, rads]);
              bline = d3.svg.line.radial().interpolate("basis").tension(0).radius(r).angle(function(d, i) {
                return angleint(i);
              });
              return bline(d);
            };
          });
        };
        update = function(actual, expected) {
          var amt, color;
          color = "#78C000";
          amt = actual / expected;
          if (amt <= 0.75 && amt > 0.5) {
            color = "#FFF799";
          } else if (amt <= 0.5) {
            color = "#FF8667";
          }
          a.transition().duration(1000).call(lTween, actual * 2 * Math.PI, 56).style("stroke", color);
          b.transition().duration(1000).call(lTween, expected * 2 * Math.PI, 50);
          return progress.text((actual * 100).toFixed(0));
        };
        scope.actual = 0.5;
        scope.expected = 0.75;
        scope.change = function() {
          return update(scope.actual, scope.expected);
        };
        return update(scope.actual, scope.expected);
      }
    };
  });

}).call(this);
