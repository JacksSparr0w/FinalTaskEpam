<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8" %>

<fmt:setLocale value="${sessionScope.language}"/>
<fmt:setBundle basename="textResources" var="textResources"/>

<fmt:message bundle="${textResources}" key="user.date.birth" var="date_of_bitrh"/>
<fmt:message bundle="${textResources}" key="user.date.registration" var="date_of_registration"/>
<fmt:message bundle="${textResources}" key="user.delete" var="delete"/>
<fmt:message bundle="${textResources}" key="user.delete.sure" var="sure"/>
<fmt:message bundle="${textResources}" key="yes" var="yes"/>
<fmt:message bundle="${textResources}" key="no" var="no"/>


<c:choose>
    <c:when test="${done != null}">
        <div class="container alert alert-success fade show m-t-16" role="alert">
            <fmt:message bundle="${textResources}" key="${done}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Click to remove"
                    onclick="<c:remove var="done" scope="session"/>">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:when>
    <c:when test="${error != null}">
        <div class="container alert alert-warning fade show m-t-16" role="alert">
            <fmt:message bundle="${textResources}" key="${error}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"
                    onclick="<c:remove var="error" scope="session"/>">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:when>
</c:choose>

<div class="container-fluid pb-5 pl-5 pr-5">
    <c:forEach var="user" items="${users}">
        <c:set var="info" value="${users_info.get(user.id)}"/>
        <div class="container">
            <div class="card flex-md-row mb-4 box-shadow h-md-250">
                <div class="card-body d-flex flex-column align-items-start">
                    <strong class="d-inline-block mb-2 text-primary">${user.permission}</strong>
                    <div class="d-inline-block">
                        <strong class="d-inline-block mb-2 text-secondary">${user.login}</strong>
                        <c:if test="${user.id == sessionScope.user.userId}">
                            <strong class="rounded d-inline-block mb-2 text-white bg-success pr-2 pl-2">me</strong>
                        </c:if>
                    </div>
                    <div class="mb-1">
                        <h3 class="text-black">${info.name} ${info.surname}</h3>
                    </div>
                    <div class="mb-1 text-muted">
                        <h6 class="card-text mb-auto mb-2"><a href="mailto:${info.email}">${info.email}</a></h6>
                    </div>
                    <div class="mb-1 text-muted">
                            <label class="card-text mb-auto mb-2">${date_of_bitrh}: </label>
                            <fmt:formatDate value="${info.dateOfBirth}" pattern="yyyy-MM-dd"/>
                    </div>
                    <div class="mb-1 text-muted">
                            <label class="card-text mb-auto mb-2">${date_of_registration}: </label>
                            <fmt:formatDate value="${info.dateOfRegistration}" pattern="yyyy-MM-dd"/>
                    </div>
                    <p class="card-text mb-auto mb-2">${info.about}</p>
                    <div class="text-muted">
                        <form>
                            <c:url value="controller" var="deleteUrl">
                                <c:param name="command" value="delete_user"/>
                                <c:param name="userId" value="${user.id}"/>
                            </c:url>
                            <button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#exampleModal"
                                    >${delete}</button>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </c:forEach>
</div>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Warning!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ${sure}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">${no}</button>
                <button type="button" class="btn btn-primary" onclick="window.location.href='${deleteUrl}'">${yes}</button>
            </div>
        </div>
    </div>
</div>
