<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        svg { background-color: lightskyblue; }
        svg .municipality {  fill: #eee; stroke: #999; }
        svg .municipality:hover { fill: orange;}
        svg text { font-size: 10px; }
    </style>
</head>
<body>
<input id="selected" type="hidden" value="">
<div id="chart"></div>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://d3js.org/topojson.v1.min.js"></script>
<script src="http://d3js.org/queue.v1.min.js"></script>
<script>
    var width = 960, height = 500;

    var svg = d3.select("#chart").append("svg")
            .attr("width", width)
            .attr("height", height);

    var projection = d3.geo.mercator()
            .center([128, 36])
            .scale(4000)
            .translate([width/2, height/2]);

    var path = d3.geo.path().projection(projection);

    var zoom = d3.behavior.zoom()
            .translate(projection.translate())
            .scale(projection.scale())
            //.scaleExtent([height, 8 * height])        // 최대 확대 제한
            .on("zoom", zoomed);

    var g = svg.append("g").call(zoom);

    var quantize = d3.scale.quantize()
            .domain([0, 1000])
            .range(d3.range(9).map(function(i) { return "p" + i; }));

    var popByName = d3.map();

    queue().defer(d3.json, "municipalities-topo-simple.json").await(ready);

    function ready(error, data) {
        if (error) throw error;

        var features = topojson.feature(data, data.objects["skorea_municipalities_geo"]).features;

//        features.forEach(function(d) {
//            d.properties.population = popByName.get(d.properties.name);
//            d.properties.density = d.properties.population / path.area(d);
//            d.properties.quantized = quantize(d.properties.density);
//        });

        g.selectAll("path")
                .data(features)
                .enter().append("path")
                .attr("class", function(d) { return "municipality "; })
                .attr("d", path)
                .attr("id", function(d) { return d.properties.name; })
                .on("click", clicked)
                .append("title")
                .text(function(d) { return d.properties.name });

//        svg.selectAll("text")
//                .data(features.filter(function(d) { return d.properties.name.endsWith("시"); }))
//                .enter().append("text")
//                .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; })
//                .attr("dy", ".35em")
//                .attr("class", "region-label")
//                .text(function(d) { return d.properties.name; });
    }

    function clicked(d) {
        if ($("#selected").val() == d.properties.code) {
            $("#selected").val("");
            projection.scale(4000);
        } else {
            $("#selected").val(d.properties.code);
            projection.scale(8000);
        }

        var centroid = path.centroid(d),
                translate = projection.translate();

        projection.translate([
            translate[0] - centroid[0] + width / 2,
            translate[1] - centroid[1] + height / 2
        ]);

        zoom.translate(projection.translate());

        g.selectAll("path")
                .transition()
                .duration(700)
                .attr("d", path);
    }

    function zoomed() {
        projection
                .translate(d3.event.translate)
                .scale(d3.event.scale);

        g.selectAll("path")
                .attr("d", path);
    }
</script>
</body>
</html>