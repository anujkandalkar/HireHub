<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job" %>
<%
    Job job = (Job) request.getAttribute("job");
    request.setAttribute("pageTitle", "Edit Job — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="glass-card p-4 p-md-5">
                    <h3 class="fw-bold text-dark mb-4"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit Job Opening Details</h3>

                    <% if (job != null) { %>
                        <form action="${pageContext.request.contextPath}/company/edit-job" method="post">
                            <input type="hidden" name="jobId" value="<%= job.getId() %>">
                            <div class="row g-3 mb-4">
                                <div class="col-md-8">
                                    <label class="form-label fw-semibold">Job Title</label>
                                    <input type="text" name="title" class="form-control" value="<%= job.getTitle() %>" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Job Type</label>
                                    <select name="jobType" class="form-select">
                                        <option value="FULL_TIME" <%= "FULL_TIME".equals(job.getJobType()) ? "selected" : "" %>>Full Time</option>
                                        <option value="PART_TIME" <%= "PART_TIME".equals(job.getJobType()) ? "selected" : "" %>>Part Time</option>
                                        <option value="INTERNSHIP" <%= "INTERNSHIP".equals(job.getJobType()) ? "selected" : "" %>>Internship</option>
                                        <option value="CONTRACT" <%= "CONTRACT".equals(job.getJobType()) ? "selected" : "" %>>Contract</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Required Skills (Comma separated)</label>
                                    <input type="text" name="requiredSkills" class="form-control" value="<%= job.getRequiredSkills() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Location</label>
                                    <input type="text" name="location" class="form-control" value="<%= job.getLocation() %>" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Minimum Salary ($/yr)</label>
                                    <input type="number" name="salaryMin" class="form-control" value="<%= (int)job.getSalaryMin() %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Maximum Salary ($/yr)</label>
                                    <input type="number" name="salaryMax" class="form-control" value="<%= (int)job.getSalaryMax() %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Experience Required</label>
                                    <input type="text" name="experienceYears" class="form-control" value="<%= job.getExperienceYears() %>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Vacancies</label>
                                    <input type="number" name="vacancies" class="form-control" value="<%= job.getVacancies() %>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Application Deadline</label>
                                    <input type="date" name="deadline" class="form-control" value="<%= job.getDeadline() != null ? job.getDeadline() : "" %>">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Job Description</label>
                                    <textarea name="description" class="form-control" rows="4" required><%= job.getDescription() %></textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Responsibilities</label>
                                    <textarea name="responsibilities" class="form-control" rows="3"><%= job.getResponsibilities() != null ? job.getResponsibilities() : "" %></textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Requirements</label>
                                    <textarea name="requirements" class="form-control" rows="3"><%= job.getRequirements() != null ? job.getRequirements() : "" %></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/company/manage-jobs" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-glow">Update Job Opening</button>
                            </div>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
