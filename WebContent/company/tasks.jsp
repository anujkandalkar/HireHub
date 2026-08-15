<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Task, com.hirehub.model.TaskSubmission, java.util.List" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    request.setAttribute("pageTitle", "Review Technical Tasks — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">Technical Tasks & Candidate Submissions</h3>
            <p class="text-muted mb-0">Evaluate submitted code solutions, review GitHub repositories, and post recruiter feedback</p>
        </div>

        <div class="row g-4">
            <% if (tasks != null && !tasks.isEmpty()) { 
                for (Task task : tasks) { 
                    TaskSubmission sub = task.getSubmission();
            %>
                    <div class="col-lg-6">
                        <div class="glass-card p-4 h-100 d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-start mb-3 gap-2">
                                <div>
                                    <h5 class="fw-bold mb-1 text-dark"><%= task.getTitle() %></h5>
                                    <span class="text-muted small"><i class="bi bi-person me-1 text-primary"></i>Candidate: <strong><%= task.getStudentName() %></strong></span>
                                </div>
                                <span class="badge <%= sub != null ? ("PASSED".equalsIgnoreCase(sub.getStatus()) ? "bg-success" : ("FAILED".equalsIgnoreCase(sub.getStatus()) ? "bg-danger" : "bg-info text-dark")) : "bg-warning text-dark" %> rounded-pill px-3 py-1.5 flex-shrink-0">
                                    <%= sub != null ? sub.getStatus() : "WAITING SUBMISSION" %>
                                </span>
                            </div>

                            <p class="text-secondary small mb-3" style="line-height: 1.6;"><%= task.getDescription() %></p>

                            <div class="d-flex justify-content-between align-items-center text-muted small mb-3 p-2.5 glass-panel rounded-3 border">
                                <span><i class="bi bi-calendar-event me-1 text-danger"></i>Deadline: <strong><%= task.getDeadline() %></strong></span>
                                <span><i class="bi bi-briefcase me-1 text-primary"></i>Position: <%= task.getJobTitle() %></span>
                            </div>

                            <div class="mt-auto">
                                <% if (sub != null) { %>
                                    <div class="p-3 glass-panel rounded-3 mb-3 border">
                                        <h6 class="fw-bold mb-2 text-dark"><i class="bi bi-code-slash me-1 text-primary"></i>Candidate Solution Submission:</h6>
                                        <p class="small text-dark mb-2 leading-relaxed"><%= sub.getSubmissionText() %></p>
                                        <% if (sub.getFilePath() != null) { %>
                                            <a href="${pageContext.request.contextPath}/<%= sub.getFilePath() %>" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill mt-1"><i class="bi bi-paperclip me-1"></i>Download Attachment</a>
                                        <% } %>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/review-task" method="post">
                                        <input type="hidden" name="taskId" value="<%= task.getId() %>">
                                        <div class="row g-2 align-items-center">
                                            <div class="col-md-5">
                                                <select name="status" class="form-select form-select-sm">
                                                    <option value="PASSED" <%= "PASSED".equalsIgnoreCase(sub.getStatus()) ? "selected" : "" %>>PASS TASK</option>
                                                    <option value="FAILED" <%= "FAILED".equalsIgnoreCase(sub.getStatus()) ? "selected" : "" %>>FAIL TASK</option>
                                                    <option value="REVIEWED" <%= "REVIEWED".equalsIgnoreCase(sub.getStatus()) ? "selected" : "" %>>UNDER REVIEW</option>
                                                </select>
                                            </div>
                                            <div class="col-md-5">
                                                <input type="text" name="feedback" class="form-control form-control-sm" placeholder="Feedback notes..." value="<%= sub.getFeedback() != null ? sub.getFeedback() : "" %>">
                                            </div>
                                            <div class="col-md-2">
                                                <button type="submit" class="btn btn-sm btn-primary w-100 rounded-pill shadow-sm">Save</button>
                                            </div>
                                        </div>
                                    </form>
                                <% } else { %>
                                    <div class="alert alert-warning glass-card border-warning border-opacity-25 small mb-0">
                                        <i class="bi bi-clock me-1"></i> Candidate has not submitted technical solution yet.
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="glass-panel p-5 text-center">
                        <i class="bi bi-check2-circle text-muted fs-1 mb-2 d-block"></i>
                        <h4 class="fw-bold text-dark">No Tasks Assigned</h4>
                        <p class="text-muted mb-0">When you assign technical tasks to candidate applicants, they will be tracked here.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
