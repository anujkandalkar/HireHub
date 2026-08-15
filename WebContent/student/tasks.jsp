<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Task, com.hirehub.model.TaskSubmission, java.util.List" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    request.setAttribute("pageTitle", "Technical Tasks — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">My Technical Tasks & Assignments</h3>
            <p class="text-muted mb-0">Review recruiter coding tasks, submit solutions, and track reviewer feedback</p>
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
                                    <span class="text-muted small"><i class="bi bi-building me-1 text-primary"></i><%= task.getCompanyName() %> &bull; <%= task.getJobTitle() %></span>
                                </div>
                                <span class="badge <%= sub != null ? "bg-success" : "bg-warning text-dark" %> rounded-pill px-3 py-1.5 flex-shrink-0">
                                    <%= sub != null ? sub.getStatus() : "ASSIGNED" %>
                                </span>
                            </div>

                            <p class="text-secondary small mb-3" style="line-height: 1.6;"><%= task.getDescription() %></p>
                            
                            <% if (task.getInstructions() != null) { %>
                                <div class="p-3 glass-panel rounded-3 small mb-3 border">
                                    <strong class="text-dark">Instructions:</strong> <%= task.getInstructions() %>
                                </div>
                            <% } %>

                            <div class="d-flex justify-content-between align-items-center text-muted small mb-4">
                                <span><i class="bi bi-calendar-event me-1 text-danger"></i>Deadline: <strong><%= task.getDeadline() %></strong></span>
                                <span>Assigned: <%= task.getAssignedAt() %></span>
                            </div>

                            <div class="mt-auto">
                                <% if (sub != null) { %>
                                    <div class="alert alert-success glass-card border-success border-opacity-25 small mb-0">
                                        <i class="bi bi-check-circle-fill me-1 text-success"></i> Submitted on <%= sub.getSubmittedAt() %>. Status: <strong><%= sub.getStatus() %></strong>
                                        <% if (sub.getFeedback() != null) { %>
                                            <div class="mt-2 text-dark"><strong>Recruiter Feedback:</strong> <%= sub.getFeedback() %></div>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <form action="${pageContext.request.contextPath}/submit-task" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="taskId" value="<%= task.getId() %>">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold small">Submission Notes / GitHub Repository Link</label>
                                            <textarea name="submissionText" class="form-control form-control-sm" rows="3" placeholder="Paste repository URL, solution code, or notes..." required></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold small">Attachment File (Optional ZIP/PDF/DOC)</label>
                                            <input type="file" name="submissionFile" class="form-control form-control-sm">
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 shadow-sm">
                                            <i class="bi bi-send me-1"></i>Submit Solution
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="glass-panel p-5 text-center">
                        <i class="bi bi-check-all text-muted fs-1 mb-2 d-block"></i>
                        <h4 class="fw-bold text-dark">No Pending Tasks</h4>
                        <p class="text-muted mb-0">You currently have no technical assignments assigned to your profile.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
