<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, java.util.List" %>
<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    request.setAttribute("pageTitle", "Candidate Directory — Admin");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">Student & Candidate Directory</h3>
                <p class="text-muted mb-0">Browse registered candidates, view resumes, manage account permissions, or block users</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/students" method="get" class="d-flex gap-2">
                <input type="text" name="search" class="form-control rounded-pill px-3" placeholder="Search name or email..." value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
                <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">Search</button>
            </form>
        </div>

        <div class="glass-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Candidate Name</th>
                            <th>Email Address</th>
                            <th>College / Education</th>
                            <th>Skills</th>
                            <th>Resume</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (students != null && !students.isEmpty()) { 
                            for (Student s : students) { %>
                                <tr>
                                    <td class="ps-4 fw-bold">
                                        <a href="${pageContext.request.contextPath}/admin/student-details?id=<%= s.getId() %>" class="text-decoration-none text-dark"><%= s.getFullName() %></a>
                                    </td>
                                    <td><%= s.getEmail() %></td>
                                    <td class="small text-muted"><%= s.getCollegeName() %></td>
                                    <td>
                                        <% if (s.getSkills() != null) {
                                            for (int k = 0; k < Math.min(s.getSkills().size(), 3); k++) { %>
                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle me-1"><%= s.getSkills().get(k) %></span>
                                        <%  }
                                           } %>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="${pageContext.request.contextPath}/resume/view?studentId=<%= s.getId() %>" target="_blank" class="btn btn-outline-danger py-1" title="View PDF Resume">
                                                <i class="bi bi-file-earmark-pdf me-1"></i>View PDF
                                            </a>
                                            <a href="${pageContext.request.contextPath}/resume/download?studentId=<%= s.getId() %>" class="btn btn-outline-secondary py-1" title="Download Resume">
                                                <i class="bi bi-download"></i>
                                            </a>
                                        </div>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1">
                                            <form action="${pageContext.request.contextPath}/admin/user-action" method="post" class="d-inline" onsubmit="return confirm('Block/Unblock this student?')">
                                                <input type="hidden" name="userId" value="<%= s.getUserId() %>">
                                                <input type="hidden" name="action" value="BLOCK">
                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Block User"><i class="bi bi-slash-circle"></i></button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/user-action" method="post" class="d-inline" onsubmit="return confirm('Permanently delete this candidate account?')">
                                                <input type="hidden" name="userId" value="<%= s.getUserId() %>">
                                                <input type="hidden" name="action" value="DELETE">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Delete User"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-person-x fs-1 d-block mb-1"></i>
                                    No candidates found matching your search.
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
