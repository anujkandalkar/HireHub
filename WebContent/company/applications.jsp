<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Application, com.hirehub.model.Job, java.util.List" %>
<%
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    List<Job> companyJobs = (List<Job>) request.getAttribute("companyJobs");
    request.setAttribute("pageTitle", "Applicant Management — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">Applicant Recruitment Pipeline</h3>
                <p class="text-muted mb-0">Review candidate profiles, inspect resumes, shortlist, assign technical tasks, and schedule interviews</p>
            </div>

            <!-- Job Filter Dropdown Form -->
            <form action="${pageContext.request.contextPath}/company/applications" method="get" class="d-flex gap-2">
                <select name="jobId" class="form-select rounded-pill px-3">
                    <option value="">All Job Postings</option>
                    <% if (companyJobs != null) {
                        for (Job j : companyJobs) { %>
                            <option value="<%= j.getId() %>"><%= j.getTitle() %></option>
                    <%  }
                       } %>
                </select>
                <button type="submit" class="btn btn-primary rounded-pill px-3 shadow-sm">Filter</button>
            </form>
        </div>

        <!-- Glass Card Container with Dropdown Overflow Support -->
        <div class="glass-card p-0">
            <div class="table-responsive table-responsive-dropdown">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Candidate Name</th>
                            <th>Applied Position</th>
                            <th>Candidate Resume</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th class="text-end pe-4">Pipeline Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applications != null && !applications.isEmpty()) { 
                            for (Application app : applications) { 
                                String st = app.getStatus();
                                String badgeColor = "bg-primary";
                                if ("SHORTLISTED".equalsIgnoreCase(st)) badgeColor = "bg-info text-dark";
                                else if ("TASK_ASSIGNED".equalsIgnoreCase(st) || "INTERVIEW".equalsIgnoreCase(st)) badgeColor = "bg-warning text-dark";
                                else if ("SELECTED".equalsIgnoreCase(st)) badgeColor = "bg-success";
                                else if ("REJECTED".equalsIgnoreCase(st)) badgeColor = "bg-danger";
                        %>
                            <tr>
                                <td class="ps-4">
                                    <h6 class="fw-bold mb-0 text-dark"><%= app.getStudentName() %></h6>
                                    <span class="small text-muted"><%= app.getStudentEmail() %> &bull; <%= app.getStudentPhone() %></span>
                                </td>
                                <td class="fw-semibold text-dark"><%= app.getJobTitle() %></td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="${pageContext.request.contextPath}/resume/view?studentId=<%= app.getStudentId() %>" target="_blank" class="btn btn-outline-danger px-2.5 py-1" title="View Candidate Resume PDF">
                                            <i class="bi bi-file-earmark-pdf me-1"></i>View PDF
                                        </a>
                                        <a href="${pageContext.request.contextPath}/resume/download?studentId=<%= app.getStudentId() %>" class="btn btn-outline-secondary px-2.5 py-1" title="Download Resume">
                                            <i class="bi bi-download"></i>
                                        </a>
                                    </div>
                                </td>
                                <td class="small text-muted"><%= app.getAppliedDate() %></td>
                                <td><span class="badge <%= badgeColor %> px-3 py-1.5 rounded-pill"><%= st.replace('_', ' ') %></span></td>
                                <td class="text-end pe-4">
                                    <!-- Direct Quick Action Icons + Popper Window Boundary Dropdown -->
                                    <div class="d-inline-flex align-items-center gap-1">
                                        <!-- Quick Shortlist Button -->
                                        <form action="${pageContext.request.contextPath}/update-application-status" method="post" class="d-inline">
                                            <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                            <input type="hidden" name="status" value="SHORTLISTED">
                                            <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Shortlist Candidate">
                                                <i class="bi bi-star-fill"></i>
                                            </button>
                                        </form>

                                        <!-- Quick Task Modal Trigger -->
                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" data-bs-toggle="modal" data-bs-target="#taskModal<%= app.getId() %>" title="Assign Task">
                                            <i class="bi bi-code-slash"></i>
                                        </button>

                                        <!-- Quick Interview Modal Trigger -->
                                        <button type="button" class="btn btn-sm btn-outline-info rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" data-bs-toggle="modal" data-bs-target="#interviewModal<%= app.getId() %>" title="Schedule Interview">
                                            <i class="bi bi-calendar-event"></i>
                                        </button>

                                        <!-- Dropdown Menu with Viewport Boundary (Popper prevents clipping) -->
                                        <div class="dropdown d-inline-block">
                                            <button class="btn btn-sm btn-primary rounded-pill dropdown-toggle shadow-sm px-3" type="button" data-bs-toggle="dropdown" data-bs-boundary="viewport" aria-expanded="false">
                                                Actions
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow-lg">
                                                <li class="dropdown-header text-uppercase small fw-bold text-muted px-3 py-1">Candidate Files</li>
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/resume/view?studentId=<%= app.getStudentId() %>" target="_blank" class="dropdown-item">
                                                        <i class="bi bi-file-earmark-pdf text-danger me-2"></i>View Resume PDF
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/resume/download?studentId=<%= app.getStudentId() %>" class="dropdown-item">
                                                        <i class="bi bi-download text-secondary me-2"></i>Download Resume File
                                                    </a>
                                                </li>
                                                <li><hr class="dropdown-divider my-1"></li>

                                                <li class="dropdown-header text-uppercase small fw-bold text-muted px-3 py-1">Recruitment Actions</li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/update-application-status" method="post">
                                                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                        <input type="hidden" name="status" value="SHORTLISTED">
                                                        <button type="submit" class="dropdown-item"><i class="bi bi-star me-2 text-warning"></i>Shortlist Candidate</button>
                                                    </form>
                                                </li>

                                                <li>
                                                    <button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#taskModal<%= app.getId() %>">
                                                        <i class="bi bi-file-earmark-code me-2 text-primary"></i>Assign Technical Task
                                                    </button>
                                                </li>

                                                <li>
                                                    <button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#interviewModal<%= app.getId() %>">
                                                        <i class="bi bi-calendar-event me-2 text-info"></i>Schedule Interview Round
                                                    </button>
                                                </li>

                                                <li>
                                                    <form action="${pageContext.request.contextPath}/update-application-status" method="post">
                                                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                        <input type="hidden" name="status" value="SELECTED">
                                                        <button type="submit" class="dropdown-item"><i class="bi bi-check-circle me-2 text-success"></i>Select / Offer Position</button>
                                                    </form>
                                                </li>

                                                <li>
                                                    <form action="${pageContext.request.contextPath}/update-application-status" method="post">
                                                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                        <input type="hidden" name="status" value="REJECTED">
                                                        <button type="submit" class="dropdown-item text-danger"><i class="bi bi-x-circle me-2"></i>Reject Application</button>
                                                    </form>
                                                </li>

                                                <li><hr class="dropdown-divider my-1"></li>
                                                <li>
                                                    <button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#msgModal<%= app.getId() %>">
                                                        <i class="bi bi-envelope me-2 text-primary"></i>Send Response Message
                                                    </button>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                    <!-- TASK MODAL -->
                                    <div class="modal fade text-start" id="taskModal<%= app.getId() %>" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content glass-card border-0 shadow-lg">
                                                <div class="modal-header border-bottom">
                                                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-code-slash text-primary me-2"></i>Assign Task to <%= app.getStudentName() %></h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/assign-task" method="post">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Task Title</label>
                                                            <input type="text" name="title" class="form-control" placeholder="e.g. Build REST Servlet Endpoint" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Task Overview</label>
                                                            <textarea name="description" class="form-control" rows="3" required></textarea>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Submission Instructions</label>
                                                            <textarea name="instructions" class="form-control" rows="2" placeholder="e.g. Upload ZIP or paste GitHub repository URL..."></textarea>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Submission Deadline</label>
                                                            <input type="date" name="deadline" class="form-control" required>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-top">
                                                        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary rounded-pill">Assign Task</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- INTERVIEW MODAL -->
                                    <div class="modal fade text-start" id="interviewModal<%= app.getId() %>" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content glass-card border-0 shadow-lg">
                                                <div class="modal-header border-bottom">
                                                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-calendar-event text-info me-2"></i>Schedule Interview for <%= app.getStudentName() %></h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/schedule-interview" method="post">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <div class="modal-body">
                                                        <div class="row g-3">
                                                            <div class="col-md-6">
                                                                <label class="form-label fw-semibold">Interview Date</label>
                                                                <input type="date" name="interviewDate" class="form-control" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label fw-semibold">Interview Time</label>
                                                                <input type="time" name="interviewTime" class="form-control" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label fw-semibold">Interview Type</label>
                                                                <select name="interviewType" class="form-select">
                                                                    <option value="ONLINE">Online Video</option>
                                                                    <option value="OFFLINE">In-Person Office</option>
                                                                    <option value="PHONE">Phone Screen</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label fw-semibold">Interviewer Name</label>
                                                                <input type="text" name="interviewerName" class="form-control" placeholder="Lead Engineer">
                                                            </div>
                                                            <div class="col-12">
                                                                <label class="form-label fw-semibold">Meeting Link / Office Address</label>
                                                                <input type="text" name="meetingLink" class="form-control" placeholder="https://meet.google.com/xyz or office room">
                                                            </div>
                                                            <div class="col-12">
                                                                <label class="form-label fw-semibold">Preparation Notes for Candidate</label>
                                                                <textarea name="notes" class="form-control" rows="2" placeholder="Topics to prepare..."></textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-top">
                                                        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary rounded-pill">Schedule Interview</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- MESSAGE MODAL -->
                                    <div class="modal fade text-start" id="msgModal<%= app.getId() %>" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content glass-card border-0 shadow-lg">
                                                <div class="modal-header border-bottom">
                                                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-envelope text-primary me-2"></i>Send Response to <%= app.getStudentName() %></h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/send-message" method="post">
                                                    <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Subject</label>
                                                            <input type="text" name="subject" class="form-control" value="Update regarding your application for <%= app.getJobTitle() %>" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label fw-semibold">Message Body</label>
                                                            <textarea name="message" class="form-control" rows="4" required placeholder="Type your response message to candidate..."></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-top">
                                                        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary rounded-pill">Send Message</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-1"></i>
                                    No candidate applications match your current criteria.
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
