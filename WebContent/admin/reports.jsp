<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Recruitment Reports & Analytics — Admin"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1"><i class="bi bi-graph-up-arrow me-2 text-primary"></i>Recruitment Analytics & Platform Overview</h3>
            <p class="text-muted mb-0">System performance metrics and application conversion pipeline breakdown</p>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-people-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalStudents") %></div>
                    <div class="stat-label">Registered Candidates</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-building-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalCompanies") %></div>
                    <div class="stat-label">Registered Companies</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto mb-2"><i class="bi bi-briefcase-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("activeJobs") %></div>
                    <div class="stat-label">Active Job Listings</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto mb-2"><i class="bi bi-file-earmark-check-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalApps") %></div>
                    <div class="stat-label">Total Applications</div>
                </div>
            </div>
        </div>

        <!-- Application Status Distribution Breakdown Card -->
        <div class="glass-card p-4 p-md-5 mb-4">
            <h5 class="fw-bold text-dark mb-4"><i class="bi bi-diagram-3 me-2 text-primary"></i>Application Recruitment Pipeline Breakdown</h5>
            
            <%
                int total = (Integer) request.getAttribute("totalApps");
                if (total == 0) total = 1;

                int applied = (Integer) request.getAttribute("appliedCount");
                int review = (Integer) request.getAttribute("reviewCount");
                int shortlisted = (Integer) request.getAttribute("shortlistedCount");
                int task = (Integer) request.getAttribute("taskCount");
                int interview = (Integer) request.getAttribute("interviewCount");
                int selected = (Integer) request.getAttribute("selectedCount");
                int rejected = (Integer) request.getAttribute("rejectedCount");
            %>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-dark">Applied (<%= applied %>)</span>
                    <span class="text-muted"><%= (applied * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-primary rounded-pill" role="progressbar" style="width: <%= (applied * 100 / total) %>%;"></div>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-dark">Under Review (<%= review %>)</span>
                    <span class="text-muted"><%= (review * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-secondary rounded-pill" role="progressbar" style="width: <%= (review * 100 / total) %>%;"></div>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-dark">Shortlisted Candidates (<%= shortlisted %>)</span>
                    <span class="text-muted"><%= (shortlisted * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-info rounded-pill" role="progressbar" style="width: <%= (shortlisted * 100 / total) %>%;"></div>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-dark">Task Assigned (<%= task %>)</span>
                    <span class="text-muted"><%= (task * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-warning rounded-pill" role="progressbar" style="width: <%= (task * 100 / total) %>%;"></div>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-dark">Interview Scheduled (<%= interview %>)</span>
                    <span class="text-muted"><%= (interview * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-purple rounded-pill" role="progressbar" style="width: <%= (interview * 100 / total) %>%; background-color: #8b5cf6;"></div>
                </div>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-success"><i class="bi bi-check-circle-fill me-1"></i>Selected & Offered (<%= selected %>)</span>
                    <span class="text-success fw-bold"><%= (selected * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-success rounded-pill" role="progressbar" style="width: <%= (selected * 100 / total) %>%;"></div>
                </div>
            </div>

            <div class="mb-0">
                <div class="d-flex justify-content-between mb-1">
                    <span class="fw-semibold text-danger">Rejected (<%= rejected %>)</span>
                    <span class="text-muted"><%= (rejected * 100 / total) %>%</span>
                </div>
                <div class="progress rounded-pill" style="height: 12px; background-color:#e2e8f0;">
                    <div class="progress-bar bg-danger rounded-pill" role="progressbar" style="width: <%= (rejected * 100 / total) %>%;"></div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
