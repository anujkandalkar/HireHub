<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Reset Password - HireHub");
    String step = (String) request.getAttribute("step");
    if (step == null) step = "1";

    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) selectedRole = "STUDENT";

    String email = (String) request.getAttribute("email");
    if (email == null) email = "";

    String phone = (String) request.getAttribute("phone");
    if (phone == null) phone = "";

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light auth-page">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white">
                    <div class="text-center mb-4">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-3 fs-3" style="width:64px; height:64px;">
                            <i class="bi bi-shield-lock-fill"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">Reset Password</h3>
                        <p class="text-muted small">Enter your registered Gmail and Mobile Phone Number to verify your account</p>
                    </div>

                    <%-- Success Alert --%>
                    <% if (successMessage != null && !successMessage.isEmpty()) { %>
                        <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i><%= successMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>

                    <%-- Error Alert --%>
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>

                    <%-- Step Progress Bar --%>
                    <div class="d-flex align-items-center justify-content-center gap-3 mb-4 px-3">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge <%= "1".equals(step) ? "bg-primary" : "bg-success" %> rounded-circle p-2 fs-6 d-inline-flex align-items-center justify-content-center" style="width:32px; height:32px;">1</span>
                            <span class="small fw-bold <%= "1".equals(step) ? "text-primary" : "text-success" %>">Account Match</span>
                        </div>
                        <i class="bi bi-chevron-right text-muted small"></i>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge <%= "2".equals(step) ? "bg-primary" : "bg-secondary bg-opacity-25 text-dark" %> rounded-circle p-2 fs-6 d-inline-flex align-items-center justify-content-center" style="width:32px; height:32px;">2</span>
                            <span class="small fw-bold <%= "2".equals(step) ? "text-primary" : "text-muted" %>">New Password</span>
                        </div>
                    </div>

                    <%-- STEP 1: Enter Role + Gmail + Mobile Phone Number --%>
                    <% if ("1".equals(step)) { %>
                        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                            <input type="hidden" name="action" value="verify_match">

                            <!-- Account Type Selector -->
                            <div class="mb-3">
                                <label class="form-label fw-bold small text-muted text-uppercase mb-2">Select Account Type</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="roleStudent" value="STUDENT" <%= "STUDENT".equalsIgnoreCase(selectedRole) ? "checked" : "" %>>
                                        <label class="btn btn-outline-primary w-100 py-2.5 rounded-3 fw-bold small d-flex align-items-center justify-content-center gap-2" for="roleStudent">
                                            <i class="bi bi-person-bounding-box fs-6"></i> Candidate / Student
                                        </label>
                                    </div>
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="roleCompany" value="COMPANY" <%= "COMPANY".equalsIgnoreCase(selectedRole) ? "checked" : "" %>>
                                        <label class="btn btn-outline-primary w-100 py-2.5 rounded-3 fw-bold small d-flex align-items-center justify-content-center gap-2" for="roleCompany">
                                            <i class="bi bi-building fs-6"></i> Company / Employer
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Gmail / Email Field -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Registered Gmail / Email Address</label>
                                <div class="search-input-box">
                                    <i class="bi bi-envelope text-primary search-input-icon"></i>
                                    <input type="email" name="email" class="form-control" placeholder="name@gmail.com" value="<%= email %>" required autocomplete="off">
                                </div>
                            </div>

                            <!-- Mobile Phone Number Field -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Registered Mobile Phone Number</label>
                                <div class="search-input-box">
                                    <i class="bi bi-phone text-success search-input-icon"></i>
                                    <input type="tel" name="phone" class="form-control" placeholder="+91 9876543210 or 10-digit mobile" value="<%= phone %>" required autocomplete="off">
                                </div>
                            </div>

                            <button type="submit" class="btn search-btn-primary w-100 mb-3">
                                <i class="bi bi-shield-check me-2"></i>Verify Account & Continue
                            </button>
                        </form>
                    <% } %>

                    <%-- STEP 2: Set New Password --%>
                    <% if ("2".equals(step)) { %>
                        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                            <input type="hidden" name="action" value="reset_password">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">New Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-lock-fill text-primary"></i></span>
                                    <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="At least 6 characters" required autocomplete="new-password">
                                    <button type="button" class="btn btn-outline-secondary" id="toggleNewPass">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Confirm New Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-check-lg text-success"></i></span>
                                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Re-enter new password" required autocomplete="new-password">
                                </div>
                            </div>

                            <button type="submit" class="btn search-btn-primary w-100 mb-3">
                                <i class="bi bi-check-circle-fill me-2"></i>Update Password & Sign In
                            </button>

                            <div class="text-center pt-2">
                                <a href="${pageContext.request.contextPath}/forgot-password?action=reset" class="small text-muted text-decoration-none">
                                    <i class="bi bi-arrow-left me-1"></i>Re-enter Account Information
                                </a>
                            </div>
                        </form>
                    <% } %>

                    <div class="text-center text-muted small mt-4 pt-3 border-top">
                        Remember your password? <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold text-primary text-decoration-none">Back to Login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var togglePass = document.getElementById('toggleNewPass');
    var newPass = document.getElementById('newPassword');
    if (togglePass && newPass) {
        togglePass.addEventListener('click', function () {
            var isHidden = newPass.type === 'password';
            newPass.type = isHidden ? 'text' : 'password';
            togglePass.innerHTML = isHidden ? '<i class="bi bi-eye-slash"></i>' : '<i class="bi bi-eye"></i>';
        });
    }
});
</script>

<jsp:include page="/includes/footer.jsp" />
