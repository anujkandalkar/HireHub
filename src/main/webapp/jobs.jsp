<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, java.util.List" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "Search & Filter Jobs - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-4">
    <div class="container">
        <div class="search-section-card">
            <form action="${pageContext.request.contextPath}/jobs" method="get" class="row g-3 align-items-end">
                <div class="col-lg-4 col-md-5">
                    <label class="form-label"><i class="bi bi-search me-1 text-primary"></i>What</label>
                    <div class="search-input-box">
                        <i class="bi bi-search search-input-icon text-primary"></i>
                        <input type="text" name="keyword" class="form-control" placeholder="Job title, keywords, or company" value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                    </div>
                </div>
                <div class="col-lg-3 col-md-4">
                    <label class="form-label"><i class="bi bi-geo-alt me-1 text-info"></i>Where</label>
                    <div class="search-input-box">
                        <i class="bi bi-geo-alt search-input-icon text-info"></i>
                        <input type="text" name="location" class="form-control" placeholder="City, state, or remote" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>">
                    </div>
                </div>
                <div class="col-lg-3 col-md-3">
                    <label class="form-label"><i class="bi bi-briefcase me-1 text-secondary"></i>Job Type</label>
                    <select name="jobType" class="form-select search-select-control">
                        <option value="">All Job Types</option>
                        <option value="FULL_TIME" <%= "FULL_TIME".equals(request.getAttribute("jobType")) ? "selected" : "" %>>Full Time</option>
                        <option value="PART_TIME" <%= "PART_TIME".equals(request.getAttribute("jobType")) ? "selected" : "" %>>Part Time</option>
                        <option value="INTERNSHIP" <%= "INTERNSHIP".equals(request.getAttribute("jobType")) ? "selected" : "" %>>Internship</option>
                        <option value="CONTRACT" <%= "CONTRACT".equals(request.getAttribute("jobType")) ? "selected" : "" %>>Contract</option>
                    </select>
                </div>
                <div class="col-lg-2 col-md-12">
                    <button type="submit" class="btn search-btn-primary w-100">
                        <i class="bi bi-search me-1"></i>Find Jobs
                    </button>
                </div>
                <input type="hidden" name="sort" value="<%= request.getAttribute("sort") != null ? request.getAttribute("sort") : "NEWEST" %>">
            </form>
        </div>
    </div>
</section>

<section class="py-4 bg-light job-board-shell">
    <div class="container">
        <div class="row g-4 align-items-start">
            <aside class="col-lg-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white filter-panel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-sliders2 text-primary me-2"></i>Filters</h5>
                        <a href="${pageContext.request.contextPath}/jobs" class="small fw-semibold text-decoration-none">Reset</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/jobs" method="get" class="vstack gap-3">
                        <input type="hidden" name="keyword" value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                        <input type="hidden" name="location" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>">
                        <input type="hidden" name="jobType" value="<%= request.getAttribute("jobType") != null ? request.getAttribute("jobType") : "" %>">
                        <div>
                            <label class="form-label fw-semibold small">Salary Range</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" name="minSalary" class="form-control" placeholder="Min" value="<%= request.getParameter("minSalary") != null ? request.getParameter("minSalary") : "" %>">
                                </div>
                                <div class="col-6">
                                    <input type="number" name="maxSalary" class="form-control" placeholder="Max" value="<%= request.getParameter("maxSalary") != null ? request.getParameter("maxSalary") : "" %>">
                                </div>
                            </div>
                        </div>

                        <div>
                            <label class="form-label fw-semibold small">Sort By</label>
                            <select name="sort" class="form-select">
                                <option value="NEWEST" <%= "NEWEST".equals(request.getAttribute("sort")) ? "selected" : "" %>>Newest First</option>
                                <option value="SALARY_HIGH" <%= "SALARY_HIGH".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: High to Low</option>
                                <option value="SALARY_LOW" <%= "SALARY_LOW".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: Low to High</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel me-1"></i>Apply Filters</button>
                    </form>
                </div>
            </aside>

            <div class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark mb-0">
                        <span class="text-primary"><%= jobs != null ? jobs.size() : 0 %></span> opportunities available
                    </h5>
                </div>

                <div class="job-results-list">
                    <% if (jobs != null && !jobs.isEmpty()) { 
                        for (Job job : jobs) { %>
                            <article class="job-result-card">
                                    <div class="d-flex justify-content-between align-items-start gap-3 mb-2">
                                        <div>
                                            <h5 class="fw-bold mb-1"><a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="text-decoration-none job-title-link"><%= job.getTitle() %></a></h5>
                                            <div class="job-meta-line"><%= job.getCompanyName() %></div>
                                        </div>
                                        <span class="badge bg-primary bg-opacity-10 text-primary job-badge-type"><%= job.getJobType().replace('_', ' ') %></span>
                                    </div>

                                    <% if (job.getMatchPercentage() > 0) { %>
                                        <div class="mb-3">
                                            <span class="match-badge">
                                                <i class="bi bi-lightning-charge-fill me-1"></i><%= job.getMatchPercentage() %>% Skill Match
                                            </span>
                                        </div>
                                    <% } %>

                                    <div class="job-meta-line mb-2">
                                        <span><%= job.getLocation() %></span>
                                        <span class="mx-2">|</span>
                                        <span><%= job.getExperienceYears() %> experience</span>
                                    </div>
                                    <div class="job-pay mb-3">$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %> a year</div>

                                    <div class="mb-3">
                                        <% if (job.getRequiredSkills() != null) {
                                            String[] skills = job.getRequiredSkills().split("[,;]");
                                            for (int s = 0; s < Math.min(skills.length, 5); s++) { %>
                                                <span class="skill-tag"><%= skills[s].trim() %></span>
                                        <%  } 
                                           } %>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center pt-2 gap-2">
                                        <span class="text-muted small">Posted <%= job.getCreatedAt() %> | <%= job.getApplicationCount() %> applied</span>
                                        <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="btn btn-sm btn-primary px-3">View job</a>
                                    </div>
                            </article>
                    <%  }
                       } else { %>
                        <div>
                            <div class="card border-0 shadow-sm rounded-4 bg-white empty-state">
                                <div class="stat-icon bg-light text-muted mx-auto mb-3 fs-1">
                                    <i class="bi bi-search"></i>
                                </div>
                                <h4 class="fw-bold text-dark">No Jobs Found</h4>
                                <p class="text-muted mb-0">Try adjusting your search filters or keyword criteria.</p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
