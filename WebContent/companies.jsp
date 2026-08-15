<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, java.util.List" %>
<%
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    request.setAttribute("pageTitle", "Verified Companies Directory — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="page-hero">
    <div class="container">
        <div class="row align-items-center g-3">
            <div class="col-lg-7">
                <span class="page-eyebrow"><i class="bi bi-building"></i> Verified Employers</span>
                <h1 class="fw-bold text-dark mb-2 mt-1">Find top companies hiring on HireHub</h1>
                <p class="text-muted mb-0">Browse verified employers, explore company cultures, and view open positions.</p>
            </div>
            <div class="col-lg-5">
                <form action="${pageContext.request.contextPath}/companies" method="get" class="d-flex flex-column flex-sm-row gap-2">
                    <input type="text" name="search" class="form-control flex-grow-1" placeholder="Search company name..." value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
                    <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm" style="height: 48px; white-space: nowrap;">Search</button>
                </form>
            </div>
        </div>
    </div>
</section>

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
            <h5 class="fw-bold text-dark mb-0"><%= companies != null ? companies.size() : 0 %> verified companies listed</h5>
            <a href="${pageContext.request.contextPath}/jobs" class="quick-search-link text-primary fw-bold" style="background:transparent; border:none; padding:0;">Explore all job openings <i class="bi bi-arrow-right"></i></a>
        </div>

        <div class="row g-4">
            <% if (companies != null && !companies.isEmpty()) { 
                for (Company comp : companies) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="glass-card p-4 h-100 d-flex flex-column">
                            <div class="d-flex align-items-center mb-3">
                                <div class="company-avatar me-3" style="width:52px; height:52px; font-size:1.5rem;">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div class="overflow-hidden">
                                    <h5 class="fw-bold mb-1 text-truncate text-dark"><%= comp.getCompanyName() %></h5>
                                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2.5 py-1">
                                        <i class="bi bi-patch-check-fill me-1"></i>Verified Recruiter
                                    </span>
                                </div>
                            </div>

                            <p class="text-muted small mb-3 flex-grow-1" style="line-height: 1.6;"><%= comp.getDescription() != null && comp.getDescription().length() > 110 ? comp.getDescription().substring(0, 110) + "..." : comp.getDescription() %></p>

                            <div class="small text-muted mb-4 vstack gap-1">
                                <div><i class="bi bi-tag me-2 text-primary"></i><strong>Industry:</strong> <%= comp.getIndustry() %></div>
                                <div><i class="bi bi-geo-alt me-2 text-info"></i><strong>HQ:</strong> <%= comp.getLocation() %></div>
                                <div><i class="bi bi-people me-2 text-secondary"></i><strong>Size:</strong> <%= comp.getCompanySize() %> Employees</div>
                            </div>

                            <a href="${pageContext.request.contextPath}/company-details?id=<%= comp.getId() %>" class="btn btn-outline-primary w-100 mt-auto rounded-pill">
                                View Open Roles <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12">
                    <div class="glass-panel p-5 text-center empty-state">
                        <div class="stat-icon bg-light text-muted mx-auto mb-3 fs-1">
                            <i class="bi bi-building"></i>
                        </div>
                        <h4 class="fw-bold text-dark">No Companies Match Your Search</h4>
                        <p class="text-muted mb-0">Try searching for a different company name or industry keyword.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
