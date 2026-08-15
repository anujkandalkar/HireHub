<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% request.setAttribute("pageTitle", "Error - HireHub"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container text-center py-5">
        <div class="stat-icon bg-danger bg-opacity-10 text-danger mx-auto mb-4 fs-1" style="width:80px; height:80px;">
            <i class="bi bi-exclamation-octagon-fill"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">Something Went Wrong</h2>
        <p class="text-muted mb-4 max-w-lg mx-auto">We encountered an unexpected issue processing your request. Please try again or return to the main dashboard.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">Back to Home</a>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
