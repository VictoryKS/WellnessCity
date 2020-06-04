<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@page import="com.shels.manager.UsersManager"%>
<%@page import="com.shels.api.HomeController"%>
<%@page import="com.shels.table.Users"%>
<%@page import="com.shels.dao.UsersDAO"%>
<%@page import="com.shels.table.Geometries"%>
<%@page import="com.shels.dao.GeometriesDAO"%>
<%@page import="com.shels.dao.CartogramsDAO"%>
<%@page import="com.shels.table.Cartograms"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    session.setAttribute( "redirect", application.getContextPath() +"map/");
    pageContext.include( "properties.jsp");
    double x = 48.6, y = 31;

    if (request.getRemoteUser() != null) 
    {
        Users user = HomeController.itIs();
        session.setAttribute( "user", user);
        
        if (user != null) {
            if (user.getCreatorId() != null)
                session.setAttribute( "creator", user.getCreatorId());
            else
                session.setAttribute( "creator", user.getId());
            
            Geometries geo = new Geometries();
        
            if (user.getGeometryId() != null) {
                geo = GeometriesDAO.getInstance().get( Geometries.class, user.getGeometryId());
                
                if (geo != null) {
                    x = geo.getGeometry().getCentroid().getX();
                    y = geo.getGeometry().getCentroid().getY();
                }
            }
        }

        UsersManager um = new UsersManager();
        String owner = um.getCreatorName(user);
        session.setAttribute( "owner", owner);
    }

    int year = Calendar.getInstance().get(Calendar.YEAR);
    Date date = new Date();

    if (request.getParameter( "year") != null)
        year = Integer.parseInt( request.getParameter( "year"));
    
    if (request.getParameter( "date") != null)
    try{
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        date = dateFormat.parse( request.getParameter( "date"));
        Calendar c = Calendar.getInstance();
        c.setTime( date);
        year = c.get( Calendar.YEAR);
    }catch(Exception e){
        Logger.getLogger( this.getClass().getName()).log(Level.SEVERE, null, e);
    }    
    
    request.getSession().setAttribute( "year", year);
    request.getSession().setAttribute( "date", date.getTime());
    
    request.setAttribute( "x", x);
    request.setAttribute( "y", y);
    request.setAttribute( "z", 7);

    if (request.getParameter( "x") != null)
        request.setAttribute( "x", request.getParameter( "x").toString());

    if (request.getParameter( "y") != null)
        request.setAttribute( "y", request.getParameter( "y").toString());

    if (request.getParameter( "z") != null)
        request.setAttribute( "z", request.getParameter( "z").toString());

    request.setAttribute( "setview", (request.getParameter( "x") != null || request.getParameter( "y") != null || request.getParameter( "z") != null));
    
    List<Cartograms> cartograms = CartogramsDAO.getInstance().getList( 0, "zindex"); 
    session.setAttribute( "cartograms", cartograms);
    
    if (session.getAttribute( "language") != null) {
        String lng = (String) session.getAttribute( "language");
        request.setAttribute( "lng", lng.trim().toLowerCase());
    } else {
        request.setAttribute( "lng", "en");
    }        
%>--%>

<html>
    <head>
        <!-- START META -->
        <% pageContext.include( "meta.jsp"); %>
        <!-- END META -->
        <META name=keywords content="${keywords_maps}" >
        <META name=description content="${description_maps}" >
        <title>${title_maps}</title>
        <script src='https://api.mapbox.com/mapbox-gl-js/v1.10.1/mapbox-gl.js'></script>
        <link href='https://api.mapbox.com/mapbox-gl-js/v1.10.1/mapbox-gl.css' rel='stylesheet' />
    </head>

    <body>
        <div id='map' style='width: 1200px; height: 800px;'></div>
        <script>
            mapboxgl.accessToken = 'pk.eyJ1IjoidmljdG9yeWtzIiwiYSI6ImNrYW04Y2RqZDExdmQyeWp1b2Jhb2xzYjQifQ.Te0WLKmesxyXHNp1nDNrZw';
            var map = new mapboxgl.Map({
container: 'map',
style: 'mapbox://styles/mapbox/outdoors-v11',
center: [-121.403732, 40.492392],
zoom: 10
});
 map.addControl(new mapboxgl.NavigationControl());
 map.rotateTo(45);
map.on('load', function() {
map.addSource('national-park', {
'type': 'geojson',
'data': {
'type': 'FeatureCollection',
'features': [
{
'type': 'Feature',
'geometry': {
'type': 'Polygon',
'coordinates': [
[
[-121.353637, 40.584978],
[-121.284551, 40.584758],
[-121.275349, 40.541646],
[-121.246768, 40.541017],
[-121.251343, 40.423383],
[-121.32687, 40.423768],
[-121.360619, 40.43479],
[-121.363694, 40.409124],
[-121.439713, 40.409197],
[-121.439711, 40.423791],
[-121.572133, 40.423548],
[-121.577415, 40.550766],
[-121.539486, 40.558107],
[-121.520284, 40.572459],
[-121.487219, 40.550822],
[-121.446951, 40.56319],
[-121.370644, 40.563267],
[-121.353637, 40.584978]
]
]
}
},
{
'type': 'Feature',
'geometry': {
'type': 'Point',
'coordinates': [-121.415061, 40.506229]
}
},
{
'type': 'Feature',
'geometry': {
'type': 'Point',
'coordinates': [-121.505184, 40.488084]
}
},
{
'type': 'Feature',
'geometry': {
'type': 'Point',
'coordinates': [-121.354465, 40.488737]
}
}
]
}
});
 
map.addLayer({
'id': 'park-boundary',
'type': 'fill',
'source': 'national-park',
'paint': {
'fill-color': '#888888',
'fill-opacity': 0.4
},
'filter': ['==', '$type', 'Polygon']
});
 
map.addLayer({
'id': 'park-volcanoes',
'type': 'circle',
'source': 'national-park',
'paint': {
'circle-radius': 6,
'circle-color': '#B42222'
},
'filter': ['==', '$type', 'Point']
});
});
            
        </script>

    </body>
</html>
