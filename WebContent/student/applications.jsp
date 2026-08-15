<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Application, java.util.List" %>
<%
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "My Job Applications — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">My Job Applications</h3>
                <p class="text-muted mb-0">Track application status & pipeline progress across verified employers</p>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-search me-1"></i>Find More Jobs
            </a>
        </div>

        <div class="glass-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Job Title</th>
                            <th>Company</th>
                            <th>Applied Date</th>
                            <th>Current Status</th>
                            <th>Pipeline Progress</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applications != null && !applications.isEmpty()) { 
                            for (Application app : applications) { 
                                String st = app.getStatus();
                                String badgeClass = "badge-status-applied";
                                if ("SHORTLISTED".equalsIgnoreCase(st) || "SELECTED".equalsIgnoreCase(st)) badgeClass = "badge-status-selected";
                                else if ("APPLIED".equalsIgnoreCase(st) || "UNDER_REVIEW".equalsIgnoreCase(st)) badgeClass = "badge-status-applied";
                                else if ("TASK_ASSIGNED".equalsIgnoreCase(st) || "INTERVIEW".equalsIgnoreCase(st)) badgeClass = "badge-status-task";
                                else if ("REJECTED".equalsIgnoreCase(st)) badgeClass = "badge-status-rejected";
                        %>
                            <tr>
                                <td class="ps-4">
                                    <h6 class="fw-bold mb-0 text-dark"><%= app.getJobTitle() %></h6>
                                    <span class="small text-muted"><i class="bi bi-geo-alt me-1"></i><%= app.getLocation() %></span>
                                </td>
                                <td class="fw-semibold text-dark"><%= app.getCompanyName() %></td>
                                <td class="small text-muted"><%= app.getAppliedDate() %></td>
                                <td>
                                    <span class="badge <%= badgeClass %> px-3 py-1.5 rounded-pill"><%= st.replace('_', ' ') %></span>
                                </td>
                                <td>
                                    <div class="progress rounded-pill" style="height: 8px; width: 140px; background-color:#e2e8f0;">
                                        <%
                                            int pct = 20;
                                            if ("UNDER_REVIEW".equalsIgnoreCase(st)) pct = 40;
                                            else if ("SHORTLISTED".equalsIgnoreCase(st)) pct = 60;
                                            else if ("TASK_ASSIGNED".equalsIgnoreCase(st)) pct = 75;
                                            else if ("INTERVIEW".equalsIgnoreCase(st)) pct = 90;
                                            else if ("SELECTED".equalsIgnoreCase(st)) pct = 100;
                                            else if ("REJECTED".equalsIgnoreCase(st) || "WITHDRAWN".equalsIgnoreCase(st)) pct = 100;
                                        %>
                                        <div class="progress-bar rounded-pill <%= "REJECTED".equalsIgnoreCase(st) ? "bg-danger" : "bg-success" %>" role="progressbar" style="width: <%= pct %>%;"></div>
                                    </div>
                                </td>
                                <td class="text-end pe-4">
                                    <% if (!"WITHDRAWN".equalsIgnoreCase(st) && !"REJECTED".equalsIgnoreCase(st) && !"SELECTED".equalsIgnoreCase(st)) { %>
                                        <form action="${pageContext.request.contextPath}/withdraw-application" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to withdraw this application?')">
                                            <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">Withdraw</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-folder2-open d-block fs-1 mb-2"></i>
                                    You have not submitted any job applications yet.
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
