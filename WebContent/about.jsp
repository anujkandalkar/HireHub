<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "About Us — HireHub Job Portal"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="badge bg-primary px-3 py-2 rounded-pill mb-3">About HireHub</span>
                <h1 class="fw-bold text-dark display-5 mb-4">Empowering Career Connections Worldwide</h1>
                <p class="text-secondary leading-relaxed mb-4" style="line-height: 1.7; font-size: 1.05rem;">
                    HireHub is a modern recruitment portal and talent acquisition platform designed to connect candidates with verified companies. Our platform features an intelligent skill compatibility recommendation engine and an end-to-end applicant tracking workflow.
                </p>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="glass-card p-3">
                            <h4 class="fw-extrabold text-primary mb-1">100%</h4>
                            <p class="small text-muted mb-0 font-semibold">Verified Employers</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="glass-card p-3">
                            <h4 class="fw-extrabold text-success mb-1">Smart Engine</h4>
                            <p class="small text-muted mb-0 font-semibold">Skill Compatibility Match</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="glass-card p-2">
                    <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80" alt="About HireHub" class="img-fluid rounded-3 shadow-md" style="max-height: 380px; width: 100%; object-fit: cover;">
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
