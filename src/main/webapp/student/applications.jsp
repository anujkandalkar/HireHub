<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Application, java.util.List" %>
<%
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "My Applications - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">My Job Applications</h3>
                <p class="text-muted mb-0">Track application progress across all companies</p>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary rounded-pill px-4"><i class="bi bi-plus-lg me-1"></i>Find More Jobs</a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Job Title</th>
                            <th>Company</th>
                            <th>Applied Date</th>
                            <th>Current Status</th>
                            <th>Timeline Progress</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applications != null && !applications.isEmpty()) { 
                            for (Application app : applications) { 
                                String st = app.getStatus();
                                String badgeClass = "bg-secondary";
                                if ("SHORTLISTED".equalsIgnoreCase(st) || "SELECTED".equalsIgnoreCase(st)) badgeClass = "bg-success";
                                else if ("APPLIED".equalsIgnoreCase(st) || "UNDER_REVIEW".equalsIgnoreCase(st)) badgeClass = "bg-primary";
                                else if ("TASK_ASSIGNED".equalsIgnoreCase(st) || "INTERVIEW".equalsIgnoreCase(st)) badgeClass = "bg-warning text-dark";
                                else if ("REJECTED".equalsIgnoreCase(st)) badgeClass = "bg-danger";
                        %>
                            <tr>
                                <td class="ps-4">
                                    <h6 class="fw-bold mb-0"><%= app.getJobTitle() %></h6>
                                    <span class="small text-muted"><%= app.getLocation() %></span>
                                </td>
                                <td><%= app.getCompanyName() %></td>
                                <td><%= app.getAppliedDate() %></td>
                                <td>
                                    <span class="badge <%= badgeClass %> px-3 py-2 rounded-pill"><%= st.replace('_', ' ') %></span>
                                </td>
                                <td>
                                    <div class="progress" style="height: 8px; width: 140px;">
                                        <%
                                            int pct = 20;
                                            if ("UNDER_REVIEW".equalsIgnoreCase(st)) pct = 40;
                                            else if ("SHORTLISTED".equalsIgnoreCase(st)) pct = 60;
                                            else if ("TASK_ASSIGNED".equalsIgnoreCase(st)) pct = 75;
                                            else if ("INTERVIEW".equalsIgnoreCase(st)) pct = 90;
                                            else if ("SELECTED".equalsIgnoreCase(st)) pct = 100;
                                            else if ("REJECTED".equalsIgnoreCase(st) || "WITHDRAWN".equalsIgnoreCase(st)) pct = 100;
                                        %>
                                        <div class="progress-bar <%= "REJECTED".equalsIgnoreCase(st) ? "bg-danger" : "bg-success" %>" role="progressbar" style="width: <%= pct %>%;"></div>
                                    </div>
                                </td>
                                <td class="text-end pe-4">
                                    <% if (!"WITHDRAWN".equalsIgnoreCase(st) && !"REJECTED".equalsIgnoreCase(st) && !"SELECTED".equalsIgnoreCase(st)) { %>
                                        <form action="${pageContext.request.contextPath}/withdraw-application" method="post" class="d-inline" onsubmit="return confirm('Withdraw application?')">
                                            <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill">Withdraw</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">You have not submitted any applications yet.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
