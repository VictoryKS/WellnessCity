<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Collaboration</title>
        <jsp:include page="meta.jsp" />
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="d-flex justify-content-center">
            <span class="align-middle" style="margin-top: 50px; width: 430px;">
<!--                <c:if test="${not empty param.error}">
                        <div class="alert alert-block">
                            <h6 class="text-center">This username is already exist!</h6>
                        </div>                  
                </c:if>-->
                <c:if test="${empty param.error}">
                    <h3 class="text-center font-italic font-weight-normal" style="margin-bottom: 20px">Collaboration</h3>
                    <p class="font-italic text-center">Want to add information about your company and become a part of Welness City?<br> Just fill the form and we will contact with you in a few days!<p> 
                </c:if>
                <form:form  method="POST" action="${pageContext.request.contextPath}/users/new" commandName="user">
                    <table style="width: 100%">
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Full name:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" path="name" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Email:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" type="email" id="email" path="email" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;" >Username:</td>
                            <td>
                                <form:input cssStyle="margin-top: 20px;width: 100%" id="username" path="username" />
                            </td>
                        </tr>
                        <tr>
                            <td class="align-bottom" style="margin-right:10px;">Password:</td>
                            <td>
                                <form:password cssStyle="margin-top: 20px;width: 100%" id="password" path="password" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="text-center">
                                <button type="submit" class="btn btn-light border" style="margin-top: 20px; margin-left: auto;margin-right: auto; width: 100%">Sign up</button>
                            </td>
                        </tr>
                        <tr height="30px">
                        <tr>
                            <td colspan=2>
                                <p class="font-italic text-center">Already have an account? Click <a href="signin.htm">Sign in</a>!<p> 
                            </td>
                        </tr>
                    </table>
                </form:form>
            </span>
        </div>
    </body>
</html>
