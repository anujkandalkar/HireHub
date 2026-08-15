<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, com.hirehub.model.Application, java.util.List" %>
<%
    Student student = (Student) request.getAttribute("student");
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    request.setAttribute("pageTitle", "Student Profile Details - Admin");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (student != null) { %>
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h2 class="fw-bold text-dark mb-1"><%= student.getFullName() %></h2>
                        <p class="text-muted mb-0"><%= student.getEmail() %> &bull; <%= student.getPhone() %></p>
                    </div>
                    <% if (student.getResume() != null) { %>
                        <a href="${pageContext.request.contextPath}/<%= student.getResume().getFilePath() %>" target="_blank" class="btn btn-outline-danger rounded-pill px-4">
                            <i class="bi bi-file-earmark-pdf me-1"></i>Download Resume
                        </a>
                    <% } %>
                </div>

                <hr class="my-4">

                <div class="row g-4">
                    <div class="col-md-6">
                        <h6 class="fw-bold">Education & Qualification</h6>
                        <p class="small text-muted mb-1"><strong>Degree:</strong> <%= student.getEducationLevel() %></p>
                        <p class="small text-muted mb-1"><strong>College:</strong> <%= student.getCollegeName() %></p>
                        <p class="small text-muted mb-1"><strong>Graduation Year:</strong> <%= student.getGraduationYear() %></p>
                        <p class="small text-muted"><strong>CGPA:</strong> <%= student.getCgpa() %></p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="fw-bold">Skills List</h6>
                        <div>
                            <% if (student.getSkills() != null) {
                                for (String sk : student.getSkills()) { %>
                                    <span class="skill-tag border px-3 py-1 fs-6 me-2 mb-2"><%= sk %></span>
                            <%  }
                               } %>
                        </div>
                    </div>
                    <div class="col-12">
                        <h6 class="fw-bold">Bio / Professional Summary</h6>
                        <p class="small text-secondary"><%= student.getBio() %></p>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold text-dark mb-3">Application History (<%= apps != null ? apps.size() : 0 %>)</h5>
            <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Job</th>
                                <th>Company</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (apps != null && !apps.isEmpty()) { 
                                for (Application a : apps) { %>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%= a.getJobTitle() %></td>
                                        <td><%= a.getCompanyName() %></td>
                                        <td><%= a.getAppliedDate() %></td>
                                        <td><span class="badge bg-primary px-3 py-1.5 rounded-pill"><%= a.getStatus() %></span></td>
                                    </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="4" class="text-center py-4 text-muted">No applications.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
