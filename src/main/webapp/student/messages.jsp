<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Message, java.util.List" %>
<%
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    request.setAttribute("pageTitle", "Messages - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">Recruiter Responses & Messages</h3>
            <p class="text-muted mb-0">Communications received from hiring managers and recruiters</p>
        </div>

        <div class="row g-4">
            <% if (messages != null && !messages.isEmpty()) { 
                for (Message msg : messages) { %>
                    <div class="col-lg-8 mx-auto">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-3">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold mb-1 text-primary"><%= msg.getSubject() %></h5>
                                <span class="small text-muted"><%= msg.getSentAt() %></span>
                            </div>
                            <div class="small text-muted mb-3"><i class="bi bi-person me-1"></i>From: <%= msg.getSenderName() %></div>
                            <p class="text-dark leading-relaxed mb-0"><%= msg.getMessageText() %></p>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No messages received yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
