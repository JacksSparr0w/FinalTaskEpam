<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8" %>

<fmt:setLocale value="${sessionScope.language}"/>
<fmt:setBundle basename="textResources" var="textResources"/>

<fmt:message bundle="${textResources}" key="new_conferences" var="new_conferences"/>
<fmt:message bundle="${textResources}" key="event.register.success" var="successful_register_to_event"/>
<fmt:message bundle="${textResources}" key="event.join" var="join"/>
<fmt:message bundle="${textResources}" key="edit" var="edit"/>
<fmt:message bundle="${textResources}" key="user.delete" var="delete"/>
<fmt:message bundle="${textResources}" key="places_left" var="places_left"/>
<fmt:message bundle="${textResources}" key="join_now" var="join_now"/>
<fmt:message bundle="${textResources}" key="event.delete.sure" var="sure"/>
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
    <c:forEach var="event" items="${events}">
        <div class="container-fluid pt-3 pl-3 pr-3">
            <strong class="d-inline-block mb-2 ml-2 text-primary">${event.theme}</strong>
            <h3 class="text-black justify-content-center">${event.name}</h3>
            <h6 class="text-right"><fmt:formatDate value="${event.date}" pattern="yyyy-MM-dd HH:mm"/></h6>
            <div class="container">
                <img src="eventImages/${event.pictureLink}" class="rounded"
                     style="
                    width: inherit;
                    min-width: 15rem;
                    max-width: 75%;"
                     alt="Event picture">
            </div>
            <p class="text-dark text-right">${event.address}</p>

            <span class="text-black text-justify pt-2 pl-2 pr-2">${event.description}</span>
            <div class="w-75 pt-2 pl-2 pr-2">
                <div class="progress">
                    <c:set value="${event.capacity - filling.get(event.id)}" var="numberOfFreePlaces"/>
                    <div class="progress-bar bg-success align-content-center text-white"
                         style="height:25px; width:${(numberOfFreePlaces / event.capacity)*100}%">
                        <h6>${places_left}
                                ${numberOfFreePlaces}/${event.capacity}</h6>
                    </div>
                </div>
            </div>
            <c:if test="${user != null}">
                <p class="text-black">${join_now}</p>
                <div class="container pt-2 pl-2 pr-2 d-inline-flex">
                    <form>
                        <div class="d-inline-block">
                            <label for="selectRole">Register as: </label>
                            <select class="form-control" id="selectRole" name="role">
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.id}">${role.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <c:url value="controller" var="registerToEvent">
                            <c:param name="command" value="register_to_event"/>
                            <c:param name="eventId" value="${event.id}"/>
                        </c:url>
                        <input type="button" class="btn btn-outline-success" value="${join}"
                               onclick="window.location.href='${registerToEvent}'"/>
                    </form>
                    <!--
                        //todo permission
                    -->
                    <c:if test="${user.permission == 'ADMINISTRATOR' or user.userId == event.author_id}">
                        <form method="post">
                            <c:url value="edit_event_page" var="editEvent">
                                <c:param name="eventId" value="${event.id}"/>
                            </c:url>
                            <input type="button" class="btn btn-outline-warning ml-3" value="${edit}"
                                   onclick="window.location.href='${editEvent}'"/>
                        </form>
                        <form>
                            <c:url value="controller" var="deleteUrl">
                                <c:param name="command" value="remove_event"/>
                                <c:param name="eventId" value="${event.id}"/>
                            </c:url>
                            <button type="button" class="btn btn-outline-dark ml-3" data-toggle="modal"
                                    data-target="#exampleModal" onclick="window.location.href='${deleteUrl}'"
                            >${delete}</button>
                        </form>
                    </c:if>
                </div>
            </c:if>
            <hr>
            <br>
        </div>
    </c:forEach>
</div>
<c:if test="${showPages eq true}">
    <ul class="pagination justify-content-center p-b-10">
        <c:forEach var="i" begin="${1}" end="${countOfPages}">
            <c:choose>
                <c:when test="${i == page}">
                    <li class="page-item active"><a class="page-link" href="#!">${i}</a></li>
                </c:when>
                <c:otherwise>
                    <c:url value="all_events" var="homeUrl">
                        <c:param name="page" value="${i}"/>
                    </c:url>
                    <li class="page-item"><a class="page-link" href="${homeUrl}">${i}</a></li>

                </c:otherwise>
            </c:choose>
        </c:forEach>
    </ul>
</c:if>



