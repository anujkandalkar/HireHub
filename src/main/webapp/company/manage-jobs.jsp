<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, java.util.List" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "Manage Jobs - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Manage Job Postings</h3>
                <p class="text-muted mb-0">View, edit, toggle active status, or delete posted jobs</p>
            </div>
            <a href="${pageContext.request.contextPath}/company/post-job" class="btn btn-primary rounded-pill px-4"><i class="bi bi-plus-lg me-1"></i>Post New Job</a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Job Title</th>
                            <th>Location</th>
                            <th>Job Type</th>
                            <th>Applications</th>
                            <th>Status</th>
                            <th>Posted Date</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (jobs != null && !jobs.isEmpty()) { 
                            for (Job job : jobs) { 
                                boolean isActive = "ACTIVE".equalsIgnoreCase(job.getStatus());
                        %>
                            <tr>
                                <td class="ps-4">
                                    <h6 class="fw-bold mb-0"><%= job.getTitle() %></h6>
                                    <span class="small text-muted">Skills: <%= job.getRequiredSkills() %></span>
                                </td>
                                <td><%= job.getLocation() %></td>
                                <td><span class="badge bg-light text-dark border"><%= job.getJobType().replace('_', ' ') %></span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/company/applications?jobId=<%= job.getId() %>" class="badge bg-primary rounded-pill px-3 py-1.5 text-decoration-none">
                                        <i class="bi bi-people me-1"></i><%= job.getApplicationCount() %> Applicants
                                    </a>
                                </td>
                                <td>
                                    <span class="badge <%= isActive ? "bg-success" : "bg-secondary" %> rounded-pill px-3 py-1.5"><%= job.getStatus() %></span>
                                </td>
                                <td><%= job.getCreatedAt() %></td>
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-1">
                                        <a href="${pageContext.request.contextPath}/company/edit-job?id=<%= job.getId() %>" class="btn btn-sm btn-outline-primary rounded-circle" title="Edit"><i class="bi bi-pencil"></i></a>
                                        
                                        <form action="${pageContext.request.contextPath}/company/toggle-job-status" method="post" class="d-inline">
                                            <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle" title="Toggle Status"><i class="bi bi-power"></i></button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/company/delete-job" method="post" class="d-inline" onsubmit="return confirm('Delete this job listing?')">
                                            <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle" title="Delete"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">No jobs posted yet. Click 'Post New Job' to create one!</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
