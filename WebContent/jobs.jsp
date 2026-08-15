<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, java.util.List" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "Search & Filter Jobs — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<!-- Search Toolbar Section -->
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

<!-- Job Board Content Shell -->
<section class="py-4 bg-light job-board-shell">
    <div class="container">
        
        <!-- Mobile Filters Button Bar (Visible on mobile/tablet) -->
        <div class="d-lg-none mb-3 d-flex justify-content-between align-items-center">
            <button class="btn btn-outline-primary rounded-pill w-100 d-flex align-items-center justify-content-center gap-2 py-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobileFilterDrawer" aria-controls="mobileFilterDrawer">
                <i class="bi bi-sliders2"></i> Filters & Sort (<%= jobs != null ? jobs.size() : 0 %> results)
            </button>
        </div>

        <div class="row g-4 align-items-start">
            <!-- Desktop Sidebar Filter Panel -->
            <aside class="col-lg-3 d-none d-lg-block">
                <div class="glass-card p-4 filter-panel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0 text-dark"><i class="bi bi-sliders2 text-primary me-2"></i>Filters</h5>
                        <a href="${pageContext.request.contextPath}/jobs" class="small fw-semibold text-decoration-none text-primary">Reset All</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/jobs" method="get" class="vstack gap-3">
                        <input type="hidden" name="keyword" value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                        <input type="hidden" name="location" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>">
                        <input type="hidden" name="jobType" value="<%= request.getAttribute("jobType") != null ? request.getAttribute("jobType") : "" %>">
                        
                        <div>
                            <label class="form-label fw-semibold small">Salary Range ($ / year)</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" name="minSalary" class="form-control" placeholder="Min $" value="<%= request.getParameter("minSalary") != null ? request.getParameter("minSalary") : "" %>">
                                </div>
                                <div class="col-6">
                                    <input type="number" name="maxSalary" class="form-control" placeholder="Max $" value="<%= request.getParameter("maxSalary") != null ? request.getParameter("maxSalary") : "" %>">
                                </div>
                            </div>
                        </div>

                        <div>
                            <label class="form-label fw-semibold small">Sort Order</label>
                            <select name="sort" class="form-select">
                                <option value="NEWEST" <%= "NEWEST".equals(request.getAttribute("sort")) ? "selected" : "" %>>Newest First</option>
                                <option value="SALARY_HIGH" <%= "SALARY_HIGH".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: High to Low</option>
                                <option value="SALARY_LOW" <%= "SALARY_LOW".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: Low to High</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 shadow-sm mt-2">
                            <i class="bi bi-funnel me-1"></i>Apply Filters
                        </button>
                    </form>
                </div>
            </aside>

            <!-- Job Results Column -->
            <div class="col-lg-9 col-12">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark mb-0">
                        Showing <span class="text-primary fw-extrabold"><%= jobs != null ? jobs.size() : 0 %></span> open positions
                    </h5>
                </div>

                <div class="job-results-list vstack gap-3">
                    <% if (jobs != null && !jobs.isEmpty()) { 
                        for (Job job : jobs) { %>
                            <article class="job-result-card">
                                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start gap-3 mb-2">
                                    <div class="d-flex gap-3 align-items-start">
                                        <div class="company-avatar">
                                            <i class="bi bi-building"></i>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-1">
                                                <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="job-title-link"><%= job.getTitle() %></a>
                                            </h5>
                                            <div class="job-meta-line font-semibold"><i class="bi bi-building me-1"></i><%= job.getCompanyName() %></div>
                                        </div>
                                    </div>
                                    <span class="job-badge-type flex-shrink-0"><%= job.getJobType().replace('_', ' ') %></span>
                                </div>

                                <% if (job.getMatchPercentage() > 0) { %>
                                    <div class="mb-3">
                                        <span class="match-badge">
                                            <i class="bi bi-lightning-charge-fill me-1"></i><%= job.getMatchPercentage() %>% Skill Match
                                        </span>
                                    </div>
                                <% } %>

                                <div class="job-meta-line mb-2 vstack gap-1 gap-sm-0 flex-sm-row align-items-sm-center">
                                    <span><i class="bi bi-geo-alt me-1 text-primary"></i><%= job.getLocation() %></span>
                                    <span class="d-none d-sm-inline mx-2 text-muted">|</span>
                                    <span><i class="bi bi-briefcase me-1 text-secondary"></i><%= job.getExperienceYears() %> experience</span>
                                </div>
                                
                                <div class="job-pay mb-3">
                                    <i class="bi bi-cash-stack me-1"></i>$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %> <small class="text-muted font-normal fs-6">/ year</small>
                                </div>

                                <div class="mb-3">
                                    <% if (job.getRequiredSkills() != null) {
                                        String[] skills = job.getRequiredSkills().split("[,;]");
                                        for (int s = 0; s < Math.min(skills.length, 5); s++) { %>
                                            <span class="skill-tag"><%= skills[s].trim() %></span>
                                    <%  } 
                                       } %>
                                </div>

                                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center pt-3 border-top gap-2">
                                    <span class="text-muted small"><i class="bi bi-clock me-1"></i>Posted <%= job.getCreatedAt() %> &bull; <%= job.getApplicationCount() %> applicant(s)</span>
                                    <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="btn btn-sm btn-primary rounded-pill px-4 align-self-start align-self-sm-auto">
                                        View Details <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </article>
                    <%  }
                       } else { %>
                        <div class="glass-panel p-5 text-center empty-state">
                            <div class="stat-icon bg-light text-muted mx-auto mb-3 fs-1">
                                <i class="bi bi-search"></i>
                            </div>
                            <h4 class="fw-bold text-dark mb-1">No Matching Jobs Found</h4>
                            <p class="text-muted mb-4">Try adjusting your search criteria, clearing keyword filters, or expanding location preferences.</p>
                            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary rounded-pill px-4">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset All Filters
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Mobile Offcanvas Filter Drawer -->
<div class="offcanvas offcanvas-start rounded-end-4" tabindex="-1" id="mobileFilterDrawer" aria-labelledby="mobileFilterDrawerLabel">
    <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title fw-bold" id="mobileFilterDrawerLabel"><i class="bi bi-sliders2 text-primary me-2"></i>Filter & Sort Jobs</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <form action="${pageContext.request.contextPath}/jobs" method="get" class="vstack gap-3">
            <input type="hidden" name="keyword" value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
            <input type="hidden" name="location" value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>">
            <input type="hidden" name="jobType" value="<%= request.getAttribute("jobType") != null ? request.getAttribute("jobType") : "" %>">
            
            <div>
                <label class="form-label fw-semibold small">Salary Range ($ / year)</label>
                <div class="row g-2">
                    <div class="col-6">
                        <input type="number" name="minSalary" class="form-control" placeholder="Min $" value="<%= request.getParameter("minSalary") != null ? request.getParameter("minSalary") : "" %>">
                    </div>
                    <div class="col-6">
                        <input type="number" name="maxSalary" class="form-control" placeholder="Max $" value="<%= request.getParameter("maxSalary") != null ? request.getParameter("maxSalary") : "" %>">
                    </div>
                </div>
            </div>

            <div>
                <label class="form-label fw-semibold small">Sort Order</label>
                <select name="sort" class="form-select">
                    <option value="NEWEST" <%= "NEWEST".equals(request.getAttribute("sort")) ? "selected" : "" %>>Newest First</option>
                    <option value="SALARY_HIGH" <%= "SALARY_HIGH".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: High to Low</option>
                    <option value="SALARY_LOW" <%= "SALARY_LOW".equals(request.getAttribute("sort")) ? "selected" : "" %>>Salary: Low to High</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary w-100 shadow-sm mt-3">
                <i class="bi bi-funnel me-1"></i>Apply Filters
            </button>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-secondary w-100 mt-2">Reset Filters</a>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
