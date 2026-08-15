<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Interview, java.util.List, java.util.ArrayList, java.util.Date" %>
<%
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviews");
    request.setAttribute("pageTitle", "Scheduled Interviews — HireHub");

    List<Interview> upcoming = new ArrayList<>();
    List<Interview> past = new ArrayList<>();
    Date today = new Date();

    if (interviews != null) {
        for (Interview iv : interviews) {
            if (iv.getInterviewDate() != null && iv.getInterviewDate().before(new java.sql.Date(today.getTime() - 86400000L))) {
                past.add(iv);
            } else {
                upcoming.add(iv);
            }
        }
    }
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">My Scheduled Interviews</h3>
            <p class="text-muted mb-0">Upcoming online and offline interview sessions scheduled by recruiters</p>
        </div>

        <!-- UPCOMING INTERVIEWS SECTION -->
        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-calendar-event me-2 text-primary"></i>Upcoming Interviews (<%= upcoming.size() %>)</h5>
        <div class="row g-4 mb-5">
            <% if (!upcoming.isEmpty()) { 
                for (Interview iv : upcoming) { %>
                    <div class="col-lg-6">
                        <div class="glass-card p-4 h-100 d-flex flex-column border-start border-4 border-primary">
                            <div class="d-flex justify-content-between align-items-start mb-3 gap-2">
                                <div>
                                    <h5 class="fw-bold mb-1 text-dark"><%= iv.getJobTitle() %></h5>
                                    <span class="text-muted small"><i class="bi bi-building me-1 text-primary"></i>Company: <strong><%= iv.getCompanyName() %></strong></span>
                                </div>
                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle px-3 py-1.5 rounded-pill"><%= iv.getInterviewType() %></span>
                            </div>

                            <div class="p-3 glass-panel rounded-3 mb-3 border">
                                <div class="row g-2 small">
                                    <div class="col-6"><strong class="text-dark"><i class="bi bi-calendar-event me-1 text-primary"></i>Date:</strong> <%= iv.getInterviewDate() %></div>
                                    <div class="col-6"><strong class="text-dark"><i class="bi bi-clock me-1 text-info"></i>Time:</strong> <%= iv.getInterviewTime() %></div>
                                    <div class="col-12"><strong class="text-dark"><i class="bi bi-person me-1 text-secondary"></i>Interviewer:</strong> <%= iv.getInterviewerName() != null && !iv.getInterviewerName().isEmpty() ? iv.getInterviewerName() : "Recruitment Team" %></div>
                                </div>
                            </div>

                            <% if (iv.getMeetingLink() != null && !iv.getMeetingLink().isEmpty()) { %>
                                <div class="mb-3">
                                    <a href="<%= iv.getMeetingLink() %>" target="_blank" class="btn btn-primary btn-sm w-100 rounded-pill py-2.5 fw-bold shadow-glow">
                                        <i class="bi bi-camera-video me-1"></i>Join Online Meeting Room
                                    </a>
                                </div>
                            <% } %>

                            <% if (iv.getNotes() != null && !iv.getNotes().isEmpty()) { %>
                                <div class="small text-muted mb-0 mt-auto pt-2 border-top">
                                    <strong class="text-dark"><i class="bi bi-info-circle me-1 text-warning"></i>Preparation Notes:</strong> <%= iv.getNotes() %>
                                </div>
                            <% } %>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-4">
                    <div class="glass-panel p-5 text-center">
                        <i class="bi bi-calendar-x text-muted fs-1 mb-2 d-block"></i>
                        <h4 class="fw-bold text-dark">No Upcoming Interviews</h4>
                        <p class="text-muted mb-0">When an employer schedules an interview session for your application, details will appear here.</p>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- PAST INTERVIEWS SECTION -->
        <% if (!past.isEmpty()) { %>
            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-clock-history me-2 text-secondary"></i>Past & Completed Interviews (<%= past.size() %>)</h5>
            <div class="row g-4">
                <% for (Interview iv : past) { %>
                    <div class="col-lg-6">
                        <div class="glass-card p-4 h-100 opacity-75">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <h6 class="fw-bold text-dark mb-1"><%= iv.getJobTitle() %></h6>
                                    <span class="text-muted small"><%= iv.getCompanyName() %></span>
                                </div>
                                <span class="badge bg-secondary px-3 py-1 rounded-pill"><%= iv.getInterviewType() %></span>
                            </div>
                            <div class="small text-muted">
                                <span>Date: <%= iv.getInterviewDate() %> at <%= iv.getInterviewTime() %></span>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
