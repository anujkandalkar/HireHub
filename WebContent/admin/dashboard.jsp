<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, com.hirehub.model.Company, com.hirehub.model.Application, java.util.List" %>
<%
    List<Student> recentStudents = (List<Student>) request.getAttribute("recentStudents");
    List<Company> recentCompanies = (List<Company>) request.getAttribute("recentCompanies");
    List<Application> recentApps = (List<Application>) request.getAttribute("recentApps");
    request.setAttribute("pageTitle", "Admin Dashboard — HireHub Control Center");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-4 bg-light">
    <div class="container">
        <!-- Control Center Dark Glass Banner -->
        <div class="glass-card-dark p-4 p-md-5 mb-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <span class="badge bg-primary px-3 py-1.5 rounded-pill mb-2"><i class="bi bi-shield-check me-1"></i>Platform Administration</span>
                    <h3 class="fw-bold mb-0 text-white">HireHub Control Center & System Analytics</h3>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/admin/companies?status=PENDING" class="btn btn-warning rounded-pill fw-semibold px-4 shadow-sm">
                        <i class="bi bi-clock-history me-1"></i>Pending Approvals (<%= request.getAttribute("pendingCompanies") != null ? request.getAttribute("pendingCompanies") : 0 %>)
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-light rounded-pill px-3">
                        <i class="bi bi-graph-up me-1"></i>System Reports
                    </a>
                </div>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-people-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : 0 %></div>
                    <div class="stat-label">Total Candidates</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-building-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalCompanies") != null ? request.getAttribute("totalCompanies") : 0 %></div>
                    <div class="stat-label">Registered Companies</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto mb-2"><i class="bi bi-briefcase-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("activeJobs") != null ? request.getAttribute("activeJobs") : 0 %></div>
                    <div class="stat-label">Active Job Openings</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto mb-2"><i class="bi bi-file-earmark-text-fill"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalApps") != null ? request.getAttribute("totalApps") : 0 %></div>
                    <div class="stat-label">Total Applications</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Registered Companies -->
            <div class="col-lg-6">
                <div class="glass-card overflow-hidden h-100">
                    <div class="p-4 border-bottom d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0"><i class="bi bi-building me-2 text-primary"></i>Recent Employer Registrations</h5>
                        <a href="${pageContext.request.contextPath}/admin/companies" class="small text-primary fw-semibold text-decoration-none">Manage All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4">Company</th>
                                    <th>Industry</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentCompanies != null && !recentCompanies.isEmpty()) { 
                                    for (Company c : recentCompanies) { %>
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark"><%= c.getCompanyName() %></td>
                                            <td class="small text-muted"><%= c.getIndustry() %></td>
                                            <td>
                                                <span class="badge <%= "APPROVED".equalsIgnoreCase(c.getApprovalStatus()) ? "bg-success" : ("PENDING".equalsIgnoreCase(c.getApprovalStatus()) ? "bg-warning text-dark" : "bg-danger") %> px-3 py-1.5 rounded-pill">
                                                    <%= c.getApprovalStatus() %>
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/company-details?id=<%= c.getId() %>" class="btn btn-sm btn-outline-primary rounded-pill px-3">Review</a>
                                            </td>
                                        </tr>
                                <%  }
                                   } else { %>
                                    <tr><td colspan="4" class="text-center py-4 text-muted">No recent company registrations.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Recent Students -->
            <div class="col-lg-6">
                <div class="glass-card overflow-hidden h-100">
                    <div class="p-4 border-bottom d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold text-dark mb-0"><i class="bi bi-people me-2 text-success"></i>Recent Candidate Registrations</h5>
                        <a href="${pageContext.request.contextPath}/admin/students" class="small text-primary fw-semibold text-decoration-none">Manage All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4">Candidate</th>
                                    <th>College / Major</th>
                                    <th class="text-end pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentStudents != null && !recentStudents.isEmpty()) { 
                                    for (Student s : recentStudents) { %>
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark"><%= s.getFullName() %></td>
                                            <td class="small text-muted"><%= s.getCollegeName() != null ? s.getCollegeName() : "Student" %></td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/student-details?id=<%= s.getId() %>" class="btn btn-sm btn-outline-primary rounded-pill px-3">View Profile</a>
                                            </td>
                                        </tr>
                                <%  }
                                   } else { %>
                                    <tr><td colspan="3" class="text-center py-4 text-muted">No recent candidate registrations.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
