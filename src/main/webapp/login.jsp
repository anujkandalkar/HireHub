<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Login - HireHub Job Portal"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light auth-page">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white">
                    <div class="text-center mb-4">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-3 fs-3" style="width:64px; height:64px;">
                            <i class="bi bi-person-lock"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">Welcome Back</h3>
                        <p class="text-muted small">Sign in to access your HireHub account</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" class="form-control" placeholder="name@example.com" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" autocomplete="off" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label fw-semibold mb-0">Password</label>
                                <a href="#" class="small text-decoration-none text-primary">Forgot password?</a>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                                <input type="password" name="password" id="loginPassword" class="form-control" placeholder="Enter your password" autocomplete="new-password" required>
                                <button type="button" class="btn btn-outline-secondary" id="toggleLoginPassword" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-3 fw-bold fs-6 mb-3">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                        </button>

                        <div class="text-center text-muted small mt-3">
                            Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp" class="fw-bold text-primary text-decoration-none">Register Now</a>
                        </div>
                    </form>


                </div>
            </div>
        </div>
    </div>
</section>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var toggle = document.getElementById('toggleLoginPassword');
    var password = document.getElementById('loginPassword');
    if (!toggle || !password) return;

    toggle.addEventListener('click', function () {
        var isHidden = password.type === 'password';
        password.type = isHidden ? 'text' : 'password';
        toggle.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');
        toggle.innerHTML = isHidden ? '<i class="bi bi-eye-slash"></i>' : '<i class="bi bi-eye"></i>';
    });
});
</script>

<jsp:include page="/includes/footer.jsp" />
