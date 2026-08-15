<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, java.util.List" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    request.setAttribute("pageTitle", "Manage Jobs — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">Manage Published Job Listings</h3>
                <p class="text-muted mb-0">View candidate applicant counts, edit descriptions, toggle active visibility, or delete postings</p>
            </div>
            <a href="${pageContext.request.contextPath}/company/post-job" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-plus-lg me-1"></i>Post New Job
            </a>
        </div>

        <div class="glass-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Job Title</th>
                            <th>Location</th>
                            <th>Type</th>
                            <th>Applicants</th>
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
                                    <h6 class="fw-bold mb-0 text-dark"><%= job.getTitle() %></h6>
                                    <span class="small text-muted">Skills: <%= job.getRequiredSkills() %></span>
                                </td>
                                <td><i class="bi bi-geo-alt me-1 text-primary"></i><%= job.getLocation() %></td>
                                <td><span class="badge bg-light text-dark border px-2.5 py-1"><%= job.getJobType().replace('_', ' ') %></span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/company/applications?jobId=<%= job.getId() %>" class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle rounded-pill px-3 py-1.5 text-decoration-none">
                                        <i class="bi bi-people me-1"></i><%= job.getApplicationCount() %> Applicants
                                    </a>
                                </td>
                                <td>
                                    <span class="badge <%= isActive ? "bg-success" : "bg-secondary" %> rounded-pill px-3 py-1.5"><%= job.getStatus() %></span>
                                </td>
                                <td class="small text-muted"><%= job.getCreatedAt() %></td>
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-1">
                                        <a href="${pageContext.request.contextPath}/company/edit-job?id=<%= job.getId() %>" class="btn btn-sm btn-outline-primary rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Edit"><i class="bi bi-pencil"></i></a>
                                        
                                        <form action="${pageContext.request.contextPath}/company/toggle-job-status" method="post" class="d-inline">
                                            <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Toggle Status"><i class="bi bi-power"></i></button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/company/delete-job" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this job listing?')">
                                            <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Delete"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-briefcase d-block fs-1 mb-2"></i>
                                    No job postings published yet. Click 'Post New Job' to create one!
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
