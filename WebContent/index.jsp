<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.dao.JobDAO, com.hirehub.dao.CompanyDAO, com.hirehub.dao.StudentDAO, com.hirehub.dao.ApplicationDAO" %>
<%@ page import="com.hirehub.model.Job, com.hirehub.model.Company, java.util.List" %>
<%
    JobDAO jobDAO = new JobDAO();
    CompanyDAO companyDAO = new CompanyDAO();
    StudentDAO studentDAO = new StudentDAO();
    ApplicationDAO appDAO = new ApplicationDAO();

    int activeJobsCount = jobDAO.getTotalActiveJobsCount();
    int companiesCount = companyDAO.getTotalCompaniesCount();
    int studentsCount = studentDAO.getTotalStudentsCount();
    int placementsCount = appDAO.getApplicationsCountByStatus("SELECTED");

    List<Job> featuredJobs = jobDAO.searchAndFilterJobs(null, null, null, null, null, "NEWEST");
    if (featuredJobs.size() > 6) featuredJobs = featuredJobs.subList(0, 6);

    List<Company> topCompanies = companyDAO.getAllCompanies(null, "APPROVED");
    if (topCompanies.size() > 4) topCompanies = topCompanies.subList(0, 4);

    request.setAttribute("pageTitle", "HireHub — Discover Your Next High-Impact Career Role");
%>

<jsp:include page="/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="container text-center text-lg-start">
        <div class="row align-items-center g-5">
            <div class="col-lg-12">
                <div class="text-center mx-auto" style="max-width: 860px;">
                    <span class="badge bg-primary bg-opacity-25 text-info border border-info border-opacity-25 px-3 py-2 rounded-pill mb-3">
                        <i class="bi bi-stars me-1"></i> The Modern Job Search Platform
                    </span>
                    <h1 class="hero-title mb-3">Find your next opportunity with top-tier companies</h1>
                    <p class="hero-subtitle mx-auto mb-4">
                        Discover job openings tailored to your skill set, compare salary benchmarks, and apply with your verified HireHub profile.
                    </p>

                    <!-- Glass Search Box Panel -->
                    <div class="hero-search-panel text-start">
                        <form action="${pageContext.request.contextPath}/jobs" method="get" class="row g-3 align-items-end">
                            <div class="col-lg-5 col-md-6">
                                <label class="form-label"><i class="bi bi-search me-1 text-primary"></i>What</label>
                                <div class="search-input-box">
                                    <i class="bi bi-search search-input-icon text-primary"></i>
                                    <input type="text" name="keyword" class="form-control" placeholder="Job title, keywords, or company">
                                </div>
                            </div>
                            <div class="col-lg-4 col-md-6">
                                <label class="form-label"><i class="bi bi-geo-alt me-1 text-info"></i>Where</label>
                                <div class="search-input-box">
                                    <i class="bi bi-geo-alt search-input-icon text-info"></i>
                                    <input type="text" name="location" class="form-control" placeholder="City, state, or remote">
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-12">
                                <button type="submit" class="btn search-btn-primary w-100">
                                    <i class="bi bi-search me-1"></i>Find Jobs
                                </button>
                            </div>
                            <div class="col-12 pt-1">
                                <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-2 pt-2">
                                    <span class="text-white-50 small align-self-center me-2"><i class="bi bi-fire text-warning me-1"></i>Popular:</span>
                                    <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?jobType=FULL_TIME"><i class="bi bi-briefcase me-1"></i>Full-time jobs</a>
                                    <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?jobType=INTERNSHIP"><i class="bi bi-mortarboard me-1"></i>Internships</a>
                                    <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?location=Remote"><i class="bi bi-laptop me-1"></i>Remote</a>
                                    <a class="quick-search-link" href="${pageContext.request.contextPath}/companies"><i class="bi bi-building me-1"></i>Browse companies</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Metric Stat Cards Bar -->
<section class="py-4 border-bottom">
    <div class="container">
        <div class="row g-3 text-center">
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-briefcase-fill"></i></div>
                    <div class="stat-value"><%= activeJobsCount %></div>
                    <div class="stat-label">Active Job Postings</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto mb-2"><i class="bi bi-building"></i></div>
                    <div class="stat-value"><%= companiesCount %></div>
                    <div class="stat-label">Verified Employers</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-people-fill"></i></div>
                    <div class="stat-value"><%= studentsCount %></div>
                    <div class="stat-label">Candidate Profiles</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto mb-2"><i class="bi bi-trophy-fill"></i></div>
                    <div class="stat-value"><%= placementsCount %></div>
                    <div class="stat-label">Successful Matches</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Jobs Section -->
<section class="py-5">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 gap-3">
            <div>
                <span class="page-eyebrow"><i class="bi bi-lightning-charge-fill me-1"></i>Fresh Opportunities</span>
                <h2 class="fw-bold mb-0 text-dark">Featured Job Openings</h2>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-primary rounded-pill px-4">
                Explore All Openings <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <% if (featuredJobs != null && !featuredJobs.isEmpty()) { 
                for (Job job : featuredJobs) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="job-card">
                            <div class="d-flex align-items-start gap-3 mb-3">
                                <div class="company-avatar">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div class="flex-grow-1 overflow-hidden">
                                    <h5 class="fw-bold mb-1 text-truncate">
                                        <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>"><%= job.getTitle() %></a>
                                    </h5>
                                    <div class="text-muted small text-truncate"><i class="bi bi-building me-1"></i><%= job.getCompanyName() %></div>
                                </div>
                                <span class="job-badge-type flex-shrink-0"><%= job.getJobType().replace('_', ' ') %></span>
                            </div>

                            <div class="mb-3">
                                <div class="text-muted small mb-1"><i class="bi bi-geo-alt me-1 text-primary"></i><%= job.getLocation() %></div>
                                <div class="job-pay"><i class="bi bi-cash-stack me-1"></i>$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %> <small class="text-muted fw-normal fs-6">/ yr</small></div>
                            </div>

                            <div class="mb-4 flex-grow-1">
                                <% if (job.getRequiredSkills() != null) {
                                    String[] skills = job.getRequiredSkills().split("[,;]");
                                    for (int s = 0; s < Math.min(skills.length, 3); s++) { %>
                                        <span class="skill-tag"><%= skills[s].trim() %></span>
                                <%  } 
                                   } %>
                            </div>

                            <div class="mt-auto d-flex justify-content-between align-items-center pt-3 border-top">
                                <span class="text-muted small"><i class="bi bi-clock me-1"></i><%= job.getCreatedAt() %></span>
                                <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="btn btn-sm btn-primary rounded-pill px-3">
                                    View Job <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="glass-panel p-5 text-center">
                        <i class="bi bi-briefcase text-muted fs-1 mb-3 d-block"></i>
                        <h4 class="fw-bold">No active job listings yet</h4>
                        <p class="text-muted mb-0">Check back soon as new opportunities are posted daily!</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Top Hiring Companies Section -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container">
        <div class="text-center max-w-2xl mx-auto mb-5">
            <span class="page-eyebrow justify-content-center"><i class="bi bi-building me-1"></i>Verified Hiring Partners</span>
            <h2 class="fw-bold text-dark">Explore Top Employers</h2>
            <p class="text-muted">Direct recruitment from approved software, finance, and product organizations.</p>
        </div>

        <div class="row g-4">
            <% if (topCompanies != null && !topCompanies.isEmpty()) { 
                for (Company comp : topCompanies) { %>
                    <div class="col-lg-3 col-md-6">
                        <div class="glass-card p-4 text-center h-100 d-flex flex-column align-items-center">
                            <div class="company-avatar mx-auto mb-3" style="width:64px; height:64px; font-size:1.6rem;">
                                <i class="bi bi-building"></i>
                            </div>
                            <h5 class="fw-bold mb-1 text-dark"><%= comp.getCompanyName() %></h5>
                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1 mb-2">Verified Recruiter</span>
                            <p class="text-muted small mb-2"><%= comp.getIndustry() %></p>
                            <p class="text-muted small mb-3"><i class="bi bi-geo-alt me-1"></i><%= comp.getLocation() %></p>
                            <a href="${pageContext.request.contextPath}/company-details?id=<%= comp.getId() %>" class="btn btn-outline-primary btn-sm rounded-pill mt-auto px-4">
                                View Openings
                            </a>
                        </div>
                    </div>
            <%  }
               } %>
        </div>
    </div>
</section>

<!-- How HireHub Works -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="page-eyebrow justify-content-center"><i class="bi bi-diagram-3 me-1"></i>Streamlined Workflow</span>
            <h2 class="fw-bold text-dark">How HireHub Works</h2>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-3">
                <div class="glass-card p-4 h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px; font-weight:800;">1</div>
                    <h5 class="fw-bold mb-2">Create Profile</h5>
                    <p class="text-muted small mb-0">Build your candidate resume profile, list technical skills, and upload your resume.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card p-4 h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px; font-weight:800;">2</div>
                    <h5 class="fw-bold mb-2">Discover Roles</h5>
                    <p class="text-muted small mb-0">Search jobs with active skill match calculation showing your compatibility percentage.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card p-4 h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px; font-weight:800;">3</div>
                    <h5 class="fw-bold mb-2">One-Click Apply</h5>
                    <p class="text-muted small mb-0">Submit applications directly and track live application status on your dashboard timeline.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card p-4 h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px; font-weight:800;">4</div>
                    <h5 class="fw-bold mb-2">Get Hired</h5>
                    <p class="text-muted small mb-0">Complete interview assignments, attend online interviews, and receive formal offer letters.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Why HireHub Section -->
<section class="py-5 bg-dark text-white position-relative overflow-hidden">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="badge bg-primary px-3 py-2 rounded-pill mb-3">Enterprise Recruitment Platform</span>
                <h2 class="fw-bold display-6 mb-4">Empowering Recruiters & Candidates Worldwide</h2>
                <div class="d-flex mb-4">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold text-white mb-1">Pre-Screened Employer Network</h5>
                        <p class="text-muted mb-0" style="color: #94a3b8 !important;">Admin approval ensures all hiring company recruiters on HireHub are verified and authentic.</p>
                    </div>
                </div>
                <div class="d-flex mb-4">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-cpu-fill"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold text-white mb-1">Smart Match Percentage Engine</h5>
                        <p class="text-muted mb-0" style="color: #94a3b8 !important;">Our dynamic skill matching engine automatically calculates candidate compatibility scores for open jobs.</p>
                    </div>
                </div>
                <div class="d-flex">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-kanban"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold text-white mb-1">End-to-End Application Pipeline</h5>
                        <p class="text-muted mb-0" style="color: #94a3b8 !important;">Track candidate applications through shortlisting, technical tasks, live interviews, and final selection.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <div class="glass-card-dark p-2 overflow-hidden shadow-2xl">
                    <img src="https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=80" alt="Recruitment Team" class="img-fluid rounded-3" style="max-height: 380px; width: 100%; object-fit: cover;">
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
