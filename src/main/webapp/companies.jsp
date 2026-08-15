<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, java.util.List" %>
<%
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    request.setAttribute("pageTitle", "Companies Directory - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="page-hero">
    <div class="container">
        <div class="row align-items-end g-3">
            <div class="col-lg-7">
                <span class="page-eyebrow"><i class="bi bi-building"></i> Company reviews</span>
                <h1 class="fw-bold mb-2 mt-2">Find companies hiring on HireHub</h1>
                <p class="text-muted mb-0">Browse verified employers and open roles from the same live HireHub data.</p>
            </div>
            <div class="col-lg-5">
                <form action="${pageContext.request.contextPath}/companies" method="get" class="d-flex gap-2">
                    <input type="text" name="search" class="form-control" placeholder="Search company name" value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
                    <button type="submit" class="btn btn-primary px-4">Search</button>
                </form>
            </div>
        </div>
    </div>
</section>

<section class="py-4 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3 gap-2">
            <h5 class="fw-bold text-dark mb-0"><%= companies != null ? companies.size() : 0 %> companies found</h5>
            <a href="${pageContext.request.contextPath}/jobs" class="quick-search-link">Search jobs <i class="bi bi-arrow-right"></i></a>
        </div>

        <div class="row g-4">
            <% if (companies != null && !companies.isEmpty()) { 
                for (Company comp : companies) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 h-100 bg-white d-flex flex-column">
                            <div class="d-flex align-items-center mb-3">
                                <div class="stat-icon bg-light text-primary me-3 flex-shrink-0 fs-3" style="width:56px; height:56px;">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1"><%= comp.getCompanyName() %></h5>
                                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2 py-1"><i class="bi bi-patch-check-fill me-1"></i>Verified</span>
                                </div>
                            </div>

                            <p class="text-muted small mb-3 flex-grow-1"><%= comp.getDescription() != null && comp.getDescription().length() > 110 ? comp.getDescription().substring(0, 110) + "..." : comp.getDescription() %></p>

                            <div class="small text-muted mb-3">
                                <div class="mb-1"><i class="bi bi-tag me-2"></i><%= comp.getIndustry() %></div>
                                <div class="mb-1"><i class="bi bi-geo-alt me-2"></i><%= comp.getLocation() %></div>
                                <div><i class="bi bi-people me-2"></i><%= comp.getCompanySize() %> Employees</div>
                            </div>

                            <a href="${pageContext.request.contextPath}/company-details?id=<%= comp.getId() %>" class="btn btn-outline-primary w-100 mt-auto">View company jobs</a>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12">
                    <div class="card border-0 shadow-sm rounded-4 bg-white empty-state">
                        <div class="stat-icon bg-light text-muted mx-auto mb-3 fs-1">
                            <i class="bi bi-building"></i>
                        </div>
                        <h4 class="fw-bold text-dark">No companies found</h4>
                        <p class="text-muted mb-0">Try searching another company name.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
