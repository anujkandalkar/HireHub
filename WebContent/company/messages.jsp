<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Message, java.util.List" %>
<%
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    request.setAttribute("pageTitle", "Company Messages — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="mb-4">
            <h3 class="fw-bold text-dark mb-1">Recruiter Sent & Received Communications</h3>
            <p class="text-muted mb-0">Direct messages exchanged with applicant candidates</p>
        </div>

        <div class="row g-4">
            <% if (messages != null && !messages.isEmpty()) { 
                for (Message msg : messages) { %>
                    <div class="col-lg-8 mx-auto">
                        <div class="glass-card p-4 mb-3">
                            <div class="d-flex justify-content-between align-items-start mb-2 gap-2">
                                <h5 class="fw-bold mb-1 text-primary"><%= msg.getSubject() %></h5>
                                <span class="small text-muted"><i class="bi bi-clock me-1"></i><%= msg.getSentAt() %></span>
                            </div>
                            <div class="small text-muted mb-3"><i class="bi bi-person me-1 text-secondary"></i>Recipient: <strong><%= msg.getReceiverName() %></strong></div>
                            <p class="text-dark leading-relaxed mb-0" style="line-height: 1.6;"><%= msg.getMessageText() %></p>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="glass-panel p-5 text-center mx-auto" style="max-width: 540px;">
                        <i class="bi bi-chat-left-dots text-muted fs-1 mb-2 d-block"></i>
                        <h4 class="fw-bold text-dark">No Messages Exchanged Yet</h4>
                        <p class="text-muted mb-0">Messages sent to applicants from candidate management will appear here.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
