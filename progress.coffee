# initialize angular module
app = angular.module('simpleApp', [])

# add directive which creates progress indicator and input fields``
app.directive('myProgress', ->
	restrict: 'E'
	template: """
		Actual: <input ng-model='actual' ng-change='change()' /><br/>
		Expected: <input ng-model='expected' ng-change='change()' />
		<br/><br/>
		<div id='progress-indicator'></div>
		""",
	link: (scope, element) ->	
		r1 = 56 # outer/actual indicator radius
		r2 = 50 # inner/expected indicator radius
		padding = 10
		points = 100 # to draw on the line - more is smoother but uses more CPU
		dimension = (2 * r1) + (2 * padding)
		
		# create the svg object
		svg = d3.selectAll("#progress-indicator").append("svg")
	    .attr("width", dimension)
	    .attr("height", dimension)
			.append("g")
			.attr("transform", "translate(" + (r1 + padding) + "," + (r1 + padding) + ")")
		
		# add elements to the svg obejct; circle, arc line, and progress text
		svg.append("circle")
	    .attr('cx', 0)
	    .attr('cy', 0)
	    .attr("r", 43.5)
	    .attr("class", "circ")
		a = svg.append("path").datum(d3.range(points))
			.attr("class", "line")
		b = svg.append("path").datum(d3.range(points))
			.attr("class", "sm-line")
		progress = svg.append("text")
			.attr("x", 10)
			.attr("y", 0)
			.attr("text-anchor", "end")
			.attr("font-size", "30px")
			.attr("fill", "#454545")
		svg.append("text")
			.attr("x", 10)
			.attr("y", 0)
			.attr("text-anchor", "start")
			.text("%")
			.attr("font-size", "18px")
			.attr("fill", "#454545")
		svg.append("text")
			.attr("x", 0)
			.attr("y", 15)
			.text("Progress")
			.attr("text-anchor", "middle")
			.attr("font-size", "12px")
			.attr("fill", "#898989")
		
		# custom tween function to draw the lines at each new step t
		lTween = (transition, newAngle, r) ->
			transition.attrTween("d", (d) ->
				interpolate = d3.interpolate(0, newAngle)
				(t) ->
					rads = interpolate(t)
					angleint = d3.scale.linear()
						.domain([0, points-1])
						.range([0, rads])
					bline = d3.svg.line.radial()
						.interpolate("basis")
						.tension(0)
						.radius(r)
						.angle((d, i) -> angleint(i))
					bline(d)
			)
		
		# update function redraws progress bars according to inputs
		#   inputs must be in the range [0,1]
		#   inputs: actual, expected
		update = (actual, expected) ->
			color = "#78C000" # green
			amt = actual/expected
			if amt <= 0.75 and amt > 0.5
				color = "#FFF799" # yellow
			else if amt <= 0.5
				color = "#FF8667" # red
			a.transition().duration(1000).call(lTween, actual*2*Math.PI, 56).style("stroke", color)
			b.transition().duration(1000).call(lTween, expected*2*Math.PI, 50)
			progress.text((actual*100).toFixed(0))

		# Set initial values
		scope.actual = 0.5
		scope.expected = 0.75
		scope.change = -> update(scope.actual, scope.expected)

		# draw initial values
		update(scope.actual, scope.expected)
)
