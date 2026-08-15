<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Task, com.hirehub.model.TaskSubmission, java.util.List" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    request.setAttribute("pageTitle", "Review Technical Tasks - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">Technical Tasks & Submissions</h3>
            <p class="text-muted mb-0">Track candidate assignments and evaluate submitted code solutions</p>
        </div>

        <div class="row g-4">
            <% if (tasks != null && !tasks.isEmpty()) { 
                for (Task task : tasks) { 
                    TaskSubmission sub = task.getSubmission();
            %>
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1"><%= task.getTitle() %></h5>
                                    <span class="text-muted small"><i class="bi bi-person me-1"></i>Candidate: <strong><%= task.getStudentName() %></strong></span>
                                </div>
                                <span class="badge <%= sub != null ? ("PASSED".equalsIgnoreCase(sub.getStatus()) ? "bg-success" : ("FAILED".equalsIgnoreCase(sub.getStatus()) ? "bg-danger" : "bg-info text-dark")) : "bg-warning text-dark" %> rounded-pill px-3 py-1.5">
                                    <%= sub != null ? sub.getStatus() : "WAITING SUBMISSION" %>
                                </span>
                            </div>

                            <p class="text-secondary small mb-3"><%= task.getDescription() %></p>

                            <div class="d-flex justify-content-between align-items-center text-muted small mb-3 p-2 bg-light rounded">
                                <span>Deadline: <strong><%= task.getDeadline() %></strong></span>
                                <span>Position: <%= task.getJobTitle() %></span>
                            </div>

                            <% if (sub != null) { %>
                                <div class="p-3 bg-light rounded-3 mb-3 border">
                                    <h6 class="fw-bold mb-2">Student Solution Submission:</h6>
                                    <p class="small text-dark mb-2 leading-relaxed"><%= sub.getSubmissionText() %></p>
                                    <% if (sub.getFilePath() != null) { %>
                                        <a href="${pageContext.request.contextPath}/<%= sub.getFilePath() %>" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill"><i class="bi bi-paperclip me-1"></i>Download Attachment</a>
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
                                            <button type="submit" class="btn btn-sm btn-primary w-100 rounded-pill">Save</button>
                                        </div>
                                    </div>
                                </form>
                            <% } else { %>
                                <div class="alert alert-warning border-0 small mb-0">
                                    <i class="bi bi-clock me-1"></i> Candidate has not submitted solution yet.
                                </div>
                            <% } %>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No technical tasks assigned yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
