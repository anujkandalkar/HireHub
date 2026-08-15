<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Application, java.util.List" %>
<%
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "Admin - All Applications");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">System-Wide Applications Monitoring</h3>
                <p class="text-muted mb-0">Track all job applications across candidates and employers</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/applications" method="get" class="d-flex gap-2">
                <select name="status" class="form-select rounded-pill px-3">
                    <option value="ALL">All Statuses</option>
                    <option value="APPLIED">Applied</option>
                    <option value="UNDER_REVIEW">Under Review</option>
                    <option value="SHORTLISTED">Shortlisted</option>
                    <option value="TASK_ASSIGNED">Task Assigned</option>
                    <option value="INTERVIEW">Interview</option>
                    <option value="SELECTED">Selected</option>
                    <option value="REJECTED">Rejected</option>
                </select>
                <button type="submit" class="btn btn-primary rounded-pill px-4">Filter</button>
            </form>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Candidate</th>
                            <th>Job Title</th>
                            <th>Company</th>
                            <th>Resume</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applications != null && !applications.isEmpty()) { 
                            for (Application a : applications) { %>
                                <tr>
                                    <td class="ps-4 fw-bold"><%= a.getStudentName() %></td>
                                    <td><%= a.getJobTitle() %></td>
                                    <td><%= a.getCompanyName() %></td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="${pageContext.request.contextPath}/resume/view?studentId=<%= a.getStudentId() %>" target="_blank" class="btn btn-outline-danger py-1" title="View PDF Resume">
                                                <i class="bi bi-file-earmark-pdf me-1"></i>View
                                            </a>
                                            <a href="${pageContext.request.contextPath}/resume/download?studentId=<%= a.getStudentId() %>" class="btn btn-outline-secondary py-1" title="Download Resume">
                                                <i class="bi bi-download"></i>
                                            </a>
                                        </div>
                                    </td>
                                    <td><%= a.getAppliedDate() %></td>
                                    <td><span class="badge bg-primary px-3 py-1.5 rounded-pill"><%= a.getStatus() %></span></td>
                                </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-2 text-muted"></i>
                                    No applications found.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
