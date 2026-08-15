<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, com.hirehub.model.Job, java.util.List" %>
<%
    Company company = (Company) request.getAttribute("company");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", (company != null ? company.getCompanyName() : "Company Details") + " - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (company != null) { %>
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                <div class="d-flex flex-column flex-md-row align-items-md-center gap-4">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary fs-1 flex-shrink-0" style="width:80px; height:80px; border-radius:16px;">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <h2 class="fw-bold text-dark mb-0"><%= company.getCompanyName() %></h2>
                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1.5"><i class="bi bi-patch-check-fill me-1"></i>Approved Employer</span>
                        </div>
                        <p class="text-muted mb-2"><%= company.getIndustry() %> &bull; <%= company.getLocation() %> &bull; <%= company.getCompanySize() %> Employees</p>
                        <% if (company.getWebsite() != null) { %>
                            <a href="<%= company.getWebsite() %>" target="_blank" class="text-decoration-none small text-primary fw-semibold"><i class="bi bi-globe me-1"></i><%= company.getWebsite() %></a>
                        <% } %>
                    </div>
                </div>

                <hr class="my-4">

                <h5 class="fw-bold mb-3">About <%= company.getCompanyName() %></h5>
                <p class="text-secondary leading-relaxed mb-0"><%= company.getDescription() %></p>
            </div>

            <h4 class="fw-bold text-dark mb-3">Active Job Openings (<%= jobs != null ? jobs.size() : 0 %>)</h4>

            <div class="row g-4">
                <% if (jobs != null && !jobs.isEmpty()) { 
                    for (Job job : jobs) { %>
                        <div class="col-lg-4 col-md-6">
                            <div class="job-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="fw-bold mb-1"><a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="text-decoration-none text-dark"><%= job.getTitle() %></a></h5>
                                    <span class="badge bg-primary bg-opacity-10 text-primary job-badge-type"><%= job.getJobType().replace('_', ' ') %></span>
                                </div>
                                <div class="text-muted small mb-3"><i class="bi bi-geo-alt me-1"></i><%= job.getLocation() %></div>
                                <div class="mb-3">
                                    <% if (job.getRequiredSkills() != null) {
                                        String[] skills = job.getRequiredSkills().split("[,;]");
                                        for (int s = 0; s < Math.min(skills.length, 3); s++) { %>
                                            <span class="skill-tag"><%= skills[s].trim() %></span>
                                    <%  } 
                                       } %>
                                </div>
                                <div class="mt-auto d-flex justify-content-between align-items-center pt-3 border-top">
                                    <span class="text-success fw-bold small">$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %></span>
                                    <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="btn btn-sm btn-primary rounded-pill px-3">View Job</a>
                                </div>
                            </div>
                        </div>
                <%  }
                   } else { %>
                    <div class="col-12 text-center py-4">
                        <p class="text-muted">This company currently has no active job postings.</p>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
