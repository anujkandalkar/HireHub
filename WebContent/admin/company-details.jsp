<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, com.hirehub.model.Job, java.util.List" %>
<%
    Company company = (Company) request.getAttribute("company");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "Company Details — Admin Review");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (company != null) { %>
            <div class="glass-card p-4 p-md-5 mb-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-start mb-4 gap-3">
                    <div>
                        <h2 class="fw-bold text-dark mb-1"><%= company.getCompanyName() %></h2>
                        <p class="text-muted mb-0"><i class="bi bi-envelope me-1 text-primary"></i><%= company.getEmail() %> &bull; <i class="bi bi-telephone me-1 text-info"></i><%= company.getPhone() %></p>
                    </div>
                    <span class="badge <%= "APPROVED".equalsIgnoreCase(company.getApprovalStatus()) ? "bg-success" : "bg-warning text-dark" %> px-3 py-2 rounded-pill fs-6 flex-shrink-0">
                        <%= company.getApprovalStatus() %>
                    </span>
                </div>

                <hr class="my-4 border-secondary opacity-25">

                <div class="row g-3">
                    <div class="col-md-4"><strong>Industry:</strong> <%= company.getIndustry() %></div>
                    <div class="col-md-4"><strong>Location:</strong> <%= company.getLocation() %></div>
                    <div class="col-md-4"><strong>Company Size:</strong> <%= company.getCompanySize() %></div>
                    <div class="col-md-12"><strong>Website:</strong> <a href="<%= company.getWebsite() %>" target="_blank" class="text-primary text-decoration-none"><%= company.getWebsite() %></a></div>
                    <div class="col-12 mt-3">
                        <strong class="text-dark">Overview:</strong>
                        <p class="text-secondary small mt-1 mb-0" style="line-height: 1.6;"><%= company.getDescription() %></p>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-briefcase me-2 text-primary"></i>Jobs Posted by <%= company.getCompanyName() %> (<%= jobs != null ? jobs.size() : 0 %>)</h5>
            <div class="glass-card overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Job Title</th>
                                <th>Location</th>
                                <th>Salary Range</th>
                                <th>Status</th>
                                <th>Posted Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (jobs != null && !jobs.isEmpty()) { 
                                for (Job j : jobs) { %>
                                    <tr>
                                        <td class="ps-4 fw-bold text-dark"><%= j.getTitle() %></td>
                                        <td><%= j.getLocation() %></td>
                                        <td class="job-pay">$<%= (int)j.getSalaryMin() %> - $<%= (int)j.getSalaryMax() %></td>
                                        <td><span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1.5 rounded-pill"><%= j.getStatus() %></span></td>
                                        <td class="small text-muted"><%= j.getCreatedAt() %></td>
                                    </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="5" class="text-center py-4 text-muted">No jobs posted.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
