<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Interview, java.util.List" %>
<%
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    request.setAttribute("pageTitle", "Company Scheduled Interviews — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">Scheduled Recruiter Interviews</h3>
                <p class="text-muted mb-0">Manage technical screens, video sessions, and candidate interview rounds</p>
            </div>
            <a href="${pageContext.request.contextPath}/company/applications" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-calendar-plus me-1"></i>Schedule New Interview
            </a>
        </div>

        <div class="row g-4">
            <% if (interviews != null && !interviews.isEmpty()) { 
                for (Interview iv : interviews) { %>
                    <div class="col-lg-6">
                        <div class="glass-card p-4 h-100 d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-start mb-3 gap-2">
                                <div>
                                    <h5 class="fw-bold mb-1 text-dark"><%= iv.getStudentName() %></h5>
                                    <span class="text-muted small"><i class="bi bi-briefcase me-1 text-primary"></i>Job: <%= iv.getJobTitle() %></span>
                                </div>
                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle px-3 py-1.5 rounded-pill"><%= iv.getInterviewType() %></span>
                            </div>

                            <div class="p-3 glass-panel rounded-3 mb-3 border small">
                                <div class="mb-1"><strong class="text-dark"><i class="bi bi-calendar-event me-1 text-primary"></i>Date & Time:</strong> <%= iv.getInterviewDate() %> at <%= iv.getInterviewTime() %></div>
                                <div><strong class="text-dark"><i class="bi bi-person me-1 text-secondary"></i>Interviewer:</strong> <%= iv.getInterviewerName() != null ? iv.getInterviewerName() : "Recruitment Team" %></div>
                            </div>

                            <% if (iv.getMeetingLink() != null && !iv.getMeetingLink().isEmpty()) { %>
                                <div class="small text-muted mb-2 mt-auto">
                                    <strong class="text-dark"><i class="bi bi-link-45deg me-1"></i>Meeting Link:</strong> 
                                    <a href="<%= iv.getMeetingLink() %>" target="_blank" class="text-decoration-none text-primary font-semibold"><%= iv.getMeetingLink() %></a>
                                </div>
                            <% } %>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="glass-panel p-5 text-center">
                        <i class="bi bi-calendar-x text-muted fs-1 mb-2 d-block"></i>
                        <h4 class="fw-bold text-dark">No Scheduled Interviews</h4>
                        <p class="text-muted mb-0">Use the Applicant Pipeline dashboard to schedule interview rounds with candidate applicants.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
