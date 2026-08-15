<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer-hirehub">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <a class="d-flex align-items-center gap-2 mb-3 text-decoration-none" href="${pageContext.request.contextPath}/">
                    <div class="company-avatar" style="width: 40px; height: 40px; font-size: 1.2rem; background: rgba(37,99,235,0.2); border-color: rgba(255,255,255,0.2);">
                        <i class="bi bi-briefcase-fill text-primary"></i>
                    </div>
                    <span class="navbar-brand-logo fs-3">HireHub</span>
                </a>
                <p class="small text-muted mb-3" style="color: #94a3b8 !important; max-width: 340px; line-height: 1.6;">
                    Connecting high-caliber talent with verified top companies worldwide. Build your professional candidate profile, match target skills, and land your ideal career role.
                </p>
                <div class="d-flex gap-2">
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width:36px; height:36px;"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width:36px; height:36px;"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width:36px; height:36px;"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width:36px; height:36px;"><i class="bi bi-github"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-bold mb-3"><i class="bi bi-person-workspace me-1 text-primary"></i>Job Seekers</h6>
                <a href="${pageContext.request.contextPath}/jobs" class="footer-link">Browse Jobs</a>
                <a href="${pageContext.request.contextPath}/jobs?sort=NEWEST" class="footer-link">Latest Postings</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="footer-link">Create Candidate Account</a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Candidate Sign In</a>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-bold mb-3"><i class="bi bi-building-gear me-1 text-info"></i>Employers</h6>
                <a href="${pageContext.request.contextPath}/register.jsp" class="footer-link">Register Company Profile</a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="footer-link">Recruiter Sign In</a>
                <a href="${pageContext.request.contextPath}/companies" class="footer-link">Verified Employers</a>
                <a href="${pageContext.request.contextPath}/about.jsp" class="footer-link">Why HireHub</a>
            </div>

            <div class="col-lg-4 col-md-6">
                <h6 class="text-white fw-bold mb-3"><i class="bi bi-shield-check me-1 text-success"></i>Platform Security</h6>
                <a href="${pageContext.request.contextPath}/about.jsp" class="footer-link">About HireHub Platform</a>
                <a href="${pageContext.request.contextPath}/contact.jsp" class="footer-link">Support & Assistance</a>
                
                <div class="mt-3 p-3 rounded-3 glass-card-dark border border-secondary border-opacity-25">
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <i class="bi bi-shield-lock-fill text-success fs-5"></i>
                        <span class="fw-bold text-white small">Verified Enterprise Operations</span>
                    </div>
                </div>
            </div>
        </div>

        <hr class="my-4 border-secondary opacity-25">

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small gap-2">
            <p class="mb-0 text-muted" style="color: #94a3b8 !important;">&copy; 2026 HireHub Global Recruitment Platform. All rights reserved.</p>
            <p class="mb-0 text-muted" style="color: #94a3b8 !important;">Professional SaaS Design & Architecture</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
