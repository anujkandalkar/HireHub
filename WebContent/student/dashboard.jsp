<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, com.hirehub.model.Job, com.hirehub.model.Application, java.util.List" %>
<%
    Student student = (Student) session.getAttribute("studentProfile");
    List<Job> recommendedJobs = (List<Job>) request.getAttribute("recommendedJobs");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "Student Dashboard — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-4 bg-light">
    <div class="container">
        <!-- Welcome Hero Glass Banner -->
        <div class="glass-card p-4 p-md-5 mb-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="company-avatar" style="width: 56px; height: 56px; font-size: 1.6rem;">
                        <i class="bi bi-person-circle"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold text-dark mb-1">Welcome back, <%= student != null ? student.getFullName() : "Candidate" %>! 👋</h3>
                        <p class="text-muted mb-0"><i class="bi bi-mortarboard me-1 text-primary"></i><%= student != null && student.getCollegeName() != null ? student.getCollegeName() : "Job Seeker" %></p>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="text-end">
                        <span class="small text-muted d-block font-semibold">Profile Completion</span>
                        <span class="fw-bold text-primary fs-5"><%= student != null ? student.getProfileCompletionPercentage() : 20 %>%</span>
                    </div>
                    <div class="progress rounded-pill" style="width: 120px; height: 10px; background-color: #e2e8f0;">
                        <div class="progress-bar bg-primary rounded-pill" role="progressbar" style="width: <%= student != null ? student.getProfileCompletionPercentage() : 20 %>%;"></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                        <i class="bi bi-pencil-square me-1"></i>Edit Profile
                    </a>
                </div>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-file-earmark-check"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalApps") != null ? request.getAttribute("totalApps") : 0 %></div>
                    <div class="stat-label">Total Applications</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto mb-2"><i class="bi bi-hourglass-split"></i></div>
                    <div class="stat-value"><%= request.getAttribute("pendingApps") != null ? request.getAttribute("pendingApps") : 0 %></div>
                    <div class="stat-label">Pending Review</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto mb-2"><i class="bi bi-star"></i></div>
                    <div class="stat-value"><%= request.getAttribute("shortlistedApps") != null ? request.getAttribute("shortlistedApps") : 0 %></div>
                    <div class="stat-label">Shortlisted</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-trophy"></i></div>
                    <div class="stat-value"><%= request.getAttribute("selectedApps") != null ? request.getAttribute("selectedApps") : 0 %></div>
                    <div class="stat-label">Selected</div>
                </div>
            </div>
        </div>

        <!-- Recommended Jobs for Candidate -->
        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0"><i class="bi bi-lightning-charge-fill text-warning me-2"></i>Recommended Opportunities</h5>
                <a href="${pageContext.request.contextPath}/jobs" class="small text-primary fw-semibold text-decoration-none">Explore All Jobs &rarr;</a>
            </div>

            <div class="row g-4">
                <% if (recommendedJobs != null && !recommendedJobs.isEmpty()) { 
                    for (int i = 0; i < Math.min(recommendedJobs.size(), 3); i++) { 
                        Job j = recommendedJobs.get(i); %>
                        <div class="col-md-4">
                            <div class="job-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h6 class="fw-bold mb-1"><a href="${pageContext.request.contextPath}/job-details?id=<%= j.getId() %>" class="job-title-link"><%= j.getTitle() %></a></h6>
                                    <% if (j.getMatchPercentage() > 0) { %>
                                        <span class="match-badge"><%= j.getMatchPercentage() %>% Match</span>
                                    <% } %>
                                </div>
                                <div class="text-muted small mb-2"><i class="bi bi-building me-1"></i><%= j.getCompanyName() %> &bull; <%= j.getLocation() %></div>
                                <div class="mb-3 flex-grow-1">
                                    <% if (j.getRequiredSkills() != null) {
                                        String[] skills = j.getRequiredSkills().split("[,;]");
                                        for (int s = 0; s < Math.min(skills.length, 3); s++) { %>
                                            <span class="skill-tag"><%= skills[s].trim() %></span>
                                    <%  } 
                                       } %>
                                </div>
                                <div class="mt-auto pt-2 border-top d-flex justify-content-between align-items-center">
                                    <span class="job-pay small">$<%= (int)j.getSalaryMin() %> - $<%= (int)j.getSalaryMax() %></span>
                                    <a href="${pageContext.request.contextPath}/job-details?id=<%= j.getId() %>" class="btn btn-sm btn-primary rounded-pill px-3">Apply Now</a>
                                </div>
                            </div>
                        </div>
                <%  }
                   } else { %>
                    <div class="col-12 text-center py-4">
                        <div class="glass-panel p-4">
                            <p class="text-muted mb-0">Complete your skills profile to unlock smart job recommendations.</p>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
