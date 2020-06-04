<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Point Editor</title>
        <jsp:include page="meta.jsp" />
        
         <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"
            integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
            crossorigin=""/>
        <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"
            integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew=="
            crossorigin=""></script>
            
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="d-flex justify-content-center">
            <span class="align-middle" style="margin-top: 30px; width: 450px;">
                
            <form:form id="form" method="POST" action="${pageContext.request.contextPath}/points/edit" commandName="point">
                    <table style="width: 100%">
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Name:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" path="name" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Type:</td>
                            <td>
                                <form:select cssStyle="margin-top: 20px;width: 100%; height: 30px" id="type" path="type">
                                    <form:option value="1">Waste recycling</form:option>
                                    <form:option value="2">Bicycle rental</form:option>
                                    <form:option value="3">Eco cafe</form:option>
                                </form:select>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Latitude:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" id="lat" path="lat" onchange="drawMarker()" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Longtitude:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" id="lng" path="lng" onchange="drawMarker()"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Address:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" id="address" path="address" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-middle" style="margin-right:10px;">Note:</td>
                            <td>
                                <!--form:textarea rows="5" path="note" cssStyle="width:100%" /!-->
                                <form:textarea cssStyle="margin-top: 20px;width: 100%; height: 200px" id="note" path="note" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="text-center">
                                <button type="submit" class="btn btn-light" style="margin-top: 20px; margin-left: auto;margin-right: auto; width: 100%; border: 1px solid grey" onclick="submit()">Submit</button>
                            </td>
                        </tr>
                    </table>
                <!--/form-->
                <form:input path="id" cssStyle="display:none"/>
                <form:input path="user.id" cssStyle="display:none"/>

                </form:form>

            </span>
            <div id="map" style="margin-left: 100px;width: 400px;height: 520px;margin-top: 50px; border: 1px solid grey"></div>
        </div>
    </body>
    
    <script>
        const LAT= 50.4500336;
        const LNG = 30.5241361; // kyiv center
        const ZOOM = 15;
        const SIZE = 48; // size of icons
        
        let map = L.map('map').setView([LAT, LNG], ZOOM), marker;

        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ, TomTom, Intermap, iPC, USGS, FAO, NPS, NRCAN, GeoBase, Kadaster NL, Ordnance Survey, Esri Japan, METI, Esri China (Hong Kong), and the GIS User Community'
        }).addTo(map);
        
        marker = L.marker(L.latLng(LAT, LNG), { draggable: true }).addTo(map);
        marker.on('drag', (e) => {
            $('#lat').val(e.latlng.lat);
            $('#lng').val(e.latlng.lng);
        });
                    
        drawMarker();
        
        function drawMarker() {
            const lat = parseFloat($('#lat').val());
            const lng = parseFloat($('#lng').val());
            if (lat && lng) {
                const latlng = L.latLng(lat, lng);
                marker.setLatLng(latlng);
                map.panTo(latlng);
            }
        }
    </script>
</html>
