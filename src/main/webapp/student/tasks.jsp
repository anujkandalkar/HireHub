<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Task, com.hirehub.model.TaskSubmission, java.util.List" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    request.setAttribute("pageTitle", "My Technical Tasks - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">My Technical Tasks & Assignments</h3>
            <p class="text-muted mb-0">Review tasks assigned by recruiters and submit your solutions</p>
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
                                    <span class="text-muted small"><i class="bi bi-building me-1"></i><%= task.getCompanyName() %> &bull; <%= task.getJobTitle() %></span>
                                </div>
                                <span class="badge <%= sub != null ? "bg-success" : "bg-warning text-dark" %> rounded-pill px-3 py-1.5">
                                    <%= sub != null ? sub.getStatus() : "ASSIGNED" %>
                                </span>
                            </div>

                            <p class="text-secondary small mb-3"><%= task.getDescription() %></p>
                            
                            <% if (task.getInstructions() != null) { %>
                                <div class="p-3 bg-light rounded-3 small mb-3 border">
                                    <strong>Instructions:</strong> <%= task.getInstructions() %>
                                </div>
                            <% } %>

                            <div class="d-flex justify-content-between align-items-center text-muted small mb-4">
                                <span><i class="bi bi-calendar-event me-1"></i>Deadline: <strong><%= task.getDeadline() %></strong></span>
                                <span>Assigned: <%= task.getAssignedAt() %></span>
                            </div>

                            <% if (sub != null) { %>
                                <div class="alert alert-success border-0 small mb-0">
                                    <i class="bi bi-check-circle-fill me-1"></i> Submitted on <%= sub.getSubmittedAt() %>. Status: <strong><%= sub.getStatus() %></strong>
                                    <% if (sub.getFeedback() != null) { %>
                                        <div class="mt-2 text-dark"><strong>Recruiter Feedback:</strong> <%= sub.getFeedback() %></div>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/submit-task" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="taskId" value="<%= task.getId() %>">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Submission Details / Solution Notes</label>
                                        <textarea name="submissionText" class="form-control form-control-sm" rows="3" placeholder="Paste GitHub link, solution code, or notes..." required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Attachment File (Optional PDF/ZIP/DOC)</label>
                                        <input type="file" name="submissionFile" class="form-control form-control-sm">
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Submit Solution</button>
                                </form>
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
