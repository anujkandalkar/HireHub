<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, com.hirehub.model.Company, com.hirehub.model.User" %>
<%
    Job job = (Job) request.getAttribute("job");
    Company company = (Company) request.getAttribute("company");
    Boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
    Integer matchPct = (Integer) request.getAttribute("matchPct");
    User loggedInUser = (User) session.getAttribute("user");
    request.setAttribute("pageTitle", (job != null ? job.getTitle() : "Job Details") + " — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (job != null) { %>
            <div class="row g-4">
                <!-- Main Job Details Column -->
                <div class="col-lg-8">
                    <div class="glass-card p-4 p-md-5 mb-4">
                        <!-- Job Header -->
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-start mb-4 gap-3">
                            <div class="d-flex gap-3 align-items-start">
                                <div class="company-avatar" style="width: 56px; height: 56px; font-size: 1.6rem;">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div>
                                    <span class="job-badge-type mb-2 d-inline-block"><%= job.getJobType().replace('_', ' ') %></span>
                                    <h2 class="fw-bold text-dark mb-1"><%= job.getTitle() %></h2>
                                    <h5 class="text-primary mb-2"><i class="bi bi-building me-2"></i><%= job.getCompanyName() %></h5>
                                    <div class="text-muted small vstack gap-1 gap-md-0 flex-md-row">
                                        <span class="me-md-3"><i class="bi bi-geo-alt me-1 text-primary"></i><%= job.getLocation() %></span>
                                        <span class="me-md-3"><i class="bi bi-briefcase me-1 text-secondary"></i><%= job.getExperienceYears() %> experience</span>
                                        <span><i class="bi bi-clock me-1 text-muted"></i>Posted <%= job.getCreatedAt() %></span>
                                    </div>
                                </div>
                            </div>

                            <% if (matchPct != null && matchPct > 0) { %>
                                <div class="text-md-end flex-shrink-0">
                                    <div class="match-badge fs-6 py-2 px-3">
                                        <i class="bi bi-lightning-charge-fill me-1"></i><%= matchPct %>% Skill Match
                                    </div>
                                    <div class="small text-muted mt-1">Calculated from your skills</div>
                                </div>
                            <% } %>
                        </div>

                        <hr class="my-4 border-secondary opacity-25">

                        <!-- Salary & Deadline Quick Summary Card -->
                        <div class="p-3 glass-panel rounded-3 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                            <div>
                                <span class="text-muted small d-block">Compensation Package</span>
                                <span class="fw-extrabold fs-3 text-success">$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %> <small class="text-muted fs-6 font-normal">/ year</small></span>
                            </div>
                            <% if (job.getDeadline() != null) { %>
                                <div>
                                    <span class="text-muted small d-block">Application Deadline</span>
                                    <span class="fw-bold text-dark fs-6"><i class="bi bi-calendar-event text-danger me-1"></i><%= job.getDeadline() %></span>
                                </div>
                            <% } %>
                        </div>

                        <!-- Job Description -->
                        <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-file-text me-2 text-primary"></i>Job Overview</h5>
                        <p class="text-secondary leading-relaxed mb-4" style="line-height: 1.7; font-size: 1rem;"><%= job.getDescription() %></p>

                        <% if (job.getResponsibilities() != null && !job.getResponsibilities().isEmpty()) { %>
                            <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-check2-circle me-2 text-success"></i>Responsibilities</h5>
                            <p class="text-secondary leading-relaxed mb-4" style="line-height: 1.7; font-size: 1rem;"><%= job.getResponsibilities() %></p>
                        <% } %>

                        <% if (job.getRequirements() != null && !job.getRequirements().isEmpty()) { %>
                            <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-list-task me-2 text-info"></i>Requirements</h5>
                            <p class="text-secondary leading-relaxed mb-4" style="line-height: 1.7; font-size: 1rem;"><%= job.getRequirements() %></p>
                        <% } %>

                        <!-- Required Skills Chips -->
                        <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-stars me-2 text-warning"></i>Required Skills & Competencies</h5>
                        <div class="mb-4">
                            <% if (job.getRequiredSkills() != null) {
                                String[] skills = job.getRequiredSkills().split("[,;]");
                                for (String s : skills) { %>
                                    <span class="badge bg-light text-dark border px-3 py-2 me-2 mb-2 fs-6 shadow-sm"><i class="bi bi-code-slash text-primary me-1"></i><%= s.trim() %></span>
                            <%  } 
                               } %>
                        </div>
                    </div>
                </div>

                <!-- Sticky Sidebar Application Panel -->
                <aside class="col-lg-4">
                    <div class="glass-card p-4 sticky-lg-top" style="top: 90px; z-index: 10;">
                        <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-send me-2 text-primary"></i>Apply For Position</h5>

                        <% if (loggedInUser == null) { %>
                            <div class="alert alert-warning mb-3 small glass-card border-warning border-opacity-25">
                                <i class="bi bi-exclamation-circle me-1"></i> Log in as a Candidate/Student to submit your application.
                            </div>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary w-100 rounded-pill py-2.5 fw-bold shadow-md">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Login to Apply
                            </a>
                        <% } else if ("STUDENT".equalsIgnoreCase(loggedInUser.getRole())) { %>
                            <% if (hasApplied != null && hasApplied) { %>
                                <button class="btn btn-success w-100 rounded-pill py-2.5 fw-bold mb-2 shadow-sm" disabled>
                                    <i class="bi bi-check-circle-fill me-2"></i>Application Submitted
                                </button>
                                <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-primary w-100 rounded-pill py-2">
                                    <i class="bi bi-kanban me-1"></i>Track Application Status
                                </a>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/apply-job" method="post">
                                    <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-3 fw-bold fs-6 shadow-glow">
                                        <i class="bi bi-send-fill me-2"></i>Submit Application
                                    </button>
                                </form>
                            <% } %>
                        <% } else { %>
                            <div class="alert alert-info mb-0 small glass-card border-info border-opacity-25">
                                <i class="bi bi-info-circle me-1"></i> Logged in as <strong><%= loggedInUser.getRole() %></strong>. Job applications can only be submitted by Candidate accounts.
                            </div>
                        <% } %>

                        <% if (company != null) { %>
                            <hr class="my-4 border-secondary opacity-25">
                            <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-building me-2 text-primary"></i>Company Information</h6>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <div class="company-avatar" style="width: 38px; height: 38px; font-size: 1rem;">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div class="fw-bold text-dark"><%= company.getCompanyName() %></div>
                            </div>
                            <p class="small text-muted mb-2"><i class="bi bi-tag me-2"></i><%= company.getIndustry() %></p>
                            <p class="small text-muted mb-2"><i class="bi bi-people me-2"></i><%= company.getCompanySize() %> Employees</p>
                            <p class="small text-muted mb-3"><i class="bi bi-globe me-2"></i><a href="<%= company.getWebsite() %>" target="_blank" class="text-decoration-none"><%= company.getWebsite() %></a></p>
                            <a href="${pageContext.request.contextPath}/company-details?id=<%= company.getId() %>" class="btn btn-outline-primary btn-sm w-100 rounded-pill">
                                View Company Profile
                            </a>
                        <% } %>
                    </div>
                </aside>
            </div>
        <% } else { %>
            <div class="glass-panel p-5 text-center my-5">
                <i class="bi bi-exclamation-octagon text-danger fs-1 mb-3 d-block"></i>
                <h3 class="fw-bold">Job Posting Not Found</h3>
                <p class="text-muted">The job position you are looking for may have been closed or removed.</p>
                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary rounded-pill px-4 mt-2">
                    <i class="bi bi-arrow-left me-1"></i>Back to All Jobs
                </a>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
