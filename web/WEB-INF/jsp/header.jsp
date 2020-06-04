<%@page import="java.util.Collection"%>
<%@page import="org.springframework.security.core.GrantedAuthority"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Set"%>
<%@page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<% 
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String role = "ROLE_ANONYMOUS";
    
    Collection<GrantedAuthority> authorities = (Collection<GrantedAuthority>) authentication.getAuthorities();
    for (GrantedAuthority authority : authorities) {
        role = authority.getAuthority();
    }
    
    String username = authentication.getName();
    request.setAttribute("username", username);

    request.setAttribute("role", role);
%>

<nav class="navbar navbar-expand-lg shadow-sm navbar-light bg-light sticky-top justify-content-between" style="height: 60px; z-index: 100000">
    <a id="brand" class="navbar-brand" href="map.htm"><i class="fab fa-envira"></i> Wellness City</a>
    <div>
    <ul class="navbar-nav mr-auto">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/map.htm">Map</a>
        </li>
       
        <% if (role.equals("ROLE_ANONYMOUS")) { %>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/users/new">Collaboration</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/signin.htm">Sign in</a>
        </li>
      <% } else { %>
        <% if (role.equals("ROLE_ADMIN")) {%>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/moderation.htm">Moderation</a>
            </li>
        <% } else if (role.equals("ROLE_USER")) { %>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/mypoints.htm">My points</a>
            </li>
        <% } %>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/signout">Sign out</a>
        </li>
      <% } %>
    </ul>
        </div>
</nav>
