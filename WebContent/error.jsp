<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% request.setAttribute("pageTitle", "An Error Occurred — HireHub"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container text-center py-5">
        <div class="glass-panel p-5 mx-auto" style="max-width: 580px;">
            <div class="company-avatar mx-auto mb-4" style="width:72px; height:72px; font-size:2rem; background: rgba(239, 68, 68, 0.12); color: var(--danger-color);">
                <i class="bi bi-exclamation-octagon-fill"></i>
            </div>
            <h2 class="fw-bold text-dark mb-2">Something Went Wrong</h2>
            <p class="text-muted mb-4">We encountered an unexpected issue processing your request. Please try again or return to the main dashboard.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4 py-2.5 fw-semibold shadow-md">
                <i class="bi bi-house me-1"></i>Back to Home
            </a>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
