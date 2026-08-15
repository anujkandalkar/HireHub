<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Student, com.hirehub.model.Resume, java.util.List" %>
<%
    Student student = (Student) request.getAttribute("student");
    if (student == null) student = (Student) session.getAttribute("studentProfile");
    Resume resume = student != null ? student.getResume() : null;
    request.setAttribute("pageTitle", "My Profile - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row g-4">
            <!-- Sidebar Navigation -->
            <div class="col-lg-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white text-center">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-3 fs-1 rounded-circle d-flex align-items-center justify-content-center" style="width:72px; height:72px;">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <h5 class="fw-bold mb-1"><%= student != null && student.getFullName() != null ? student.getFullName() : "Student Profile" %></h5>
                    <p class="text-muted small mb-3"><%= student != null && student.getEmail() != null ? student.getEmail() : "" %></p>
                    <span class="badge bg-primary bg-opacity-10 text-primary mb-3">Profile Completion: <%= student != null ? student.getProfileCompletionPercentage() : 20 %>%</span>

                    <div class="list-group list-group-flush text-start border-top pt-3">
                        <a href="#personal-sec" class="list-group-item list-group-item-action border-0 fw-semibold text-primary"><i class="bi bi-person me-2"></i>Personal Info</a>
                        <a href="#education-sec" class="list-group-item list-group-item-action border-0 fw-semibold text-dark"><i class="bi bi-journal-bookmark me-2"></i>Education</a>
                        <a href="#skills-sec" class="list-group-item list-group-item-action border-0 fw-semibold text-dark"><i class="bi bi-stars me-2"></i>Skills</a>
                        <a href="#resume-sec" class="list-group-item list-group-item-action border-0 fw-semibold text-dark"><i class="bi bi-file-earmark-pdf me-2"></i>Resume</a>
                    </div>
                </div>
            </div>

            <!-- Profile Editor -->
            <div class="col-lg-9">
                <!-- Personal Info Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4" id="personal-sec">
                    <h4 class="fw-bold text-dark mb-4"><i class="bi bi-person-vcard me-2 text-primary"></i>Personal Information</h4>
                    <form action="${pageContext.request.contextPath}/student/profile-update" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="<%= student != null && student.getFullName() != null ? student.getFullName() : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="text" name="phone" class="form-control" value="<%= student != null && student.getPhone() != null ? student.getPhone() : "" %>">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Gender</label>
                                <select name="gender" class="form-select">
                                    <option value="Male" <%= student != null && "Male".equals(student.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= student != null && "Female".equals(student.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="Other" <%= student != null && "Other".equals(student.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Date of Birth</label>
                                <input type="date" name="dob" class="form-control" value="<%= student != null && student.getDob() != null ? student.getDob() : "" %>">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">CGPA / Score</label>
                                <input type="number" step="0.01" name="cgpa" class="form-control" value="<%= student != null ? student.getCgpa() : 0.0 %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">City</label>
                                <input type="text" name="city" class="form-control" value="<%= student != null && student.getCity() != null ? student.getCity() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">State</label>
                                <input type="text" name="state" class="form-control" value="<%= student != null && student.getState() != null ? student.getState() : "" %>">
                            </div>
                            <div class="col-md-6" id="education-sec">
                                <label class="form-label fw-semibold">Degree / Qualification</label>
                                <input type="text" name="educationLevel" class="form-control" value="<%= student != null && student.getEducationLevel() != null ? student.getEducationLevel() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">College / University Name</label>
                                <input type="text" name="collegeName" class="form-control" value="<%= student != null && student.getCollegeName() != null ? student.getCollegeName() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Graduation Year</label>
                                <input type="number" name="graduationYear" class="form-control" value="<%= student != null ? student.getGraduationYear() : 2024 %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Professional Summary / Bio</label>
                                <textarea name="bio" class="form-control" rows="3"><%= student != null && student.getBio() != null ? student.getBio() : "" %></textarea>
                            </div>
                            <div class="col-12 text-end mt-3">
                                <button type="submit" class="btn btn-primary rounded-pill px-4">Save Personal Info</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Skills Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4" id="skills-sec">
                    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-stars me-2 text-warning"></i>Technical Skills</h4>
                    <p class="text-muted small mb-3">Skills are used by HireHub smart recommendation engine to calculate job compatibility scores.</p>
                    
                    <form action="${pageContext.request.contextPath}/student/skills-update" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Skills List (Comma separated)</label>
                            <input type="text" name="skills" class="form-control" placeholder="Java, SQL, HTML, CSS, JavaScript, JDBC, Servlets, MySQL" value="<%= student != null && student.getSkills() != null ? String.join(", ", student.getSkills()) : "" %>">
                        </div>

                        <div class="mb-3">
                            <% if (student != null && student.getSkills() != null) {
                                for (String sk : student.getSkills()) { %>
                                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle px-3 py-2 fs-6 me-2 mb-2"><%= sk %></span>
                            <%  }
                               } %>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-primary rounded-pill px-4">Update Skills</button>
                        </div>
                    </form>
                </div>

                <!-- Resume Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white" id="resume-sec">
                    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-file-earmark-pdf me-2 text-danger"></i>Resume Management</h4>
                    <p class="text-muted small mb-4">View, download, or update your uploaded resume (PDF, DOC, or DOCX format, max 5 MB).</p>

                    <% if (resume != null && resume.getFileName() != null) { %>
                        <div class="p-3 bg-light rounded-3 d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 border g-3">
                            <div class="d-flex align-items-center mb-2 mb-md-0">
                                <i class="bi bi-file-earmark-pdf-fill fs-1 text-danger me-3"></i>
                                <div>
                                    <h6 class="fw-bold mb-0"><%= resume.getFileName() %></h6>
                                    <span class="small text-muted">Uploaded: <%= resume.getUploadedAt() != null ? resume.getUploadedAt() : "Active" %></span>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/resume/view?studentId=<%= student.getId() %>" target="_blank" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                    <i class="bi bi-eye me-1"></i>View Resume
                                </a>
                                <a href="${pageContext.request.contextPath}/resume/download?studentId=<%= student.getId() %>" class="btn btn-primary btn-sm rounded-pill px-3">
                                    <i class="bi bi-download me-1"></i>Download Resume
                                </a>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="alert alert-warning border-0 rounded-3 mb-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>No resume uploaded yet. Please upload your resume below.
                        </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/student/resume-upload" method="post" enctype="multipart/form-data" onsubmit="return validateProfileResumeUpload(this)">
                        <div class="mb-3">
                            <label class="form-label fw-semibold"><%= (resume != null) ? "Replace Resume" : "Upload Resume" %> (PDF, DOC, DOCX — Max 5 MB)</label>
                            <input type="file" name="resumeFile" id="profileResumeFile" class="form-control" accept=".pdf,.doc,.docx" required onchange="validateResumeInput(this)">
                            <div class="text-danger small mt-1" id="profileResumeError" style="display:none;"></div>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-primary rounded-pill px-4"><i class="bi bi-upload me-1"></i><%= (resume != null) ? "Replace Resume" : "Upload Resume" %></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
function validateResumeInput(input) {
    var errDiv = document.getElementById('profileResumeError');
    errDiv.style.display = 'none';
    errDiv.innerText = '';

    if (!input.files || input.files.length === 0) return true;

    var file = input.files[0];
    var maxBytes = 5 * 1024 * 1024;
    var allowedExts = ['.pdf', '.doc', '.docx'];

    var fileName = file.name.toLowerCase();
    var isValidExt = allowedExts.some(function(ext) {
        return fileName.endsWith(ext);
    });

    if (!isValidExt) {
        errDiv.innerText = 'Invalid file format. Only PDF, DOC, and DOCX files are allowed.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    if (file.size > maxBytes) {
        errDiv.innerText = 'Resume size must not exceed 5 MB.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    if (file.size === 0) {
        errDiv.innerText = 'The selected file is empty.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    return true;
}

function validateProfileResumeUpload(form) {
    var fileInput = document.getElementById('profileResumeFile');
    return validateResumeInput(fileInput);
}
</script>

<jsp:include page="/includes/footer.jsp" />
