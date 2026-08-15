<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Interview, java.util.List" %>
<%
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    request.setAttribute("pageTitle", "Scheduled Interviews - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">My Scheduled Interviews</h3>
            <p class="text-muted mb-0">Upcoming online and offline interview sessions</p>
        </div>

        <div class="row g-4">
            <% if (interviews != null && !interviews.isEmpty()) { 
                for (Interview iv : interviews) { %>
                    <div class="col-lg-6">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1"><%= iv.getJobTitle() %></h5>
                                    <span class="text-muted small"><i class="bi bi-building me-1"></i><%= iv.getCompanyName() %></span>
                                </div>
                                <span class="badge bg-primary px-3 py-1.5 rounded-pill"><%= iv.getInterviewType() %></span>
                            </div>

                            <div class="p-3 bg-light rounded-3 mb-3 border">
                                <div class="row g-2 small">
                                    <div class="col-6"><strong>Date:</strong> <%= iv.getInterviewDate() %></div>
                                    <div class="col-6"><strong>Time:</strong> <%= iv.getInterviewTime() %></div>
                                    <div class="col-12"><strong>Interviewer:</strong> <%= iv.getInterviewerName() != null ? iv.getInterviewerName() : "Recruitment Team" %></div>
                                </div>
                            </div>

                            <% if (iv.getMeetingLink() != null && !iv.getMeetingLink().isEmpty()) { %>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Meeting Link / Address</label>
                                    <a href="<%= iv.getMeetingLink() %>" target="_blank" class="btn btn-outline-primary btn-sm w-100 rounded-pill"><i class="bi bi-camera-video me-1"></i>Join Online Interview</a>
                                </div>
                            <% } %>

                            <% if (iv.getNotes() != null && !iv.getNotes().isEmpty()) { %>
                                <p class="small text-muted mb-0"><strong>Preparation Notes:</strong> <%= iv.getNotes() %></p>
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
