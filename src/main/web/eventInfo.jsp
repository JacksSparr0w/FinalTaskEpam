<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8" %>

<fmt:setLocale value="${sessionScope.language}"/>
<fmt:setBundle basename="textResources" var="textResources"/>

<fmt:message bundle="${textResources}" key="new_conferences" var="new_conferences"/>
<fmt:message bundle="${textResources}" key="successful_register_to_event" var="successful_register_to_event"/>
<fmt:message bundle="${textResources}" key="join" var="join"/>
<fmt:message bundle="${textResources}" key="places_left" var="places_left"/>
<fmt:message bundle="${textResources}" key="join_now" var="join_now"/>


<c:if test="${requestScope.register_done eq true}">
    <div class="container alert alert-success fade show m-t-16" role="alert">
        ${successful_register_to_event}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>
<p class="text-right">${new_conferences}</p>
<hr>
<c:forEach var="event" items="${events}" varStatus="status">
    <div class="container-fluid pt-3 pl-3 pr-3">
        <h3 class="text-black">${event.name}</h3>
        <h6 class="text-right">${event.date}</h6>
        <div class="fakeimg rounded thumb text-center">conference image(optional)</div>
        <p class="text-dark text-right">${event.address}</p>

        <span class="text-black text-justify pt-2 pl-2 pr-2">${event.description}</span>
        <div class="w-75 pt-2 pl-2 pr-2">
            <div class="progress" style="height:15px">
                <div class="progress-bar bg-success" style="width:${(45 / event.capacity)*100}%">${places_left}
                    45/${event.capacity}</div>
            </div>
        </div>
        <c:if test="${user != null}">
            <div class="container pt-2 pl-2 pr-2">
                <p class="text-black">${join_now}</p>
                <form>
                    <c:url value="/controller?command=register_to_event" var="registerToEvent">
                        <c:param name="eventId" value="${event.id}"/>
                    </c:url>
                    <input type="button" class="btn btn-outline-success" value="${join}"
                           onclick="window.location.href='${registerToEvent}'"/>
                </form>
            </div>
        </c:if>
        <hr>
        <br>
    </div>
</c:forEach>


