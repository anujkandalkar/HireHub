<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer-hirehub">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-4 col-md-6">
                <a class="navbar-brand d-flex align-items-center mb-2" href="${pageContext.request.contextPath}/">
                    <i class="bi bi-briefcase-fill text-primary fs-3 me-2"></i>
                    <span class="navbar-brand-logo fs-3">HireHub</span>
                </a>
                <p class="small text-white mb-3" style="color: #ffffff !important; opacity: 0.9;">
                    Connecting talented job seekers with verified companies worldwide. Build your professional profile, showcase skills, and land your dream job with HireHub.
                </p>
                <div class="d-flex gap-2">
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-github"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-bold mb-3">Job Seekers</h6>
                <a href="${pageContext.request.contextPath}/jobs" class="footer-link">Browse Jobs</a>
                <a href="${pageContext.request.contextPath}/jobs?sort=NEWEST" class="footer-link">Latest Postings</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="footer-link">Create Profile</a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Student Login</a>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-bold mb-3">Employers</h6>
                <a href="${pageContext.request.contextPath}/register.jsp" class="footer-link">Register Company</a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Recruiter Login</a>
                <a href="${pageContext.request.contextPath}/companies" class="footer-link">Top Companies</a>
                <a href="${pageContext.request.contextPath}/about.jsp" class="footer-link">Why HireHub</a>
            </div>
            <div class="col-lg-4 col-md-6">
                <h6 class="text-white fw-bold mb-3">Platform & Support</h6>
                <a href="${pageContext.request.contextPath}/about.jsp" class="footer-link">About HireHub</a>
                <a href="${pageContext.request.contextPath}/contact.jsp" class="footer-link">Contact Support</a>
                <a href="#" class="footer-link">Privacy Policy</a>
                <a href="#" class="footer-link">Terms & Conditions</a>
                <div class="mt-2 p-2 rounded bg-dark border border-secondary text-white small" style="color: #ffffff !important;">
                    <i class="bi bi-shield-check text-success me-1"></i> Admin Portal: Predefined single account access via main login page.
                </div>
            </div>
        </div>
        <hr class="my-3 border-light opacity-25">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small text-white" style="color: #ffffff !important;">
            <p class="mb-0">&copy; 2026 HireHub Recruitment Platform. All rights reserved.</p>
            <p class="mb-0">Built with Java Servlets, JDBC, MySQL 8 & Bootstrap 5</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
