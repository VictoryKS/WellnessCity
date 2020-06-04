<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign in</title>
        <jsp:include page="meta.jsp" />
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="d-flex justify-content-center">
            <span class="align-middle" style="margin-top: 70px; width: 300px;">
                <c:if test="${not empty param.error}">
                        <div class="alert alert-block">
                            <h4 class="text-center">Authentification failed!</h4>
                            <h6 class="text-center">Check again your password and username. <br>If everything is ok, your account has not been verified yet, wait for moderation.</h6>
                        </div>                  
                </c:if>
                <c:if test="${empty param.error}">
                    <h3 class="text-center font-italic font-weight-normal">Authentification</h3>
                </c:if>
                <form action="${pageContext.request.contextPath}/j_spring_security_check" method="POST" style="margin-top: 50px;">
                    <table style="margin-top: 20px;">
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Username:</td>
                            <td>
                                <input style="width: 100%" name="j_username" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Password:</td>
                            <td>
                                <input style="margin-top: 20px;width: 100%" type='password' name="j_password" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="text-center">
                                <input id="j_remember" name="_spring_security_remember_me" type="checkbox" checked="true" style="visibility: hidden"/>
                                <button type="submit" class="btn btn-light border" style="margin-top: 20px; margin-left: auto;margin-right: auto; width: 100%">Log in</button>
                            </td>
                        </tr>
                        <tr height="50px">
                        <tr>
                            <td colspan=2>
                                <p class="font-italic text-center">Don't have an account? Click <a href="${pageContext.request.contextPath}/collaboration.htm">Collaboration</a> and add your points to the map!<p> 
                            </td>
                        </tr>
                    </table>
                </form>
            </span>
        </div>
    </body>
</html>
