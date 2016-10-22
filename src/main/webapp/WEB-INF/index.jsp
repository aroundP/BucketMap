<!DOCTYPE html>
<meta charset="utf-8">
<style>
    svg {
        background-color: lightskyblue;
    }
    .municipality {
        fill: #eee;
        stroke: #999;
    }
    .municipality:hover {
        fill: orange;
    }
</style>
<body>
<script src="//d3js.org/d3.v3.min.js"></script>
<script src="//d3js.org/topojson.v1.min.js"></script>
<script src="http://d3js.org/topojson.v0.min.js"></script>
<script>

    var width = 960,
            height = 500;

    var projection = d3.geo.mercator()
            .center([128.0, 35.9])
            .scale(4000)
            .translate([width / 2, height / 2]);

    var path = d3.geo.path().projection(projection);

    var zoom = d3.behavior.zoom()
            .translate(projection.translate())
            .scale(projection.scale())
            .scaleExtent([height, 8 * height])
            .on("zoom", zoomed);

    var svg = d3.select("body").append("svg")
            .attr("width", width)
            .attr("height", height);

    var g = svg.append("g")
            .call(zoom);

    d3.json("skorea-municipalities-topo.json", function(error, kor) {
        if (error) throw error;

        var municipalities = topojson.object(kor, kor.objects['skorea-municipalities-geo']);
        g.selectAll('path').data(municipalities.geometries)
                .enter().append('path')
                .attr('d', path)
                .attr('class', 'municipality')
                .on("click", clicked);
    });

    function clicked(d) {
        var centroid = path.centroid(d),
                translate = projection.translate();

        projection.translate([
            translate[0] - centroid[0] + width / 2,
            translate[1] - centroid[1] + height / 2
        ]);

        zoom.translate(projection.translate());

        g.selectAll("path").transition()
                .duration(700)
                .attr("d", path);
    }

    function zoomed() {
        projection.translate(d3.event.translate).scale(d3.event.scale);
        g.selectAll("path").attr("d", path);
    }
</script>