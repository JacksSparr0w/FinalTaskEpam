<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8" %>

<fmt:setLocale value="${sessionScope.language}"/>
<fmt:setBundle basename="textResources" var="textResources"/>

<fmt:message bundle="${textResources}" key="exist" var="existing"/>
<fmt:message bundle="${textResources}" key="new.theme" var="new.theme"/>
<fmt:message bundle="${textResources}" key="add" var="add"/>
<fmt:message bundle="${textResources}" key="add_theme" var="add_theme"/>
<fmt:message bundle="${textResources}" key="name" var="name"/>


<div class="container-fluid pb-5 pl-5 pr-5">
    <div class="row">
        <div class="col-8 m-2">
            <div class="container">
                <c:choose>
                    <c:when test="${done != null}">
                        <div class="container alert alert-success fade show m-t-16" theme="alert">
                            <fmt:message bundle="${textResources}" key="${done}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Click to remove"
                                    onclick="<c:remove var="done" scope="session"/>">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:when>
                    <c:when test="${error != null}">
                        <div class="container alert alert-warning fade show m-t-16" theme="alert">
                            <fmt:message bundle="${textResources}" key="${error}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"
                                    onclick="<c:remove var="error" scope="session"/>">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:when>
                </c:choose>
            </div>
            <strong class="d-inline-block mb-2 text-black">${add_theme}</strong>
            <form action="add_theme" method="post">
                <div class="row pt-3 pl-3 pr-3">
                    <div class="col-md-6">
                        <label for="theme">${name}</label>
                    </div>
                    <div class="col-md-6">
                        <input type="text" class="form-control" name="theme" id="theme" placeholder="${new.theme}">
                    </div>
                </div>
                <div class="justify-content-end">
                    <button type="submit" class="btn btn-outline-success mt-2"
                    >${add}
                    </button>
                </div>

            </form>
        </div>
        <div class="m-2">
            <strong class="d-inline-block mb-2 text-black">${existing}</strong>
            <c:forEach items="${existThemes}" var="_theme">
                <p>${_theme.value}</p>
            </c:forEach>
        </div>
    </div>
</div>
