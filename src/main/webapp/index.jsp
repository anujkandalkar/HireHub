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

    request.setAttribute("pageTitle", "HireHub - Find the Job That Fits Your Future");
%>

<jsp:include page="/includes/header.jsp" />

<section class="indeed-home-hero">
    <div class="container">
        <h1 class="hero-title mb-3">Find jobs that fit your skills and goals</h1>
        <p class="hero-subtitle mb-0">
            Search active openings from verified companies, compare roles, and apply through your HireHub profile.
        </p>

        <div class="indeed-search-panel">
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
                <div class="col-12 pt-2">
                    <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-2 pt-1">
                        <span class="text-secondary small align-self-center me-2"><i class="bi bi-fire text-warning me-1"></i>Popular:</span>
                        <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?jobType=FULL_TIME"><i class="bi bi-briefcase me-1"></i>Full-time jobs</a>
                        <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?jobType=INTERNSHIP"><i class="bi bi-mortarboard me-1"></i>Internships</a>
                        <a class="quick-search-link" href="${pageContext.request.contextPath}/jobs?location=Remote"><i class="bi bi-laptop me-1"></i>Remote</a>
                        <a class="quick-search-link" href="${pageContext.request.contextPath}/companies"><i class="bi bi-building me-1"></i>Browse companies</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<section class="py-4 bg-white border-bottom">
    <div class="container">
        <div class="row g-3 text-center">
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-value"><%= activeJobsCount %></div>
                    <div class="stat-label">Active Jobs</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-value"><%= companiesCount %></div>
                    <div class="stat-label">Companies</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-value"><%= studentsCount %></div>
                    <div class="stat-label">Job Seekers</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-value"><%= placementsCount %></div>
                    <div class="stat-label">Successful Placements</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Jobs Section -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="text-primary fw-bold text-uppercase tracking-wider small">Explore Opportunities</span>
                <h2 class="fw-bold mb-0">Featured Job Openings</h2>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-primary rounded-pill px-4">View All Jobs <i class="bi bi-arrow-right ms-1"></i></a>
        </div>

        <div class="row g-4">
            <% if (featuredJobs != null && !featuredJobs.isEmpty()) { 
                for (Job job : featuredJobs) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="job-card">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1"><a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="text-decoration-none text-dark"><%= job.getTitle() %></a></h5>
                                    <div class="text-muted small"><i class="bi bi-building me-1"></i><%= job.getCompanyName() %></div>
                                </div>
                                <span class="badge bg-primary bg-opacity-10 text-primary job-badge-type"><%= job.getJobType().replace('_', ' ') %></span>
                            </div>

                            <div class="mb-3">
                                <span class="text-muted small me-3"><i class="bi bi-geo-alt me-1"></i><%= job.getLocation() %></span>
                                <span class="text-success fw-semibold small"><i class="bi bi-currency-dollar me-1"></i>$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %></span>
                            </div>

                            <div class="mb-4">
                                <% if (job.getRequiredSkills() != null) {
                                    String[] skills = job.getRequiredSkills().split("[,;]");
                                    for (int s = 0; s < Math.min(skills.length, 3); s++) { %>
                                        <span class="skill-tag"><%= skills[s].trim() %></span>
                                <%  } 
                                   } %>
                            </div>

                            <div class="mt-auto d-flex justify-content-between align-items-center pt-3 border-top">
                                <span class="text-muted small"><i class="bi bi-clock me-1"></i>Posted <%= job.getCreatedAt() %></span>
                                <a href="${pageContext.request.contextPath}/job-details?id=<%= job.getId() %>" class="btn btn-sm btn-primary rounded-pill px-3">Apply Now</a>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No jobs posted yet. Check back soon!</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Top Companies Section -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container">
        <div class="text-center max-w-2xl mx-auto mb-5">
            <span class="text-primary fw-bold text-uppercase tracking-wider small">Partner Employers</span>
            <h2 class="fw-bold">Top Hiring Companies</h2>
        </div>

        <div class="row g-4">
            <% if (topCompanies != null && !topCompanies.isEmpty()) { 
                for (Company comp : topCompanies) { %>
                    <div class="col-lg-3 col-md-6">
                        <div class="card h-100 border-0 shadow-sm rounded-4 p-4 text-center">
                            <div class="stat-icon bg-light text-primary mx-auto mb-3 fs-2" style="width:64px; height:64px;">
                                <i class="bi bi-building"></i>
                            </div>
                            <h5 class="fw-bold mb-1"><%= comp.getCompanyName() %></h5>
                            <p class="text-muted small mb-2"><%= comp.getIndustry() %></p>
                            <p class="text-muted small"><i class="bi bi-geo-alt me-1"></i><%= comp.getLocation() %></p>
                            <a href="${pageContext.request.contextPath}/company-details?id=<%= comp.getId() %>" class="btn btn-outline-primary btn-sm rounded-pill mt-2">View Jobs</a>
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
            <span class="text-primary fw-bold text-uppercase tracking-wider small">Simple Process</span>
            <h2 class="fw-bold">How HireHub Works</h2>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px;">1</div>
                    <h5 class="fw-bold mb-2">Create Profile</h5>
                    <p class="text-muted small">Register as a job seeker, add your education, skills, and upload your resume.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px;">2</div>
                    <h5 class="fw-bold mb-2">Discover Jobs</h5>
                    <p class="text-muted small">Search jobs with smart skill match engine showing matching percentages.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px;">3</div>
                    <h5 class="fw-bold mb-2">Apply</h5>
                    <p class="text-muted small">Submit applications with one click and track progress on your dashboard timeline.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <div class="stat-icon bg-primary text-white rounded-circle mx-auto mb-3" style="width:56px; height:56px;">4</div>
                    <h5 class="fw-bold mb-2">Get Hired</h5>
                    <p class="text-muted small">Complete technical tasks, attend interviews, and land your dream job offer.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Why HireHub Section -->
<section class="py-5 bg-dark text-white">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="badge bg-primary px-3 py-2 rounded-pill mb-3">Why Choose HireHub</span>
                <h2 class="fw-bold display-6 mb-4">Empowering Recruiters & Candidates Worldwide</h2>
                <div class="d-flex mb-4">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold">Verified Companies</h5>
                        <p class="text-muted mb-0">Admin approval ensures all hiring recruiters on the platform are verified and authentic.</p>
                    </div>
                </div>
                <div class="d-flex mb-4">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-cpu-fill"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold">Smart Job Match</h5>
                        <p class="text-muted mb-0">Our dynamic skill match engine calculates percentage compatibility for candidate skills.</p>
                    </div>
                </div>
                <div class="d-flex">
                    <div class="stat-icon bg-primary bg-opacity-25 text-info me-3 flex-shrink-0">
                        <i class="bi bi-kanban"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold">End-to-End Application Pipeline</h5>
                        <p class="text-muted mb-0">Track applications through shortlisting, task assignments, online interviews, and final selection.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <img src="https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=80" alt="Teamwork" class="img-fluid rounded-4 shadow-lg" style="max-height: 400px; object-fit: cover;">
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
