<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, java.util.List" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "System Job Moderation — Admin");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">System Job Moderation & Management</h3>
                <p class="text-muted mb-0">Oversee all jobs published across HireHub, toggle active visibility, or delete inappropriate listings</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/jobs" method="get" class="d-flex gap-2">
                <input type="text" name="search" class="form-control rounded-pill px-3" placeholder="Search job title or company..." value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
                <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">Search</button>
            </form>
        </div>

        <div class="glass-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Job Title</th>
                            <th>Company</th>
                            <th>Location</th>
                            <th>Salary Range</th>
                            <th>Applicants</th>
                            <th>Status</th>
                            <th class="text-end pe-4">Moderation Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (jobs != null && !jobs.isEmpty()) { 
                            for (Job j : jobs) { 
                                boolean isActive = "ACTIVE".equalsIgnoreCase(j.getStatus());
                        %>
                            <tr>
                                <td class="ps-4 fw-bold">
                                    <a href="${pageContext.request.contextPath}/job-details?id=<%= j.getId() %>" class="text-decoration-none text-dark"><%= j.getTitle() %></a>
                                </td>
                                <td class="fw-semibold text-dark"><%= j.getCompanyName() %></td>
                                <td><i class="bi bi-geo-alt me-1 text-primary"></i><%= j.getLocation() %></td>
                                <td class="job-pay">$<%= (int)j.getSalaryMin() %> - $<%= (int)j.getSalaryMax() %></td>
                                <td><span class="badge bg-light text-dark border px-2.5 py-1"><%= j.getApplicationCount() %></span></td>
                                <td><span class="badge <%= isActive ? "bg-success" : "bg-secondary" %> rounded-pill px-3 py-1.5"><%= j.getStatus() %></span></td>
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-1">
                                        <form action="${pageContext.request.contextPath}/admin/job-action" method="post" class="d-inline">
                                            <input type="hidden" name="jobId" value="<%= j.getId() %>">
                                            <input type="hidden" name="action" value="<%= isActive ? "DEACTIVATE" : "ACTIVATE" %>">
                                            <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Toggle Status"><i class="bi bi-power"></i></button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/admin/job-action" method="post" class="d-inline" onsubmit="return confirm('Permanently delete this job posting?')">
                                            <input type="hidden" name="jobId" value="<%= j.getId() %>">
                                            <input type="hidden" name="action" value="DELETE">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Delete Job"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr><td colspan="7" class="text-center py-5 text-muted">No job postings found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
