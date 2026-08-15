<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Interview, java.util.List" %>
<%
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    request.setAttribute("pageTitle", "Company Interviews - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Scheduled Company Interviews</h3>
                <p class="text-muted mb-0">Manage technical screens and interview rounds</p>
            </div>
            <a href="${pageContext.request.contextPath}/company/applications" class="btn btn-primary rounded-pill px-4"><i class="bi bi-calendar-plus me-1"></i>Schedule Interview</a>
        </div>

        <div class="row g-4">
            <% if (interviews != null && !interviews.isEmpty()) { 
                for (Interview iv : interviews) { %>
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1"><%= iv.getStudentName() %></h5>
                                    <span class="text-muted small"><%= iv.getJobTitle() %></span>
                                </div>
                                <span class="badge bg-primary px-3 py-1.5 rounded-pill"><%= iv.getInterviewType() %></span>
                            </div>

                            <div class="p-3 bg-light rounded-3 mb-3 border small">
                                <div><strong>Date:</strong> <%= iv.getInterviewDate() %> at <%= iv.getInterviewTime() %></div>
                                <div><strong>Interviewer:</strong> <%= iv.getInterviewerName() != null ? iv.getInterviewerName() : "Recruiter" %></div>
                            </div>

                            <% if (iv.getMeetingLink() != null && !iv.getMeetingLink().isEmpty()) { %>
                                <div class="small text-muted mb-2"><strong>Link:</strong> <a href="<%= iv.getMeetingLink() %>" target="_blank"><%= iv.getMeetingLink() %></a></div>
                            <% } %>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No interviews scheduled yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
