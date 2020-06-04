<%@page import="db.table.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wellness City</title>
        <jsp:include page="meta.jsp" />
        
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"
            integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
            crossorigin=""/>
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"
            integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew=="
            crossorigin=""></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet.locatecontrol/dist/L.Control.Locate.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/leaflet.locatecontrol/dist/L.Control.Locate.min.js" charset="utf-8"></script>
        
        <script src="${pageContext.request.contextPath}/js/leaflet-providers.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/map.css">
    </head>
    
    <body>
        <jsp:include page="header.jsp" />
            <div id="map" style="width: 100%;height: 100%;position: absolute; top: 60px;"></div>

            <div id="details" class="shadow-sm bg-light" style="display: none;">
                <div class="card border-light" style="width: 100%;height: 100%">
                    <div class="card-body">
                        <h5 class="card-header">Name</h5>
                        <div style="padding: 20px">
                            <h5 class="card-title">Card title</h5>
                            <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                            <p id="cardlink"></p>
                         </div>
                        <button type="button" class="close" aria-label="Close" onclick="$('#details').hide()">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
            </div>
    </body>
    <script>
        const LAT= 50.4500336;
        const LNG = 30.5241361; // kyiv center
        const ZOOM = 15;
        const SIZE = 48; // size of icons
        const icons = {
            1: "wasteIcon.png",
            2: "bicycleIcon.png",
            3: "cafeIcon.png",
        }
        
        const wasteJson = [], bicyclesJson = [], cafesJson = [];
        const points = {1: wasteJson, 2: bicyclesJson, 3: cafesJson};
    
        $(function() {
            $('#map').height($('#map').height() - 60);
            $('#details').height($('#details').height() - 60);
            const mp = new MapProcessing();
        });

        class MapProcessing {
            constructor() {
                this.map = L.map('map').setView([LAT, LNG], ZOOM);
                this.geojsonLayer = new L.featureGroup();
                
                L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
                      attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ, TomTom, Intermap, iPC, USGS, FAO, NPS, NRCAN, GeoBase, Kadaster NL, Ordnance Survey, Esri Japan, METI, Esri China (Hong Kong), and the GIS User Community'
                }).addTo(this.map);

                L.control.locate({watch: true, icon: 'fa fa-map-marker filterIcon'}).addTo(this.map);
                
                
                fetch('${pageContext.request.contextPath}/points/getList', { method: 'POST' })
                    .then(response => response.json())
                    .then(json => {
                        for (let point of json) {
                            if (point.type === 1)
                                wasteJson.push(this.toJson(point));
                            else if (point.type === 2)
                                bicyclesJson.push(this.toJson(point));
                            else if (point.type === 3)
                                cafesJson.push(this.toJson(point));
                        }
                        
                        const waste = new L.geoJson(wasteJson, {
                            onEachFeature: this.onEachFeature
                        }).addTo(this.geojsonLayer);
                        const bicycles = new L.geoJson(bicyclesJson, {
                            onEachFeature: this.onEachFeature
                        }).addTo(this.geojsonLayer);
                        const cafes = new L.geoJson(cafesJson, {
                            onEachFeature: this.onEachFeature
                        }).addTo(this.geojsonLayer);
                        
                        this.geojsonLayer.addTo(this.map);
                        this.map.fitBounds(this.geojsonLayer.getBounds());
                        
                        L.control.layers({},{"Waste recycling": waste, "Bicycle rental": bicycles, "Eco cafe": cafes}, {position: 'topleft'}).addTo(this.map);
                    });
            }

            onEachFeature(feature, layer) {
                const props = feature.properties;
                let str = '<h6>' + props.name +'</h6>';
                str += '<p font-size="10px" class="font-weight-lighter">' + (props.type === 1 ? 'Waste recycling' : (props.type === 2 ? 'Bicycle rental' : 'Eco cafe')) +'</p>';

                if (props.title)
                  str += '<tr>' + props.title + '</td></tr>';

                str += '<a href="#" onclick="showDetails(' + feature.id +',' + props.type + ')">Details...</a>';
                
                if (props.images) {
                  str += '<p>';
                  for (let item of props.images) {
                    str += '<img class="cafe" src="${pageContext.request.contextPath}/css/images/' + item +'">';
                  }
                  str += '</p>';
                }

                layer.bindPopup(str);

                const icon = L.icon({iconUrl: "${pageContext.request.contextPath}/css/images/" + icons[props.type],
                      iconSize: [SIZE, SIZE], iconAnchor: [SIZE / 2, SIZE / 2], popupAnchor: [0, -SIZE / 2], shadowSize: [0, 0]});
                layer.setIcon(icon);
            }
            
            toJson(point) {
                return { "type":"Feature","geometry": {
                                "type":"Point",
                                "coordinates": [point.lng,point.lat]
                                },
                            "id": point.id,
                            "properties": point
                        };
            }
        }
        
        function showDetails(id, type) {
            const data = points[type];
            let point;
            for (item of data) {
                if (item["id"] == id) {
                    point = item;
                    break;
                }
            }
            if (!point) return;
            
            $('.card-header').text(point["properties"]["name"]);
            $('.card-title').text(point["properties"]["address"]);
            $('.card-text').html(point["properties"]["note"]);
            
            console.log(point);
            console.log('${role}');
            console.log('${username}');
            console.log(point["properties"].user.username);
            if ('${role}' === 'ROLE_ADMIN' || ('${role}' === 'ROLE_USER' && '${username}' === point["properties"].user.username))
                $('#cardlink').html('<a href="${pageContext.request.contextPath}/points/edit?id=' + point["id"] + '" class="card-link">Edit</a>');
            else
                $('#cardlink').html('');

            $('#details').show();
        }
        
     </script>
</html>
