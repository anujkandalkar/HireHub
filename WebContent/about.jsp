<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "About Us - HireHub Job Portal"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="badge bg-primary px-3 py-2 rounded-pill mb-3">About HireHub</span>
                <h1 class="fw-bold text-dark display-5 mb-4">Empowering Career Connections Across the World</h1>
                <p class="text-secondary leading-relaxed mb-4">
                    HireHub is a modern, enterprise-grade Job Portal & Recruitment Management System built on Java 17 Servlets, JDBC, and MySQL. Our platform bridges the gap between ambitious job seekers and verified companies through intelligent skill recommendation algorithms and streamlined recruitment workflows.
                </p>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 border">
                            <h4 class="fw-bold text-primary mb-1">100%</h4>
                            <p class="small text-muted mb-0">Verified Companies</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 border">
                            <h4 class="fw-bold text-success mb-1">Smart Match</h4>
                            <p class="small text-muted mb-0">Skill Compatibility Engine</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80" alt="About HireHub" class="img-fluid rounded-4 shadow-lg">
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
