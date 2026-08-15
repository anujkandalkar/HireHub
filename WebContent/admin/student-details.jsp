<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, com.hirehub.model.Application, java.util.List" %>
<%
    Student student = (Student) request.getAttribute("student");
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "Candidate Profile — Admin Review");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (student != null) { %>
            <div class="glass-card p-4 p-md-5 mb-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-start mb-4 gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="company-avatar" style="width:56px; height:56px; font-size:1.6rem;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div>
                            <h2 class="fw-bold text-dark mb-1"><%= student.getFullName() %></h2>
                            <p class="text-muted mb-0"><i class="bi bi-envelope me-1 text-primary"></i><%= student.getEmail() %> &bull; <i class="bi bi-telephone me-1 text-info"></i><%= student.getPhone() %></p>
                        </div>
                    </div>
                    <% if (student.getResume() != null) { %>
                        <a href="${pageContext.request.contextPath}/<%= student.getResume().getFilePath() %>" target="_blank" class="btn btn-outline-danger rounded-pill px-4 flex-shrink-0">
                            <i class="bi bi-file-earmark-pdf me-1"></i>View Candidate Resume
                        </a>
                    <% } %>
                </div>

                <hr class="my-4 border-secondary opacity-25">

                <div class="row g-4">
                    <div class="col-md-6">
                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-journal-bookmark me-1 text-primary"></i>Education & Qualifications</h6>
                        <p class="small text-muted mb-1"><strong>Degree:</strong> <%= student.getEducationLevel() %></p>
                        <p class="small text-muted mb-1"><strong>College:</strong> <%= student.getCollegeName() %></p>
                        <p class="small text-muted mb-1"><strong>Graduation Year:</strong> <%= student.getGraduationYear() %></p>
                        <p class="small text-muted"><strong>CGPA Score:</strong> <%= student.getCgpa() %></p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-stars me-1 text-warning"></i>Technical Skills</h6>
                        <div>
                            <% if (student.getSkills() != null) {
                                for (String sk : student.getSkills()) { %>
                                    <span class="skill-tag border px-3 py-1 fs-6 me-2 mb-2"><%= sk %></span>
                            <%  }
                               } %>
                        </div>
                    </div>
                    <div class="col-12">
                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-file-text me-1 text-secondary"></i>Bio / Professional Summary</h6>
                        <p class="small text-secondary leading-relaxed mb-0" style="line-height: 1.6;"><%= student.getBio() %></p>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-kanban me-2 text-primary"></i>Application History (<%= apps != null ? apps.size() : 0 %>)</h5>
            <div class="glass-card overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Job Title</th>
                                <th>Company</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (apps != null && !apps.isEmpty()) { 
                                for (Application a : apps) { %>
                                    <tr>
                                        <td class="ps-4 fw-bold text-dark"><%= a.getJobTitle() %></td>
                                        <td class="fw-semibold text-dark"><%= a.getCompanyName() %></td>
                                        <td class="small text-muted"><%= a.getAppliedDate() %></td>
                                        <td><span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1.5 rounded-pill"><%= a.getStatus() %></span></td>
                                    </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="4" class="text-center py-4 text-muted">No applications submitted yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
